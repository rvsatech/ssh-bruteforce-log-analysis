# Relatório de Análise — Brute Force SSH

| Campo          | Valor                                            |
|----------------|--------------------------------------------------|
| Analista       | rvsatech                                         |
| Data           | 2026-10-27                                       |
| Classificação  | Tentativa de acesso não autorizado (brute force) |
| Ativo afetado  | Servidor SSH (OpenSSH) — porta 22                |
| Severidade     | Média (tentativa detectada, sem comprometimento) |
| Status         | Encerrado — sem acesso bem-sucedido              |

## 1. Resumo executivo
Ataque de força bruta automatizado contra o SSH, mirando o usuário `admin`
(inexistente), a partir de 127.0.0.1. Foram 24 tentativas falhadas em duas
rajadas (19:54 e 21:35). Nenhum login aceito — sem comprometimento.

## 2. Escopo e ambiente
Laboratório próprio e isolado (Kali Linux em VM). Ativo: OpenSSH em
0.0.0.0:22. Evidências extraídas do journal (`journalctl -u ssh`). Ataque
gerado de forma controlada contra 127.0.0.1, apenas para estudo. Detalhes
em `docs/escopo.md`.

## 3. Metodologia
Ciclo detectar → investigar → concluir → recomendar.
- Cenário gerado com: `hydra -l admin -P pass-list.txt ssh://127.0.0.1 -t 4`
- Análise automatizada em `scripts/analise-logs.sh` (contagem de falhas,
  origem, usuário-alvo e verificação de sucesso via `journalctl` + `grep`).

## 4. Evidências
- `evidencias/01-ataque-hydra.png` — execução do ataque.
- `evidencias/02-analise-resultado.png` — saída da análise.
- `evidencias/logs/falhas-login.txt`, `resultado-analise.txt` — saídas em texto.

Amostra dos registros (duas rajadas):

    Oct 27 19:54:31 kali sshd-session[720672]: Failed password for invalid user admin from 127.0.0.1 port 56750 ssh2
    Oct 27 21:35:51 kali sshd-session[29456]: Failed password for invalid user admin from 127.0.0.1 port 51472 ssh2
    Oct 27 21:35:53 kali sshd-session[29454]: Failed password for invalid user admin from 127.0.0.1 port 51438 ssh2

## 5. Análise
- **Volume e cadência:** 24 falhas em duas rajadas curtas — ritmo impossível
  para digitação humana, típico de ferramenta automatizada (Hydra).
- **Alvo inexistente:** todas contra `admin`, marcado como `invalid user` —
  chute de conta comum, sem conhecimento interno do sistema.
- **Assinatura de automação:** conexões em paralelo (coerente com `-t 4`),
  com PIDs e portas de origem se repetindo (mesma conexão testando várias
  senhas).
- **Origem única:** 127.0.0.1 em todas as tentativas.

## 6. Conclusão
Ataque de força bruta automatizado contra a conta `admin`, em duas rajadas.
**Falhou**: nenhum `Accepted password` registrado, sem impacto sobre o ativo.
Classificado como tentativa de intrusão sem comprometimento.

## 7. Recomendações
- **fail2ban** — bloquear IPs após X falhas.
- **Chave SSH** — `PasswordAuthentication no` + autenticação por chave.
- **`MaxAuthTries`** — reduzir tentativas por conexão.
- **Firewall** — não expor o SSH a 0.0.0.0 sem necessidade.
- **Monitoramento** — alertar em picos de `Failed password`.
- **MFA** — camada extra de autenticação.