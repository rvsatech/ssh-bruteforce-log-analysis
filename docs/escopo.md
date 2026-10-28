# Escopo

## Objetivo
Determinar se o serviço SSH sofreu um ataque de força bruta e, em caso
positivo, responder: qual a origem, qual usuário foi alvo, qual o volume e a
cadência das tentativas, e se alguma obteve sucesso (comprometimento). O
resultado é um relatório de incidente com conclusão e recomendações.

## Ambiente
Laboratório próprio e isolado; o ataque foi gerado de forma controlada contra
a própria máquina, exclusivamente para fins de estudo.

| Item           | Descrição                                                        |
|----------------|------------------------------------------------------------------|
| Alvo           | Kali Linux (VM VirtualBox) — OpenSSH na porta 22 (127.0.0.1)      |
| Atacante       | Mesma máquina, usando Hydra contra 127.0.0.1 (cenário simulado)  |
| Fonte dos logs | journal do systemd (`journalctl -u ssh`) e `/var/log/auth.log`   |

## Critério de "pronto"
- [ ] Ataque gerado e registrado no log
- [ ] Volume de tentativas quantificado
- [ ] IP de origem identificado
- [ ] Usuário-alvo identificado
- [ ] Verificado se houve login bem-sucedido
- [ ] Evidências (prints + logs) anexadas
- [ ] Relatório com conclusão e recomendações