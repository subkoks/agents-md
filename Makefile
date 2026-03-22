SHELL := /bin/bash

.PHONY: governance-run governance-check drift-check build-artifacts artifacts-list sync wrappers-list health skills-drift

governance-run:
	./scripts/run-governance.sh

governance-check:
	./scripts/validate-comprehensive.sh --strict

drift-check:
	./scripts/check-local-drift.sh

build-artifacts:
	./scripts/build-rule-artifacts.sh

artifacts-list:
	./scripts/build-rule-artifacts.sh --list

sync:
	./scripts/build-rule-artifacts.sh

wrappers-list:
	@echo "[WARN] wrappers-list is deprecated; use artifacts-list"
	./scripts/build-rule-artifacts.sh --list

health:
	./scripts/health-check.sh

skills-drift:
	./scripts/check-skill-registry-drift.sh
