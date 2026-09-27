# Security

This document describes QueueSync's security posture. The app is publicly
accessible during hackathon judging — it's treated as a real public surface,
not a localhost demo.

## In Scope

### Authentication & Authorization

**Staff endpoints** (`callNext`, `markServed`, `markNoShow`, `pauseCounter`,
`resumeCounter`, `watchStaffQueue`) enforce **two layers**:

1. **Authentication**: The caller must be authenticated via Serverpod's auth
   module. Unauthenticated callers receive `UnauthorizedException`.
2. **Counter-level authorization**: The authenticated user must be staff for
   the *specific* `counterId` being acted on. Staff for Counter A are rejected
   when acting on Counter B. This is tested in
   `queuesync_server/test/staff_cross_counter_test.dart`.

**Visitor endpoints** (`joinQueue`, `watchQueue`, `leaveQueue`) are
intentionally unauthenticated — adding a login wall at a waiting-room QR code
is a UX failure. However:

- `joinQueue` validates that the counter exists and is not paused before accepting.
- `leaveQueue` requires an `ownerToken` issued at `joinQueue` time. Without
  this token, visitor A cannot cancel visitor B's spot by guessing sequential
  entry IDs. **This is the single most likely real vulnerability in this app.**

### Input Validation

All server-side validation lives in `queuesync_server/lib/src/endpoints/validators.dart`:

| Field | Rule |
|-------|------|
| `visitorName` | Trimmed, 1–80 chars, rejected if empty after trim |
| `phone` | Optional; permissive real pattern (`/^\+?[\d\s\-().]{7,20}$/`); typed error if invalid |
| `counterId` / `entryId` | Must be positive integers; existence checked in DB before use |

Names are trimmed before persisting. The staff dashboard renders
`visitorName` as plain text only — no `innerHTML` or `dangerouslySetInnerHTML`
equivalent — so stored XSS is not a surface.

### Rate Limiting

`joinQueue` is rate-limited at **10 joins per IP per minute** (in-memory).
This prevents queue-flooding from a single source during the demo.

**Known limitation**: The limiter is in-memory and does not survive server
restarts or scale across multiple instances. For a single-instance hackathon
deployment, this is sufficient. For production scale, use a Redis-backed
limiter. This is documented in the README's Known Limitations section.

### Transport Security

- All deployed traffic uses HTTPS (TLS termination via Serverpod Cloud /
  Fly.io proxy). Plain HTTP is only accepted in local development (`localhost`).
- WebSocket connections (Serverpod streams) use `wss://` in production.

### Secrets Management

- `config/passwords.yaml` is in `.gitignore` from the first commit — never
  committed to the repo.
- Local Docker credentials (`docker-compose.yaml`) are read from a `.env`
  file via `${VAR:?error if unset}` interpolation. `.env` is gitignored;
  `.env.example` (committed) documents the required variable names with
  placeholder values only. Run `cp .env.example .env` and fill in any local
  value before running `docker compose up`.
- The CI workflow's Postgres service container password
  (`QUEUESYNC_DB_PASSWORD` in `ci.yml`) is a fixed, disposable value scoped
  to that one ephemeral CI run — the container is created and destroyed
  within the job, so this is standard practice (per GitHub's own service-
  container docs) and distinct from a real committed secret.
- The deploy workflow reads the real credential (`SERVERPOD_TOKEN`) from
  **GitHub Actions secrets** — never from a committed file.
- Environment-specific config lives in `config/*.yaml` + `passwords.yaml`,
  not hardcoded in endpoint files.

**Note on repo history**: earlier commits contained real-looking Postgres/
Redis passwords directly in `docker-compose.yaml` and in a (now-removed)
`tests.yml` workflow. These were dev/test-only credentials with no access
to anything beyond a local throwaway container, but they were rotated and
removed from the current tree as part of this fix. If this repo is ever
made public, run the `git log -p | grep` check below and consider whether
history should be scrubbed (e.g. via `git filter-repo`) before sharing —
not strictly required since the values are inert, but it's the more
defensible call for a public submission.

**Before making the repo public**, run:
```bash
git log -p | grep -iE "(password|secret|api_key|token)\s*[:=]\s*['\"][^'\"]{8,}['\"]"
```
and verify no real secrets appear in history.

### CORS

Serverpod's CORS policy should be configured to allow only:
- The deployed Flutter web origin (e.g., `https://app.queuesync.fly.dev`)
- `localhost` for local development

**Do not** leave a wildcard `*` origin in the shipped config.
Configure in `config/production.yaml` before going live.

### Dependency Hygiene

- Dependabot is configured (`.github/dependabot.yml`) for weekly updates on
  server, client, and GitHub Actions packages.
- The CI security-scan job runs `dart pub outdated` and `flutter pub outdated`
  on every push to surface vulnerable packages.
- Dependencies are kept minimal — no third-party packages for things Serverpod
  or Flutter's SDK already provides.

## Out of Scope (for this submission)

- Multi-tenant organization-level access control
- SMS or push notification infrastructure
- Formal penetration testing or CVE scanning beyond `pub outdated`

## Reporting a Vulnerability

This is a hackathon submission. If you find a real security issue, please
open a GitHub Issue marked `[SECURITY]` or email the team directly.
