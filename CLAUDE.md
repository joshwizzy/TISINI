# TISINI

Mobile wallet + payments app for African SMEs and gig workers (Flutter).

- **Dart SDK:** ^3.10.1
- **Flutter:** 3.24.x (stable)

## Quick Start

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Commands Reference

| Task | Command |
|---|---|
| Install deps | `flutter pub get` |
| Codegen | `dart run build_runner build --delete-conflicting-outputs` |
| Codegen (watch) | `dart run build_runner watch --delete-conflicting-outputs` |
| Run | `flutter run` |
| Test | `flutter test` |
| Test (coverage) | `flutter test --coverage` |
| Format | `dart format .` |
| Format check (CI) | `dart format --set-exit-if-changed .` |
| Analyze | `flutter analyze` |
| Analyze (CI) | `flutter analyze --fatal-infos` |
| Build APK | `flutter build apk --debug` |

## Project Structure

```
lib/
├── core/               # Shared infrastructure
├── features/           # Feature modules (clean architecture)
├── shared/widgets/     # Reusable widgets
├── app.dart            # TisiniApp (MaterialApp.router)
├── bootstrap.dart      # Async init (SharedPrefs, DB, overrides)
└── main.dart           # Entry point → bootstrap → ProviderScope
test/                   # Mirrors lib/ structure
docs/                   # TECHNICAL_SPEC.md
```

### `lib/core/`

```
core/
├── constants/
│   ├── api_constants.dart       # Base URL, timeout durations
│   ├── app_colors.dart          # Brand + semantic + zone colors
│   ├── app_radii.dart           # Border radius values + helpers
│   ├── app_spacing.dart         # 8-point scale (xs–xxxl) + aliases
│   └── app_typography.dart      # 12+ TextStyles (Inter)
├── errors/
│   ├── error_handler.dart       # ErrorHandler.withRetry (backoff)
│   ├── exceptions.dart          # Sealed AppException hierarchy
│   └── failures.dart            # Sealed Failure hierarchy
├── network/
│   ├── auth_interceptor.dart    # Bearer token + 401 refresh queue
│   ├── connectivity_interceptor.dart  # Pre-flight connectivity check
│   ├── dio_client.dart          # Dio setup (base URL, timeouts, interceptors)
│   └── error_interceptor.dart   # DioException → AppException mapping
├── providers/
│   ├── auth_state_provider.dart # AuthStateNotifier (StateNotifierProvider)
│   ├── connectivity_provider.dart # StreamProvider<List<ConnectivityResult>>
│   ├── core_providers.dart      # secureStorage, preferences, dio, database
│   └── user_provider.dart       # Stub (returns null)
├── router/
│   ├── app_router.dart          # GoRouter + StatefulShellRoute (5 tabs)
│   ├── guards/
│   │   ├── auth_guard.dart
│   │   ├── kyc_guard.dart
│   │   └── step_up_guard.dart
│   └── route_names.dart         # ~55 static route name constants
├── storage/
│   ├── database/
│   │   └── app_database.dart    # Drift DB (4 tables, schema v1)
│   ├── preferences.dart         # SharedPreferences wrapper
│   └── secure_storage.dart      # FlutterSecureStorage wrapper
├── theme/
│   └── app_theme.dart           # AppTheme.light (Material 3)
└── utils/                       # Reserved (empty)
```

### `lib/features/`

Each feature follows clean architecture:

```
feature_name/
├── data/
│   ├── datasources/     # Remote + local data sources
│   ├── models/          # Serialization models
│   └── repositories/    # Repository implementations
├── domain/
│   ├── entities/        # Business objects
│   └── repositories/    # Repository interfaces
├── presentation/
│   ├── screens/         # UI screens
│   └── widgets/         # Feature-specific widgets
└── providers/           # Riverpod providers
```

**11 features:**

| Feature | Description |
|---|---|
| `splash` | Splash/loader screen |
| `onboarding` | User onboarding flow |
| `auth` | Login, OTP, PIN creation, permissions |
| `home` | Dashboard, attention items, insights |
| `pay` | Send, request, scan, business payments, top-ups |
| `pensions` | Pension contributions, history |
| `pia` | Personal Insights & Actions (feed, cards, pinned) |
| `activity` | Transaction history, filters, exports |
| `more` | Profile, settings, accounts, support, legal |
| `bulk_import` | Bulk transaction import from CSV |
| `kyc` | Know Your Customer flow (ID, selfie, verification) |

## Architecture

### Clean Architecture

```
presentation → domain ← data
```

- **presentation**: Screens, widgets, UI logic
- **domain**: Entities, repository interfaces (no framework deps)
- **data**: API calls, local DB, serialization, repository implementations

### Riverpod

- `ProviderScope` wraps the app at root (`main.dart`)
- `bootstrap()` creates `SharedPreferences` and `AppDatabase`, passes overrides
- `StateNotifierProvider` for auth state (`AuthStateNotifier`)
- `StreamProvider` for connectivity changes
- Standard `Provider` for singletons (dio, database, secureStorage, preferences)

