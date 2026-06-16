# LLM-native rules

The canonical rules live as prose in [`src/gotcha.md`](../src/gotcha.md) — the
right format for a human or an agent to *read*. But an agent that wants to
*query* the rules ("what are the hard-stops?", "which rules tag `git`?") should
not have to parse Markdown at runtime.

`scripts/build-structured-rules.sh` parses the prose into a deterministic,
addressable representation and emits two generated artifacts under
`dist/rules/` (gitignored, regenerated like the other rule artifacts):

| Artifact | Format | Use |
| --- | --- | --- |
| `gotcha.rules.json` | JSON (`gotcha-rules/v1`) | LLM-native interchange; load and filter programmatically |
| `gotcha.rules.tsv` | TSV | dependency-free shell queries (`query-rules.sh`) |

Both derive from a **single parse**, so they cannot disagree. The JSON shape is
pinned by [`schema/gotcha-rules.schema.json`](../schema/gotcha-rules.schema.json).

## Record shape

Each top-level bullet in `src/gotcha.md` becomes one rule. Nested bullets fold
into the parent's `text` (joined with ` — `). Bold section preambles
(`**…:**` lines) are not rules.

```json
{
  "id": "hard-stop-001",
  "section": "Modes",
  "subsection": "Hard Stop",
  "type": "hard-stop",
  "severity": "critical",
  "tags": ["modes", "hard-stop"],
  "text": "Destructive file operations with meaningful data loss risk."
}
```

- **`id`** — `<nearest-heading-slug>-<ordinal>`, stable as long as bullet order
  is stable. Addressable: cite `hard-stop-001` in a review or a PR.
- **`type`** / **`severity`** — derived from the nearest heading via an explicit
  mapping in the build script (e.g. `Hard Stop` → `hard-stop`/`critical`,
  `Security`/`Git` → `policy`/`high`). Everything unmapped defaults to
  `guideline`/`info`. The mapping is deterministic and auditable, not inferred
  per-run.
- **`tags`** — section and subsection slugs, for filtering.

## Querying

`scripts/query-rules.sh` filters the TSV with awk — no jq, no runtime deps.
Filters AND together; `--severity`/`--type` match exactly, the rest are
case-insensitive substrings.

```bash
# all hard-stops
scripts/query-rules.sh --severity critical

# policy rules mentioning secrets, ids only
scripts/query-rules.sh --type policy --grep secret --format ids

# count rules tagged git
scripts/query-rules.sh --tag git --format count
```

Formats: `table` (default), `tsv`, `ids`, `count`. The script builds the
artifact on demand if it is missing.

Programmatic consumers should read `gotcha.rules.json` directly, e.g.:

```bash
jq '.rules[] | select(.type=="hard-stop") | .text' dist/rules/gotcha.rules.json
```

## Build & drift

The structured artifacts are generated, never hand-edited — edit
`src/gotcha.md`, then rebuild.

```bash
make structured-rules          # build both artifacts
scripts/build-structured-rules.sh --check   # assert on-disk == regenerated
```

The generator is wired into the governance pipeline (`make governance-run`) and
gated in CI: the `build` job builds the artifacts and runs `--check`, and
`make check` includes the structured drift check. Because generation is
deterministic, `--check` catches both staleness (source changed, artifact not
rebuilt) and any non-determinism in the parser.

## Scope

This is the **LLM-native rules** experiment from [ROADMAP.md](../ROADMAP.md):
encode rules as structured records an agent can query, without changing the
prose source of truth. It deliberately does **not** rewrite the rules as a
formal trigger/action DSL — that path is in *Won't Do* ("natural-language
rules … interpreted differently each run"). The prose stays canonical; the
structured artifact is a faithful, regenerable projection of it.
