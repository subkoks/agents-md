SHELL := /bin/bash

.PHONY: governance-run governance-check check drift-check drift-check-strict build-artifacts artifacts-list sync sync-cursor health skills-drift

governance-run:
	./scripts/run-governance.sh

governance-check:
	./scripts/validate-comprehensive.sh --strict

check:
	./scripts/validate-comprehensive.sh --strict
	./scripts/check-local-drift.sh --strict

drift-check:
	./scripts/check-local-drift.sh

drift-check-strict:
	./scripts/check-local-drift.sh --strict

build-artifacts:
	./scripts/build-rule-artifacts.sh

artifacts-list:
	./scripts/build-rule-artifacts.sh --list

sync:
	./scripts/build-rule-artifacts.sh

sync-cursor:
	./scripts/build-rule-artifacts.sh cursor cursor-lean
	@mkdir -p $(HOME)/.cursor/rules
	@cp dist/rules/cursor.md $(HOME)/.cursor/rules/gotcha-full.mdc
	@cp dist/rules/cursor.lean.md $(HOME)/.cursor/rules/gotcha.mdc
	@echo "[ OK ] Deployed: ~/.cursor/rules/gotcha.mdc + gotcha-full.mdc"

health:
	./scripts/health-check.sh

skills-drift:
	./scripts/check-skill-registry-drift.sh
