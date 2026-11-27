# Lammi — Profile changes

PR: `feat: implement profile` · Branch: `feat/profile` · Base: `main` at `d958c6e`

This document records every file created or modified for Lammi's
**Profile** assignment, how each file uses the existing shared code, and
what is still needed from other developers. Settings is a separate PR
(`feat: implement settings`, documented in `docs/lammi-settings-changes.md`).
The two PRs share no files and can be merged in either order.

## What Profile does

- Shows the signed-in user's name, email, phone and role.
- Lets the user edit name and phone. Email and role are read-only.
- Validates name and phone with the existing `FormValidators`.
- Shows loading, success and error states while saving.
- Updates the shared `currentUserProvider` after a successful save, so
  every screen sees the new details.
- Shows a sign-in prompt to signed-out users.
- Has a settings icon that opens the existing `/profile/settings` route.

## Ownership and authorization

- **Modified with approval:** `profile_screen.dart`, a placeholder created by
  Lelisa (team lead) in the project skeleton. Its body now shows the new
  screen and the class name is unchanged. Lelisa has been notified.
- **Not modified:** every other existing file, including the router,
  `app.dart`, the authentication and listings features, all `*Strings`
  classes, generated files, `pubspec.yaml`, `pubspec.lock` and existing tests.

## Files

All paths are under `lib/features/profile/` unless shown in full.

### Modified

#### `presentation/screens/profile_screen.dart`
- **Status:** Modified (Lelisa's placeholder, changed with approval).
- **Purpose:** `ProfileScreen.build` returns `const ProfileDetailsScreen()`
  instead of the placeholder `AppScaffold` + `EmptyState`.
- **Why necessary:** `app_router.dart` already sends the Profile tab
  (`/profile`) to `ProfileScreen`. This makes Profile reachable without
  touching the router. It's the same pattern as `PostListingScreen` →
  `ListingFormScreen`.
- **Interaction:** The class name is kept, so `app_router.dart` and
  `test/core/router/bottom_nav_test.dart` need no change.

### Created

#### `domain/profile_repository.dart`
- **Purpose:** The `ProfileRepository` interface: `getCurrentProfile()` and
  `Future<UserProfile> updateProfile({name, phone})`.
- **Why necessary:** Keeps Profile behind the same repository pattern as the
  other features. Its asynchronous signature is ready for a future Firestore
  implementation.
- **Interaction:** Uses the shared `UserProfile`. There is no new user model.

#### `data/in_memory_profile_repository.dart`
- **Purpose:** `InMemoryProfileRepository`. It delegates reads to
  `AuthenticationRepository.getCurrentUser()` and updates to
  `AuthenticationRepository.updateProfile(name:, phone:)`.
- **Why necessary:** One source of user data, so this is not a second
  authentication system.
- **Interaction:** Email, role, id and `preferredLanguage` stay unchanged on
  update. Signed-out updates surface the existing
  `AuthenticationFailure.signInRequired`.

#### `presentation/providers/profile_providers.dart`
- **Purpose:**
  - `profileRepositoryProvider`, built from the existing
    `authenticationRepositoryProvider`.
  - `profileUpdateProvider` (auto-dispose): the save status as an
    `AsyncValue<UserProfile?>` (idle → loading → success or error).
- **Why necessary:** Provides the loading, success and error states. After a
  successful save it calls `ref.invalidate(currentUserProvider)`, so shared
  user state rebuilds from the repository.
- **Interaction:** Reuses `currentUserProvider`. `selectedLanguageProvider`
  rebuilds from the unchanged `preferredLanguage`, so the language is kept.

#### `presentation/screens/profile_details_screen.dart`
- **Purpose:** `ProfileDetailsScreen`, the Profile UI.
  - Shows name, email, phone and role.
  - Email and role are read-only fields with a lock icon.
  - Name and phone are editable and validated with the existing
    `FormValidators`, using the existing `AuthenticationStrings` messages.
  - The save button shows a spinner while saving, then a success SnackBar
    or an inline error.
  - Signed-out users see an `EmptyState` with a button that opens Login.
  - A settings icon opens `RoutePaths.settings`.
- **Interaction:** Uses `AppScaffold`, `EmptyState`, `currentUserProvider`,
  `profileUpdateProvider`, `RoutePaths.login` and `RoutePaths.settings`.

#### `presentation/profile_strings.dart`
- **Purpose:** `ProfileStrings`, holding every new user-facing string on the
  Profile screen.
- **Why necessary:** Follows the project's per-feature strings convention
  (`AuthenticationStrings`, `ListingStrings`). The screen contains no
  hardcoded text.

### Tests and documentation

| File | Covers |
|---|---|
| `test/features/profile/profile_test_app.dart` | Test-only router for focused screen tests. `/profile/settings` and `/login` point at the app's existing screens |
| `test/features/profile/profile_repository_test.dart` | Delegation, trimming, email/role/language kept, signed-out failure |
| `test/features/profile/profile_providers_test.dart` | Loading → success, shared `currentUserProvider` update, language kept, signed-out error state |
| `test/features/profile/profile_details_screen_test.dart` | Signed-out prompt, displayed fields, read-only email/role, validation, successful save, loading and error UI, settings link |
| `test/features/profile/profile_navigation_test.dart` | The **real** `KirayBetApp` and router: the Profile tab shows the profile, and the settings icon reaches the Settings route |
| `docs/lammi-profile-changes.md` | This document |

## Integration notes (recommendations only)

| Developer | Item | Essential? |
|---|---|---|
| Lelisa Tesfaye | `app_router.dart` doesn't refresh on sign-in or sign-out, and doesn't block signed-out users from `/profile`. The Profile screen already handles a signed-out user | Optional |
| Natnael Girmay | There's no translation framework yet, so `ProfileStrings` is English only. Move its keys into the project's localization when it lands | Optional for this PR |
| Natnael Girmay | `refactor/flutter-material` switches `material_ui` imports to `flutter/material`. Whichever lands second updates the imports in these files | Coordination |

## Known limitations

- Text stays English until project-wide localization exists.
- If Profile merges before Settings, the settings icon opens the current
  Settings placeholder until the Settings PR lands.
