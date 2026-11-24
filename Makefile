# UninoVet - atalhos para rodar o projeto com Docker (local ou Codespace).
#
#   make up    -> sobe tudo: banco + clinica (Java) + app (Flutter) + proxy
#                   :3000 porta unica (app do cliente em /, clinica em /clinica/)
#                   :5000 app do cliente (Flutter) direto
#                   :8080 aplicacao da clinica (Java: painel, agenda, /admin e API) direto
#   make logs  -> acompanha os logs
#   make ps    -> estado dos servicos
#   make down  -> desliga tudo
#
# Tudo roda atras do proxy na porta unica 3000 (mesma origem). O app e o painel
# usam caminhos relativos, entao funcionam igual no local e no Codespace.
#
# O compose cuida da ordem e da espera: banco -> clinica (Java, aguarda ficar
# saudavel pelo healthcheck) -> app Flutter + proxy.

COMPOSE := docker compose --profile proxy

.PHONY: help check-docker up uninovet logs ps rebuild down

help:
	@echo "make up      : sobe o UninoVet (portas 3000, 5000 e 8080)"
	@echo "make logs    : logs de todos os servicos"
	@echo "make ps      : estado dos servicos"
	@echo "make rebuild : reconstroi as imagens e sobe de novo"
	@echo "make down    : desliga tudo"

check-docker:
	@command -v docker >/dev/null 2>&1 || { echo "Docker nao encontrado."; exit 1; }
	@docker compose version >/dev/null 2>&1 || { echo "Docker Compose v2 nao encontrado."; exit 1; }
	@docker info >/dev/null 2>&1 || { echo "Sem acesso ao daemon do Docker (ele esta rodando?)."; exit 1; }

up: check-docker
	$(COMPOSE) up -d
	@echo "UninoVet subindo. Abra a porta 3000 no navegador."
	@echo "No Codespace, libere a porta 3000 na aba PORTS."
	@echo "App do cliente em / e clinica em /clinica/."
	@echo "O app Flutter leva um tempo para compilar na primeira vez (make logs)."
	@echo "Contas de exemplo: veja o README.md"

# Mesmo alvo com o nome antigo (citado em docs/).
uninovet: up

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

rebuild: check-docker
	$(COMPOSE) up -d --build

down: check-docker
	$(COMPOSE) down
