# UninoVet - atalhos para rodar com Docker (Windows, macOS, Linux e Codespace).
# Cada alvo e so um "docker compose": o container resolve o resto.
#
#   make up    -> sobe tudo: banco + clinica (Java) + app (Flutter) + proxy
#                   :3000 porta unica (app do cliente em /, clinica em /clinica/)
#                   :5000 app do cliente (Flutter) direto
#                   :8080 aplicacao da clinica (Java: painel, agenda, /admin e API) direto
#   make logs  -> acompanha os logs
#   make down  -> desliga tudo
#
# Tudo roda atras do proxy na porta unica 3000 (mesma origem). O app e o painel
# usam caminhos relativos, entao funcionam igual no local e no Codespace.
#
# O compose cuida da ordem e da espera: banco -> clinica (Java, aguarda ficar
# saudavel pelo healthcheck) -> app Flutter + proxy. Sem script de espera aqui.

.PHONY: help up uninovet logs ps rebuild down

help:
	@echo make up      : sobe o UninoVet nas portas 3000, 5000 e 8080
	@echo make logs    : logs de todos os servicos
	@echo make ps      : estado dos servicos
	@echo make rebuild : reconstroi as imagens e sobe de novo
	@echo make down    : desliga tudo

up:
	docker compose --profile proxy up -d
	@echo UninoVet subindo. Abra a porta 3000 no navegador.
	@echo No Codespace, libere a porta 3000 na aba PORTS.
	@echo App do cliente em / e clinica em /clinica/.
	@echo O app Flutter leva um tempo para compilar na primeira vez.
	@echo Contas de exemplo: veja o README.md

# Mesmo alvo com o nome antigo, citado em docs/.
uninovet: up

logs:
	docker compose --profile proxy logs -f

ps:
	docker compose --profile proxy ps

rebuild:
	docker compose --profile proxy up -d --build

down:
	docker compose --profile proxy down
