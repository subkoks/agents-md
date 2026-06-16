SHELL := /bin/bash

.PHONY: governance-run governance-check check drift-check drift-check-strict build-artifacts artifacts-list structured-rules query sync sync-cursor install-cursor-local health skills-drift lint test security-scan hooks dag ci

governance-run:
	./scripts/run-governance.sh

governance-check:
	./scripts/validate-comprehensive.sh --strict

check:
	./scripts/validate-comprehensive.sh --strict
	./scripts/check-local-drift.sh --strict
	./scripts/build-structured-rules.sh --check

drift-check:
	./scripts/check-local-drift.sh

drift-check-strict:
	./scripts/check-local-drift.sh --strict

build-artifacts:
	./scripts/build-rule-artifacts.sh

artifacts-list:
	./scripts/build-rule-artifacts.sh --list

structured-rules:
	./scripts/build-structured-rules.sh --verbose

query:
	./scripts/query-rules.sh $(ARGS)

sync:
	./scripts/build-rule-artifacts.sh

sync-cursor:
	@echo "[WARN] sync-cursor is deprecated and does not deploy local rules."
	@echo "[INFO] Use 'make install-cursor-local' for an explicit manual Cursor install."
	@exit 1

install-cursor-local:
	./scripts/build-rule-artifacts.sh cursor cursor-lean
	@mkdir -p $(HOME)/.cursor/rules
	@cp dist/rules/cursor.md $(HOME)/.cursor/rules/gotcha-full.mdc
	@cp dist/rules/cursor.lean.md $(HOME)/.cursor/rules/gotcha.mdc
	@echo "[ OK ] Manually installed: ~/.cursor/rules/gotcha.mdc + gotcha-full.mdc"

health:
	./scripts/health-check.sh

skills-drift:
	./scripts/check-skill-registry-drift.sh

lint:
	shellcheck -e SC1091 -e SC2155 scripts/*.sh install.sh
	markdownlint-cli2 "**/*.md" "#dist" "#node_modules" "#CHANGELOG.md"
	actionlint

test:
	@command -v bats >/dev/null 2>&1 || { echo "[ERR ] bats not found. Install bats-core (brew install bats-core / apt-get install bats)."; exit 1; }
	bats tests/

ci: lint check skills-drift test
	@echo "[ OK ] Local CI mirror passed (lint + check + skills-drift + test)"
security-scan:
	./scripts/security-scan.sh --fail-on high

hooks:
	./scripts/hook-profile.sh --profile standard --list-all

dag:
	./scripts/dag-schedule.sh --manifest orchestration/tasks.example.tsv

ci: lint check skills-drift test security-scan
	@echo "[ OK ] Local CI mirror passed (lint + check + skills-drift + test + security-scan)"
