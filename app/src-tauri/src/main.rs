#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use serde::Serialize;
use std::{
  fs,
  path::PathBuf,
  process::Command,
};

#[derive(Serialize)]
struct CheckResult {
  ok: bool,
  exit_code: Option<i32>,
  stdout: String,
  stderr: String,
}

#[derive(Debug)]
enum ScriptKind {
  LinuxBash,
  WindowsPwsh,
}

#[derive(Debug)]
struct AllowedCheck {
  rel_path_from_tauri: &'static str, // relative to app/src-tauri
  kind: ScriptKind,
}

fn allowlist(check_id: &str) -> Option<AllowedCheck> {
  match check_id {
    // Linux scripts
    "linux_system" => Some(AllowedCheck {
      rel_path_from_tauri: "../../scripts/linux/basic_security_check.sh",
      kind: ScriptKind::LinuxBash,
    }),
    "linux_mods" => Some(AllowedCheck {
      rel_path_from_tauri: "../../scripts/linux/minecraft_mod_check.sh",
      kind: ScriptKind::LinuxBash,
    }),
    "linux_network" => Some(AllowedCheck {
      rel_path_from_tauri: "../../scripts/linux/network_awareness_check.sh",
      kind: ScriptKind::LinuxBash,
    }),
        "linux_lunar" => Some(AllowedCheck {
      rel_path_from_tauri: "../../scripts/linux/lunar_hypixel_baseline.sh",
      kind: ScriptKind::LinuxBash,
    }),


    // Windows script
    "windows_network" => Some(AllowedCheck {
      rel_path_from_tauri: "../../scripts/windows/network_awareness_check.ps1",
      kind: ScriptKind::WindowsPwsh,
    }),

    _ => None,
  }
}

/// Resolve a path safely and block attempts to escape the repo boundary.
fn resolve_script_path(rel: &str) -> Result<PathBuf, String> {
  // In dev, CARGO_MANIFEST_DIR points to: .../app/src-tauri
  let tauri_dir = PathBuf::from(
    option_env!("CARGO_MANIFEST_DIR")
      .ok_or_else(|| "CARGO_MANIFEST_DIR not available. Are you running a dev build?".to_string())?,
  );

  let candidate = tauri_dir.join(rel);

  let script = candidate
    .canonicalize()
    .map_err(|e| format!("Script not found or not accessible: {e}"))?;

  // Repo root is two levels up from app/src-tauri => .../ (minecraft-hypixel-security)
  let repo_root = tauri_dir
    .parent()
    .and_then(|p| p.parent())
    .ok_or_else(|| "Failed to resolve repo root from src-tauri.".to_string())?
    .canonicalize()
    .map_err(|e| format!("Failed to canonicalize repo root: {e}"))?;

  if !script.starts_with(&repo_root) {
    return Err("Blocked: script path escapes repository boundary.".into());
  }

  Ok(script)
}

fn bytes_to_string(b: Vec<u8>) -> String {
  String::from_utf8_lossy(&b).to_string()
}

#[tauri::command]
fn run_check(check_id: String, verbose: bool) -> Result<CheckResult, String> {
  let allowed = allowlist(&check_id).ok_or_else(|| "Blocked: unknown check_id (not in allowlist).".to_string())?;
  let script_path = resolve_script_path(allowed.rel_path_from_tauri)?;

  match allowed.kind {
    ScriptKind::LinuxBash => {
      #[cfg(not(target_os = "linux"))]
      return Err("This check is Linux-only.".into());

      #[cfg(target_os = "linux")]
      {
        let output = Command::new("bash")
          .arg(&script_path)
          // safer than passing random flags; scripts can read VERBOSE=1 if you want later
          .env("VERBOSE", if verbose { "1" } else { "0" })
          .output()
          .map_err(|e| format!("Failed to run bash script: {e}"))?;

        Ok(CheckResult {
          ok: output.status.success(),
          exit_code: output.status.code(),
          stdout: bytes_to_string(output.stdout),
          stderr: bytes_to_string(output.stderr),
        })
      }
    }

    ScriptKind::WindowsPwsh => {
      #[cfg(not(target_os = "windows"))]
      return Err("This check is Windows-only.".into());

      #[cfg(target_os = "windows")]
      {
        // Prefer pwsh if present; fallback to Windows PowerShell
        let ps = if Command::new("pwsh").arg("-v").output().is_ok() {
          "pwsh"
        } else {
          "powershell"
        };

        let mut cmd = Command::new(ps);
        cmd.arg("-NoProfile")
          .arg("-ExecutionPolicy")
          .arg("Bypass")
          .arg("-File")
          .arg(&script_path);

        if verbose {
          cmd.arg("-VerboseMode");
        }

        let output = cmd.output().map_err(|e| format!("Failed to run PowerShell script: {e}"))?;

        Ok(CheckResult {
          ok: output.status.success(),
          exit_code: output.status.code(),
          stdout: bytes_to_string(output.stdout),
          stderr: bytes_to_string(output.stderr),
        })
      }
    }
  }
}

#[tauri::command]
fn save_report(filename: String, content: String) -> Result<String, String> {
  let tauri_dir = PathBuf::from(
    option_env!("CARGO_MANIFEST_DIR")
      .ok_or_else(|| "CARGO_MANIFEST_DIR not available.".to_string())?,
  );

  // repo root: .../minecraft-hypixel-security (two levels above app/src-tauri)
  let repo_root = tauri_dir
    .parent()
    .and_then(|p| p.parent())
    .ok_or_else(|| "Failed to resolve repo root.".to_string())?
    .to_path_buf();

  let reports_dir = repo_root.join("reports");
  fs::create_dir_all(&reports_dir).map_err(|e| format!("Failed to create reports dir: {e}"))?;

  // basic filename safety
  let safe = filename
    .replace("..", "")
    .replace('/', "_")
    .replace('\\', "_")
    .replace(':', "_");

  let path = reports_dir.join(safe);
  fs::write(&path, content).map_err(|e| format!("Failed to write report: {e}"))?;

  Ok(path.to_string_lossy().to_string())
}


fn main() {
  tauri::Builder::default()
    .invoke_handler(tauri::generate_handler![run_check, save_report])
    .run(tauri::generate_context!())
    .expect("error while running tauri application");
}
