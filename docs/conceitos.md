# Conceitos

## SSH
SSH (Secure Shell) é o protocolo de acesso remoto seguro ao terminal de uma
máquina, operando por padrão na porta TCP 22. Ele cria um canal criptografado
entre cliente e servidor e, sobre esse canal, autentica o usuário. As duas
formas mais comuns de autenticação são:

- **Por senha**: o usuário envia login e senha, que o servidor valida.
- **Por chave pública**: o cliente prova que possui a chave privada
  correspondente a uma chave pública já autorizada no servidor — mais seguro,
  pois não há senha a ser adivinhada.

A autenticação **por senha** é a que fica exposta à força bruta: como aceita
tentativas repetidas, um atacante pode testar inúmeras combinações.

## Brute force
Ataque de força bruta é a tentativa de adivinhar credenciais testando muitas
possibilidades de forma automatizada. Variações principais:

- **Ataque de dicionário**: usa uma lista (wordlist) de senhas comuns ou
  vazadas, em vez de todas as combinações — mais rápido e eficaz na prática.
- **Força bruta pura**: testa todas as combinações de caracteres; inviável
  para senhas longas, mas de cobertura total.
- **Credential stuffing**: reutiliza pares usuário:senha vazados de outros
  serviços, apostando que a pessoa repete a mesma senha.
- **Password spraying**: testa poucas senhas muito comuns contra muitos
  usuários, para não disparar o bloqueio por excesso de tentativas numa conta.

O ataque deste projeto é do tipo **dicionário**, contra um único usuário.

## Logs
No Linux, os eventos de autenticação do SSH são registrados em dois lugares
equivalentes:

- **journal do systemd**: consultado com `journalctl -u ssh`.
- **arquivo de texto**: `/var/log/auth.log` (em distribuições Debian/Kali).

Linhas relevantes para a investigação:

- `Failed password for <user> from <IP> port <porta>` — tentativa malsucedida.
- `Failed password for invalid user <user> ...` — o "invalid user" indica que
  a conta nem existe no sistema (sinal de chute de usuário).
- `Accepted password for <user> ...` — login bem-sucedido (a linha que
  confirmaria um comprometimento).

Cada linha traz carimbo de data/hora, usuário-alvo e IP de origem — os campos
que sustentam a análise.