**Core providers:**

| Provider | Type |
|---|---|
| `secureStorageProvider` | `Provider<SecureStorage>` |
| `preferencesProvider` | `Provider<Preferences>` (overridden) |
| `databaseProvider` | `Provider<AppDatabase>` (overridden) |
| `dioProvider` | `Provider<Dio>` |
| `authStateProvider` | `StateNotifierProvider<AuthStateNotifier, AuthState>` |
| `connectivityProvider` | `StreamProvider<List<ConnectivityResult>>` |
| `userProvider` | `Provider<Object?>` (stub) |
| `routerProvider` | `Provider<GoRouter>` |

### GoRouter

- `StatefulShellRoute.indexedStack` with 5 tabs:

| Index | Tab | Path | Screen | Icon |
|---|---|---|---|---|
| 0 | Home | `/home` | HomeScreen | `PhosphorIconsBold.house` |
| 1 | Pay | `/pay` | PayHubScreen | `PhosphorIconsBold.arrowsLeftRight` |
| 2 | Pia | `/pia` | PiaFeedScreen | `PhosphorIconsBold.sparkle` |
| 3 | Activity | `/activity` | ActivityListScreen | `PhosphorIconsBold.clockCounterClockwise` |
| 4 | More | `/more` | MoreHubScreen | `PhosphorIconsBold.dotsThreeOutline` |

- Route names: kebab-case strings in `RouteNames` class (~55 routes)
- Guard stubs: `AuthGuard`, `KycGuard`, `StepUpGuard`
- Initial location: `/home`

### Drift (SQLite)

- Schema version: 1
- 4 cached tables: `CachedTransactions`, `CachedPayees`, `CachedPiaCards`, `CachedPensionContributions`
- In-memory DB during bootstrap (swapped for production later)

### Dio (HTTP)

- Base URL: `https://api.tisini.co/v1`
- Timeouts: 15s (connect, receive, send)
- Interceptor chain (order matters):
  1. `ConnectivityInterceptor` — rejects if offline
  2. `AuthInterceptor` — adds Bearer token, handles 401 refresh with queue
  3. `ErrorInterceptor` — maps `DioException` → `AppException`

### Error Handling

Sealed exception hierarchy:

```
AppException (message, code)
├── NetworkException
│   ├── TimeoutException
│   └── NoConnectionException
├── ServerException (statusCode, details)
├── BusinessException
│   ├── InsufficientBalanceException
│   ├── KycRequiredException
│   └── PaymentFailedException (reason)
├── ValidationException (fieldErrors)
└── AuthException
    └── SessionExpiredException
```

Sealed failure hierarchy:

```
Failure (message)
├── ServerFailure
├── NetworkFailure
└── CacheFailure
```

`ErrorHandler.withRetry()` — exponential backoff, retries on 5xx only, max 3 retries, 1s initial delay.

### Storage

| Layer | Class | Backend |
|---|---|---|
| Secrets | `SecureStorage` | FlutterSecureStorage (tokens, PIN hash, biometric flag) |
| Preferences | `Preferences` | SharedPreferences (onboarding, feature flags, step-up) |
| Cache | `AppDatabase` | Drift/SQLite (transactions, payees, PIA cards, contributions) |

## Design System

| Category | Class | Details |
|---|---|---|
| Colors | `AppColors` | Brand: darkBlue, green, cyan, red. Semantic: success, error, info, warning. Zones: red/amber/green |
| Typography | `AppTypography` | 12+ styles: display, headline (L/M/S), title (L/M), body (L/M/S), label (L/M/S), amount (L/M) |
| Spacing | `AppSpacing` | 8-point scale: xs(4)–xxxl(48). Aliases: cardPadding, sectionGap, screenPadding |
| Radii | `AppRadii` | card(16), pill(999), input(12), button(12), modal(24) |
| Shadows | `AppShadows` | `cardShadow` |
| Borders | `AppBorders` | `cardBorder` |
| Theme | `AppTheme.light` | Material 3, Inter font |
| Icons | — | `phosphor_flutter` (bold weight) |

## Code Conventions

- **Imports:** Always `package:tisini/...` (never relative) — enforced by `very_good_analysis`
- **Constant classes:** Use `abstract final class` (no instantiation, no subclassing)
- **Provider naming:** `<noun>Provider` (e.g., `dioProvider`, `authStateProvider`)
- **Route names:** Kebab-case strings (e.g., `'send-recipient'`)
- **Constructors:** Always `const` where possible, use `super.key` pattern
- **Dependency injection:** Constructor injection for testability
- **TODOs:** `// TODO(tisini): description`

## Linting

- Base: `very_good_analysis ^6.0.0`
- Override: `public_member_api_docs: false`
- Suppressed: `invalid_annotation_target: ignore`
- Excluded from analysis: `**/*.g.dart`, `**/*.freezed.dart`, `lib/gen/**`
- CI: `flutter analyze --fatal-infos` (infos are fatal)

## Generated Files

Run `dart run build_runner build --delete-conflicting-outputs` before running or testing.

