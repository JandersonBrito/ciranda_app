# ─────────────────────────────────────────────────────────────────────────────
# Ciranda App — Makefile
# Atalhos para comandos Docker comuns
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: help build dev dev-logs dev-stop up down shell pub-get codegen test apk-debug apk-release web clean logs

## Exibe esta ajuda
help:
	@echo ""
	@echo "  Ciranda App — Comandos Docker"
	@echo "  ─────────────────────────────────────────────────────────────"
	@echo "  make build         Constrói a imagem Docker"
	@echo ""
	@echo "  ✨ DESENVOLVIMENTO WEB (hot reload no browser)"
	@echo "  make dev           Inicia flutter web em http://localhost:8080"
	@echo "  make dev-logs      Mostra os logs do servidor web"
	@echo "  make dev-stop      Para o servidor web"
	@echo ""
	@echo "  🔧 UTILITÁRIOS"
	@echo "  make pub-get       Executa flutter pub get"
	@echo "  make codegen       Gera código Riverpod (build_runner)"
	@echo "  make test          Executa os testes"
	@echo "  make shell         Abre shell interativo no container"
	@echo ""
	@echo "  📦 BUILD"
	@echo "  make apk-debug     Gera APK debug"
	@echo "  make apk-release   Gera APK release"
	@echo "  make web           Gera build web (produção)"
	@echo ""
	@echo "  make clean         Remove build/ e volumes Docker"
	@echo "  make down          Para e remove todos os containers"
	@echo ""

## Constrói a imagem
build:
	docker compose build

# ── DEV WEB ──────────────────────────────────────────────────────────────────

## Inicia o servidor de desenvolvimento web com hot reload
## Acesse: http://localhost:8080
dev:
	@echo "🎪 Iniciando Ciranda App em modo web..."
	@echo "👉 Acesse: http://localhost:8080"
	@echo "   (Ctrl+C nos logs ou 'make dev-stop' para parar)"
	docker compose up -d web-dev
	@sleep 2
	docker compose logs -f web-dev

## Mostra os logs do servidor web
dev-logs:
	docker compose logs -f web-dev

## Para o servidor web
dev-stop:
	docker compose stop web-dev
	docker compose rm -f web-dev

# ── CONTAINER PRINCIPAL ───────────────────────────────────────────────────────

## Sobe o container de dev genérico em background
up:
	docker compose up -d flutter

## Para todos os containers
down:
	docker compose down

## Shell interativo no container de dev
shell:
	docker compose run --rm flutter bash

## flutter pub get
pub-get:
	docker compose run --rm flutter flutter pub get

## Geração de código Riverpod
codegen:
	docker compose run --rm --profile codegen codegen

## Testes
test:
	docker compose run --rm --profile test test

# ── BUILD ─────────────────────────────────────────────────────────────────────

## APK debug
apk-debug:
	docker compose run --rm --profile build build-apk-debug

## APK release
apk-release:
	docker compose run --rm --profile release build-apk-release

## Build web (produção)
web:
	docker compose run --rm --profile web build-web

# ── MANUTENÇÃO ────────────────────────────────────────────────────────────────

## Limpa artefatos de build e volumes
clean:
	docker compose down -v
	rm -rf build/
	@echo "✅ Limpeza concluída"

## Logs do container principal
logs:
	docker compose logs -f flutter
