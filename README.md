# Minecraft Hypixel Security

Este é um **repositório educacional** focado em **segurança para jogadores de Minecraft**, com ênfase no servidor **Hypixel**.  
Aqui você vai aprender a **olhar, analisar e se proteger**, sem precisar quebrar nada — tudo de forma **local e segura**.

---

## Idiomas disponíveis
- Português (pt-BR)
- English (en-US)

---

## Plataformas
- Linux
- Windows

---

## Scripts incluídos
Atualmente, temos scripts de **checagem de segurança Linux**:

1. `basic_security_check.sh`  
   - Observa processos, portas abertas, arquivos perigosos  
   - Não coleta nem envia dados  
   - Só olha e julga 😏

2. `minecraft_mod_check.sh`  
   - Lista os mods instalados  
   - Calcula hashes SHA256  
   - Não executa nada, só observa  
   - Mods suspeitos serão **olhados com desconfiança amigável** 👀

> Este projeto **não oferece cheats, hacks ou bypasses**.  
> É educacional, seguro e divertido.

---

## Como executar (Linux)
1. Abra o terminal na pasta do script:

```bash
cd scripts/linux
chmod +x basic_security_check.sh minecraft_mod_check.sh
./basic_security_check.sh
./minecraft_mod_check.sh
# Minecraft Hypixel Security

Educational repository focused on security awareness for Minecraft players,
with emphasis on Hypixel.

## Languages
- Português (pt-br)
- English (en-us)

## Platforms
- Linux
- Windows

## Scripts
This repository contains **local security check scripts**.
They are read-only and do NOT collect or send data.

This project does not provide cheats, hacks, or bypasses.