| Generator | Output Pattern |
|---|---|
| `drift_dev` | `*.g.dart` (database) |
| `freezed` | `*.freezed.dart` |
| `json_serializable` | `*.g.dart` (JSON) |
| `riverpod_generator` | `*.g.dart` (providers) |
| `envied_generator` | `*.g.dart` (env vars) |

All generated files are gitignored (`*.g.dart`, `*.freezed.dart`, `*.mocks.dart`, `lib/gen/`).

## Testing

- **Frameworks:** `flutter_test` + `mocktail`
- **Pattern:** Inline `Mock` subclasses, `setUp` for shared state, `group`/`test` nesting
- **SharedPreferences mock:** Call `SharedPreferences.setMockInitialValues({})` in `setUp`
- **Run tests:** `flutter test`
- **Run with coverage:** `flutter test --coverage`
- Test directory mirrors `lib/` structure

## CI Pipeline

**File:** `.github/workflows/ci.yml`

**Triggers:** Push to `main`, PRs targeting `main`

**Steps (ubuntu-latest):**
1. Checkout
2. Setup Flutter 3.24.x (stable, cached)
3. `flutter pub get`
4. `dart run build_runner build --delete-conflicting-outputs`
5. `dart format --set-exit-if-changed .`
6. `flutter analyze --fatal-infos`
7. `flutter test --coverage`
8. `flutter build apk --debug`

## Git Conventions

- **Commits:** Conventional Commits — `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`, `ci:`
- **PRs:** Target `main`

## Development Workflow

### Reference Documents

| Document | Path | Purpose |
|---|---|---|
| Technical Spec | `docs/TECHNICAL_SPEC.md` | Full product + technical specification (large — read with offset/limit) |
| Design Brief | `TISINI UI_UX + PRODUCT DESIGN BRIEF (1).pdf` | UI/UX and product design reference |

### Sprint Process

1. **Plan** — Use plan mode to design the sprint. Output: a plan with numbered issues, deps, file lists, and acceptance criteria per issue.
2. **Create GitHub milestone** — `gh api repos/joshwizzy/TISINI/milestones -f title="Sprint N: Title" -f description="..."`
3. **Create GitHub issues** — One issue per plan item. Each issue gets:
   - Title matching the plan issue title
   - Body: bullet-list of files/changes + acceptance criteria
   - Labels: `sprint-N` + relevant category labels
   - Milestone: the sprint milestone
4. **Implement** — Work through issues respecting the dependency graph. For each issue:
   - Create a task to track progress
   - Write code + tests
   - Run `flutter analyze --fatal-infos` and `flutter test` incrementally
5. **Close GitHub issues** — Close each issue after its code + tests pass
6. **Final verification** — Run the full checklist:
   - `flutter pub get`
   - `dart run build_runner build --delete-conflicting-outputs`
   - `flutter analyze --fatal-infos` — 0 issues
   - `flutter test` — all pass
   - `dart format --set-exit-if-changed .` — 0 changes
7. **Commit + push** — Single commit per sprint (or per issue if preferred)

### GitHub Conventions

- **Milestone format:** `Sprint N: Title` (e.g., `Sprint 1: Foundation`)
- **Sprint label format:** `sprint-N` (e.g., `sprint-1`, `sprint-2`)
- **Category labels:** `setup`, `architecture`, `design-system`, `infra`, `ci`, `auth`, `ui`, `feature`
- **Issue body format:** Bullet list of deliverables + acceptance criteria
- **Repo:** joshwizzy/TISINI

## Product Constraints

- **Banned words** (never use in UI copy or code strings): crypto, blockchain, DeFi, token, Web3, mining, yield, staking, protocol, DAO, decentralized, NFT, airdrop
- **Stablecoin:** Deferred to Phase 2 — do not implement stablecoin features
- **Feature flags:** Stored via `Preferences` with `ff_` prefix (e.g., `ff_dark_mode`)

## Reference Files

| File | Purpose |
|---|---|
| `docs/TECHNICAL_SPEC.md` | Full product + technical specification |
| `lib/main.dart` | App entry point |
| `lib/bootstrap.dart` | Async initialization + provider overrides |
| `lib/app.dart` | `TisiniApp` widget (MaterialApp.router) |
| `lib/core/constants/api_constants.dart` | API base URL + timeouts |
| `lib/core/router/app_router.dart` | GoRouter + 5-tab shell |
| `lib/core/router/route_names.dart` | All route name constants |
| `lib/core/providers/core_providers.dart` | Core Riverpod providers |
| `lib/core/storage/database/app_database.dart` | Drift schema (4 tables) |
| `lib/core/errors/exceptions.dart` | Sealed exception hierarchy |
| `lib/core/theme/app_theme.dart` | Material 3 theme |
| `lib/shared/widgets/bottom_nav_scaffold.dart` | Bottom navigation scaffold |
| `.github/workflows/ci.yml` | CI pipeline |
| `analysis_options.yaml` | Linting configuration |
| `TISINI UI_UX + PRODUCT DESIGN BRIEF (1).pdf` | UI/UX and product design reference |
