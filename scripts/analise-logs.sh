#!/usr/bin/env bash
#
# analise-logs.sh
# Investiga tentativas de brute force no SSH a partir do journal do systemd:
# conta as falhas, identifica a origem (IP) e o usuario-alvo, e verifica se
# houve login bem-sucedido.
#
# Pre-requisitos:
#   - Servico SSH ativo:
#       sudo systemctl enable --now ssh
#   - (opcional) gerar o cenario de ataque para ter o que analisar:
#       hydra -l admin -P pass-list.txt ssh://127.0.0.1 -t 4
#
# Uso:
#   chmod +x scripts/analise-logs.sh    # dar permissao de execucao (so 1x)
#   sudo ./scripts/analise-logs.sh      # rodar a analise
#
# Observacao: requer sudo porque o journalctl precisa de privilegio para
# ler os logs de autenticacao do sistema.
#

echo "=== 0. Ambiente ==="
echo "Host: $(hostname)"
echo "IP:   $(hostname -I)"
echo "Data: $(date)"
echo ""

echo "=== Pre-requisito: servico SSH ==="
if systemctl is-active --quiet ssh; then
  echo "SSH ativo. Prosseguindo com a analise."
else
  echo "SSH NAO esta ativo. Ligue com: sudo systemctl enable --now ssh"
  exit 1
fi
echo ""

echo "=== 1. Total de tentativas falhadas ==="
journalctl -u ssh --no-pager | grep "Failed password" | wc -l

echo ""
echo "=== 2. IPs de origem (contagem) ==="
journalctl -u ssh --no-pager | grep "Failed password" | grep -oE 'from [0-9.]+' | sort | uniq -c

echo ""
echo "=== 3. Usuarios alvo (contagem) ==="
journalctl -u ssh --no-pager | grep "Failed password" | grep -oE 'user [a-z]+' | sort | uniq -c

echo ""
echo "=== 4. Houve login bem-sucedido? ==="
journalctl -u ssh --no-pager | grep "Accepted password" || echo "Nenhum acesso bem-sucedido."

echo ""
echo "=== 5. Amostra das ultimas linhas de falha ==="
journalctl -u ssh --no-pager | grep "Failed password" | tail -n 10