# Análise de Logs de Brute Force SSH

## Contexto
Investigação defensiva de um ataque de força bruta ao serviço SSH, feita a
partir dos logs de autenticação. O objetivo foi detectar o ataque, atribuir
sua origem, identificar o usuário-alvo e confirmar se houve comprometimento —
o ciclo de trabalho típico de um analista de SOC. O ambiente é um laboratório
próprio e isolado (Kali Linux em VM VirtualBox), onde o cenário de ataque foi
gerado de forma controlada contra a própria máquina (127.0.0.1), apenas para
fins de estudo. Objetivo e critério de aceite em `docs/escopo.md`.

## Como reproduzir
Pré-requisitos: Kali Linux, servidor OpenSSH ativo e Hydra (já incluído no Kali).

1. Ative o servidor SSH: `sudo systemctl enable --now ssh`
2. Gere o cenário de ataque (controlado, contra a própria máquina):
   `hydra -l admin -P pass-list.txt ssh://127.0.0.1 -t 4`
3. Execute a análise dos logs: `sudo ./scripts/analise-logs.sh`
4. Compare o resultado com as conclusões em `relatorio/relatorio.md`

## Resultado
Ataque de força bruta automatizado detectado contra o usuário `admin`
(inexistente no sistema), originado de 127.0.0.1, com as tentativas
concentradas em poucos segundos — padrão incompatível com ação humana e
típico de ferramenta automatizada. Nenhum login bem-sucedido: o ativo não
foi comprometido. Análise completa em `relatorio/relatorio.md`.

## Estrutura do repositório
```
├── README.md          → visão geral, como reproduzir, resultado
├── docs/
│   ├── escopo.md      → objetivo, ambiente e critério de "pronto"
│   └── conceitos.md   → teoria (SSH, brute force, logs)
├── evidencias/        → prints da tela
│   └── logs/          → saídas em texto (falhas-login.txt etc.)
├── scripts/           → comandos usados, para reprodutibilidade
└── relatorio/
    └── relatorio.md   → análise formal
```