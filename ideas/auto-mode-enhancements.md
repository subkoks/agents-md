# Auto Mode Enhancements

Ideas for supercharging the overnight agent capability.

## Current State

Auto Mode triggers on "auto mode" or "I'm going to sleep" and grants full autonomy until user sends new message or "hard stop".

## Enhancement Ideas

### 1. Progress Logging

**Problem:** User wakes up and doesn't know what happened overnight.

**Solution:** Write progress to `~/.windsurf/data/logs/YYYY-MM-DD-auto.md` every 5 minutes.

```markdown
## [02:15] Task: Refactor API endpoints
- Completed: /src/api/users.ts
- In progress: /src/api/auth.ts
- Files modified: 3
- Tests run: 12 passed, 0 failed
- Next: /src/api/posts.ts
```

### 2. Checkpoint System

**Problem:** Risky operation fails, work lost.

**Solution:** Before destructive operations, save checkpoint:

```bash
~/.windsurf/data/checkpoints/
├── 2026-03-17_02-15_pre-refactor/
│   ├── git-status.txt
│   ├── modified-files.tar.gz
│   └── plan.md
```

Auto-rollback on failure, or user can restore manually.

### 3. Notification Hooks

**Problem:** User doesn't know when Auto Mode finishes.

**Solution:** Webhook config in `~/.windsurf/config.yaml`:

```yaml
auto_mode:
  on_complete: https://hooks.slack.com/services/XXX
  on_error: https://hooks.slack.com/services/YYY
  on_hard_stop: true
```

Payload includes summary, files changed, time elapsed.

### 4. Time Limits

**Problem:** Auto Mode runs indefinitely on stuck task.

**Solution:** Configurable timeout:

```yaml
auto_mode:
  max_duration: 8h  # 8 hours max
  on_timeout: pause  # or stop, or notify
```

### 5. Task Queue

**Problem:** User has multiple tasks for overnight.

**Solution:** Queue file `~/.windsurf/data/queue.yaml`:

```yaml
queue:
  - task: "Refactor API endpoints"
    priority: high
  - task: "Add tests for auth module"
    priority: medium
  - task: "Update dependencies"
    priority: low
```

Auto Mode processes in order, logs progress per task.

## Implementation Priority

1. Progress logging (easiest, most value)
2. Time limits (safety)
3. Task queue (planning ahead)
4. Checkpoints (recovery)
5. Notifications (nice to have)
