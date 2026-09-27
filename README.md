# QueueSync

[![CI](https://github.com/your-org/queuesync/actions/workflows/ci.yml/badge.svg)](https://github.com/your-org/queuesync/actions/workflows/ci.yml)
[![Built with Serverpod](https://img.shields.io/badge/Built%20with-Serverpod%203.4-teal)](https://serverpod.dev)

**QueueSync is a real-time virtual queue manager for walk-in service counters — clinics, government offices, or anywhere people stand in a physical line.**

---

## The problem

Walk-in queues at clinics and government offices are broken in the same three ways:
everyone crowds the entrance to hold a place, ticket machines give you a number with
no information about how long it'll actually take, and the moment you step away to
grab water you risk missing your turn. There's no visibility, no agency, and no way
to wait comfortably. QueueSync replaces the physical line with a link.

---

## How it works (the demo flow)

1. **Staff opens** the dashboard at `/staff`, logs in, and sees the live queue.
2. **Visitor scans** a QR code (or follows a URL like `/q/1`) — no app install, no account.
3. **Visitor types their name** and joins. Their **position number appears instantly** and updates live as the queue moves.
4. **Staff taps "Call Next"** — the visitor's screen transitions to the amber "It's your turn!" state with a subtle pulse animation.
5. **Staff taps "Served"** — the visitor's screen shows a teal confirmation. If they don't show up within 5 minutes, the entry auto-expires.
6. Two visitors can join simultaneously — they always get distinct positions (no collisions).

> _(Screenshots will be added here from the first deployed demo run — see Submission Day checklist)_

---

## Why Serverpod (not just "what," but "why these specific features")

These are the Serverpod features that are **structurally load-bearing** in this project — not marketing points:

| Feature | How QueueSync uses it | Where in the code |
|---------|----------------------|-------------------|
| **Real-time Dart streams** | Visitor position updates and staff queue list are live streams — no polling Timer anywhere | [`queue_endpoint.dart`](queuesync_server/lib/src/endpoints/queue_endpoint.dart) — `watchQueue()` / `watchStaffQueue()` |
| **Built-in auth (email/password IDP)** | Staff dashboard login, including the built-in `SignInWithEmailButton` widget on the client | [`server.dart`](queuesync_server/lib/server.dart), [`staff_login_screen.dart`](queuesync_flutter/lib/screens/staff/staff_login_screen.dart) |
| **ORM + transactions** | `joinQueue` acquires a row-level lock on the Counter row inside a transaction to serialize concurrent joins — see the comment block explaining why | [`queue_endpoint.dart`](queuesync_server/lib/src/endpoints/queue_endpoint.dart) — `joinQueue()` |
| **Future calls (task scheduling)** | Called entries auto-expire after 5 minutes via a Serverpod future call, which persists through server restarts | [`entry_expiry_future_call.dart`](queuesync_server/lib/src/future_calls/entry_expiry_future_call.dart) |
| **Serializable exceptions** | Typed exceptions (`CounterPausedException`, `InvalidStateTransitionException`, etc.) that the Flutter client can branch on | [`queuesync_server/lib/src/models/exceptions/`](queuesync_server/lib/src/models/exceptions/) |
| **Serverpod session logging** | Every rejected/failed action is logged via `session.log()` with enough context to debug from the Insights dashboard | Throughout all endpoint files |

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         QueueSync                               │
│                                                                 │
│  ┌─────────────────┐    WebSocket    ┌──────────────────────┐  │
│  │ Flutter Web      │◄──── stream ───►│   Serverpod Server   │  │
│  │ (Visitor /q/:id) │                │                      │  │
│  └─────────────────┘                 │  queuesync_server/   │  │
│                                      │  - endpoints/        │  │
│  ┌─────────────────┐    WebSocket    │  - future_calls/     │  │
│  │ Flutter Web      │◄──── stream ───►│  - models/          │  │
│  │ (Staff /staff)   │                │                      │  │
│  └─────────────────┘                 └──────────┬───────────┘  │
│                                                 │              │
│                                          ┌──────▼──────┐      │
│                                          │ PostgreSQL   │      │
│                                          │ (port 5432)  │      │
│                                          └─────────────┘      │
└─────────────────────────────────────────────────────────────────┘
```

**Three generated packages:**
- `queuesync_server/` — Serverpod server: endpoints, models, future calls, migrations
- `queuesync_client/` — Auto-generated Dart client: type-safe API, exception types, stream bindings
- `queuesync_flutter/` — Flutter web app: visitor view + staff dashboard, Riverpod state management

---

## Running it locally

**Prerequisites:**
- Dart 3.10.3 / Flutter 3.38.4
- PostgreSQL 16 running on port 5432
- Serverpod CLI: `dart pub global activate serverpod_cli 3.4.13`

```bash
# 1. Clone and navigate to the workspace root
git clone https://github.com/your-org/queuesync.git
cd queuesync

# 2. Install all workspace dependencies
dart pub get

# 3. Start PostgreSQL and create the database + user
psql -U postgres -c "CREATE USER queuesync_user WITH PASSWORD 'your-password';"
psql -U postgres -c "CREATE DATABASE queuesync OWNER queuesync_user;"
psql -U postgres -c "CREATE DATABASE queuesync_test OWNER queuesync_user;"

# 4. Generate Serverpod code (models → Dart classes + client)
cd queuesync_server
dart run serverpod_cli generate

# 5. Apply database migrations
dart run bin/main.dart --apply-migrations

# 6. Seed demo counters (run once)
dart run bin/seed.dart

# 7. Start the server
dart run bin/main.dart
# → API: http://localhost:8080
# → Insights: http://localhost:8081
# → Web:  http://localhost:8082

# 8. In a new terminal — run the Flutter app
cd ../queuesync_flutter
flutter pub get
flutter run -d chrome
# → Open http://localhost:xxxx/q/1 (visitor view)
# → Open http://localhost:xxxx/staff (staff dashboard)
```

---

## Tech stack

- **Serverpod**: `3.4.13` (exact, pinned — no `^` range)
- **Flutter**: `3.38.4` (stable channel)
- **Dart SDK**: `3.10.3`
- **PostgreSQL**: `16`
- **State management**: Riverpod 2.6.x
- **Routing**: go_router 14.x
- **Typography**: Inter via google_fonts
- **Deploy target**: Serverpod Cloud (or Fly.io via podfly as fallback)
- **CI**: GitHub Actions — [see badge above](#queuesync)

---

## What we deliberately left out

These are **scope decisions**, not missed features:

- **No native mobile app** — Flutter web covers the visitor use case (QR code on a phone browser); a native app adds a distribution problem without adding capability for a demo.
- **No SMS/push notifications** — the "you're next" alert is an in-app stream event. SMS adds a third-party dependency and a billing relationship; the stream is faster anyway.
- **Single counter per staff login** — one staff user manages one counter. Multi-tenant organization hierarchies are a product decision for post-hackathon, not a missing feature.
- **No SMS verification on join** — visitors join with a name only. The ownerToken handles the only real security need (preventing someone else from cancelling your spot).

---

## Known limitations

- **Estimated wait time** is currently "X people ahead of you," not a time estimate. A real estimate requires tracking historical average service time per counter, which needs more data than a fresh demo has.
- **Rate limiting is in-memory** — does not survive server restarts or scale across multiple server instances. A production deployment would use Redis-backed rate limiting. Documented in [`SECURITY.md`](SECURITY.md).
- **Single-instance only** — Serverpod's in-memory message bus (used for stream broadcasts) is not shared across replicas. Horizontal scaling would require switching to a Redis pub/sub backend. Acceptable for a hackathon submission on one instance.

---

## Development

### Branch protection

`main` should require the CI workflow to pass before merge once the repo has
more than one contributor pushing directly. For a solo/small hackathon team
this is advisory, but it should be enabled as soon as two people have push access.

### Running tests

```bash
# Server tests (requires PostgreSQL running in test config)
cd queuesync_server && dart test

# Flutter widget tests (no backend needed)
cd queuesync_flutter && flutter test
```

---

## Team

| Name | Role |
|------|------|
| _(your name)_ | Full-stack — backend, Flutter frontend, CI/CD |

---

## License

MIT License — see [LICENSE](LICENSE).
