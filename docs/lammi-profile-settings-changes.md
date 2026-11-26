# Lammi — Profile and Settings changes

Branch: `feat/profile-and-settings-and-AI-description-generator`
Base: `main` at `d958c6e` (working tree was clean before this work)

This document records every file created or modified for Lammi's
**Profile** (PR 1) and **Settings** (PR 2) assignments, how each file uses
the existing shared code, and what is still needed from other developers.

## Assignments identified for Lammi

| Assignment | Source | Status in this PR |
|---|---|---|
| Profile | Team task list; `PROPOSAL.md` §5 "Profile and Settings" screen | Done, but not yet reachable in the running app (see integration 1) |
| Settings | Team task list; `PROPOSAL.md` §5, §7 (theme, language preferences) | Done. Theme switching works in the running app. The screen itself isn't reachable yet (see integration 2) |
| AI description generator | `PROPOSAL.md` §2 and §9; branch name | **Not in this PR** (scope decision). See "Other Lammi work" |
| GPS and camera integration | `PROPOSAL.md` §2 | **Not in this PR**. See "Other Lammi work" |
| Testing and release preparation | `PROPOSAL.md` §2 | Tests added for this PR's work. Release preparation still to do |

## Ownership and authorization

- **Authorized to modify:** `lib/features/profile/presentation/providers/theme_mode_provider.dart`.
  Lelisa (team lead) created it as a placeholder with an explicit handoff:
  *"Placeholder. Lemmi replaces this with the real provider backed by
  settings. Keep the name themeModeProvider."* The name and the
  `Provider<ThemeMode>` type are unchanged, so `lib/app.dart` needed no edit.
- **Not modified (owner did not authorize):** `profile_screen.dart` and
  `settings_screen.dart` placeholders (Lelisa). The new screens live in new
  files instead.
- **Not modified:** every other existing file, including the router,
  `app.dart`, the theme, shared widgets, the authentication feature, the
  listings feature, all `*Strings` classes, all generated files, `pubspec.yaml`,
  `pubspec.lock` and all existing tests.

## Files

### Modified

#### `lib/features/profile/presentation/providers/theme_mode_provider.dart`
- **Status:** Modified (authorized handoff, see above).
- **Purpose:** `themeModeProvider` now derives `ThemeMode.system / light / dark`
  from `appSettingsProvider` instead of always returning `ThemeMode.system`.
- **Why necessary:** `KirayBetApp` (`lib/app.dart`) already applies
  `ref.watch(themeModeProvider)` to `MaterialApp.router`. This is the only
  way to make the Settings theme choice change the real app without
  touching Lelisa's `app.dart` or `AppTheme`.
- **Assignment:** Settings (theme).
- **Interaction:** Reads `appSettingsProvider`. It's still read by
  `app.dart`, which uses the existing `AppTheme.light` / `AppTheme.dark`.
- **Outstanding:** None.

### Created — Profile (PR 1)

#### `lib/features/profile/domain/profile_repository.dart`
- **Status:** New.
- **Purpose:** The `ProfileRepository` interface: `getCurrentProfile()` and
  `Future<UserProfile> updateProfile({name, phone})`.
- **Why necessary:** Required by the assignment. It keeps Profile behind the
  same repository pattern as the other features. Its asynchronous signature
  is ready for a future Firestore implementation.
- **Interaction:** Returns the shared `UserProfile`. There is no new user model.
- **Outstanding:** None.

#### `lib/features/profile/data/in_memory_profile_repository.dart`
- **Status:** New.
- **Purpose:** `InMemoryProfileRepository`. It delegates reads to
  `AuthenticationRepository.getCurrentUser()` and updates to
  `AuthenticationRepository.updateProfile(name:, phone:)`.
- **Why necessary:** Required in-memory implementation. Delegating keeps
  one source of user data, so this is not a second authentication system.
- **Interaction:** Email, role, id and `preferredLanguage` are left to
  the authentication repository, which keeps them unchanged on update.
  Signed-out updates surface the existing
  `AuthenticationFailure.signInRequired`.
- **Outstanding:** None.

#### `lib/features/profile/presentation/providers/profile_providers.dart`
- **Status:** New.
- **Purpose:**
  - `profileRepositoryProvider`, built from the existing
    `authenticationRepositoryProvider`. Test overrides of that provider
    therefore apply automatically.
  - `profileUpdateProvider` (auto-dispose): an `AsyncValue<UserProfile?>`
    save status (idle → loading → success/error).
- **Why necessary:** Provides the loading, success and error states. After a
  successful save it calls `ref.invalidate(currentUserProvider)` so the
  shared current-user state rebuilds from the repository and every screen
  sees the new name and phone.
- **Interaction:** Reuses `currentUserProvider`. `selectedLanguageProvider`
  rebuilds from the unchanged `preferredLanguage`, so the language is kept.
- **Outstanding:** None.

#### `lib/features/profile/presentation/screens/profile_details_screen.dart`
- **Status:** New.
- **Purpose:** `ProfileDetailsScreen`.
  - Shows name, email, phone and role.
  - Email and role are read-only fields with a lock icon.
  - Name and phone are editable and validated with the existing
    `FormValidators.name` and `FormValidators.phone`, using the existing
    `AuthenticationStrings` messages.
  - The save button shows a spinner while saving, and a success SnackBar
    or an inline error afterwards.
  - Signed-out users see an `EmptyState` with a button that opens Login.
  - A settings icon opens `RoutePaths.settings`.
- **Why necessary:** The Profile UI. It is a new file because
  `profile_screen.dart` is Lelisa's placeholder.
- **Interaction:** Uses `AppScaffold`, `EmptyState`, `currentUserProvider`,
  `profileUpdateProvider`, `RoutePaths.login` and `RoutePaths.settings`.
- **Outstanding:** **Not reachable in the running app** until
  `ProfileScreen` renders it (integration 1).

### Created — Settings (PR 2)

#### `lib/features/profile/domain/app_settings.dart` and `app_settings.freezed.dart`
- **Status:** New. The `.freezed.dart` file is generated by freezed 4.0.3,
  the project's existing version.
- **Purpose:** The `AppSettings` freezed model (`themePreference`,
  `notificationsEnabled`) and the `AppThemePreference { system, light, dark }`
  enum. The domain layer stays independent of Flutter, and the mapping to
  `ThemeMode` is in `theme_mode_provider.dart`.
- **Why necessary:** Required AppSettings model and state. The language is
  deliberately not stored here, because the shared `selectedLanguageProvider`
  owns it.
- **Outstanding:** None.

#### `lib/features/profile/presentation/providers/app_settings_provider.dart`
- **Status:** New.
- **Purpose:** `appSettingsProvider` (`AppSettingsNotifier`), which holds the
  settings in memory only, with `setThemePreference` and
  `setNotificationsEnabled`.
- **Why necessary:** State for the Settings screen and the source for
  `themeModeProvider`.
- **Outstanding:** Settings reset when the app restarts (see limitations).

#### `lib/features/profile/presentation/screens/account_settings_screen.dart`
- **Status:** New.
- **Purpose:** `AccountSettingsScreen`, with these parts:
  - **Theme:** System / Light / Dark segmented control backed by `appSettingsProvider`.
  - **Language:** Shows the current language and offers an English / አማርኛ
    switch. It calls the existing `selectedLanguageProvider.setLanguage`,
    which also saves the choice to the signed-in user's profile.
  - **Notifications:** An on/off switch stored in memory. No notifications
    are sent and there is no notification infrastructure.
  - **Shortcuts by role**, using existing routes and screens only:
    - Owner: My Listings (`RoutePaths.myListings`)
    - Tenant: Favorites (`RoutePaths.favorites`) and Viewing Requests
      (`RoutePaths.viewingRequests`)
    - Admin: Moderation (`RoutePaths.moderation`)
  - **Sign out:** A confirmation dialog, then the existing
    `CurrentUserNotifier.signOut()`, then `context.go(RoutePaths.login)`.
    Signed-out users get a "Sign in" entry instead.
- **Why necessary:** The Settings UI. It is a new file because
  `settings_screen.dart` is Lelisa's placeholder.
- **Interaction:** Reuses `AuthenticationStrings.language`, `.english`,
  `.amharic` and `.moderationTitle`, and `ListingStrings.myListings` and
  `.viewingRequests`. These are read only, not modified.
- **Outstanding:** **Not reachable in the running app** until
  `SettingsScreen` renders it (integration 2).

### Created — shared by both assignments

#### `lib/features/profile/presentation/profile_strings.dart`
- **Status:** New.
- **Purpose:** `ProfileStrings`, holding every new user-facing string for
  Profile and Settings.
- **Why necessary:** The project's localization convention is a
  per-feature constants class (`AuthenticationStrings`, `ListingStrings`).
  There is no ARB, `flutter_localizations` or `AppLocalizations` setup.
  The new screens contain no hardcoded UI text. Every string comes from
  `ProfileStrings` or an existing strings class.
- **Outstanding:** English only. See integration 4.

### Created — documentation and tests

| File | Covers |
|---|---|
| `docs/lammi-profile-settings-changes.md` | This document |
| `test/features/profile/profile_test_app.dart` | Test-only harness. Maps `/profile` and `/profile/settings` to the new screens, and every other route to the app's **existing** screens (Login, My Listings, Favorites, Viewing Requests, Moderation placeholder). Applies `themeModeProvider` the same way `app.dart` does |
| `test/features/profile/profile_repository_test.dart` | Delegation, trimming, email/role/language preserved, signed-out failure |
| `test/features/profile/profile_providers_test.dart` | Loading → success, shared `currentUserProvider` update, language kept, signed-out error state |
| `test/features/profile/app_settings_provider_test.dart` | Defaults, theme mapping, notifications toggle, and that the **real** `KirayBetApp` switches to dark |
| `test/features/profile/profile_details_screen_test.dart` | Signed-out prompt, displayed fields, read-only email/role, validation, successful save, loading and error UI, settings link |
| `test/features/profile/account_settings_screen_test.dart` | Theme, language (shared provider plus profile), notifications, sign-out with confirm and cancel, shortcuts for owner, tenant, admin and signed-out users |

## Integration requirements (not done — recommendations only)

| # | Developer | File | Existing implementation | Required change | Essential? |
|---|---|---|---|---|---|
| 1 | Lelisa Tesfaye (`1lelanta`) | `lib/features/profile/presentation/screens/profile_screen.dart` | `ProfileScreen`, a placeholder `StatelessWidget` returning `AppScaffold` + `EmptyState` | Make `build` return `const ProfileDetailsScreen()` and import `profile_details_screen.dart`. This is the same wrapper pattern as `PostListingScreen` → `ListingFormScreen`. Keeping the class name means `app_router.dart` and `test/core/router/bottom_nav_test.dart` need no change | **Essential.** Without it the Profile tab still shows the placeholder |
| 2 | Lelisa Tesfaye (`1lelanta`) | `lib/features/profile/presentation/screens/settings_screen.dart` | `SettingsScreen` placeholder | Make `build` return `const AccountSettingsScreen()` and import `account_settings_screen.dart` | **Essential.** Without it `/profile/settings` shows the placeholder |
| 3 | Lelisa Tesfaye (`1lelanta`) | `lib/core/router/app_router.dart` | `refreshListenable` only listens to `onboardingNotifierProvider`, and the redirect doesn't guard shell routes for signed-out users | Optionally also `ref.listen(currentUserProvider, …)` to refresh the router, and redirect signed-out users away from `/profile/**` | Optional. Settings already navigates to Login after sign-out, and both screens handle a signed-out user |
| 4 | Natnael Girmay | Localization (no files yet) | English-only `*Strings` constant classes. `selectedLanguageProvider` stores `'en'` or `'am'`, but UI text doesn't change | When the project's Amharic/English localization lands, move the `ProfileStrings` keys into it. The keys map 1:1 | Optional for this PR. Needed for the project's Amharic UI goal |
| 5 | Natnael Girmay | Branch `origin/refactor/flutter-material` | Replaces `package:material_ui` imports with `package:flutter/material.dart` across the project | Whichever PR merges second should switch the `material_ui` import in this PR's screens, `theme_mode_provider.dart` and profile tests to `flutter/material.dart` | Optional coordination. Expect a small import conflict |
| 6 | Molalign Michael (local storage) / team | `pubspec.yaml` (no change made) | No `shared_preferences` dependency. `PROPOSAL.md` §7 plans SharedPreferences for language and theme | Add persistence for `AppSettings` and the language choice, after the team approves the dependency | Optional. The assignment specified in-memory storage |

Notes on shortcut targets, where no change is needed:
- `RoutePaths.favorites` currently shows Lelisa's placeholder `FavoritesScreen`.
  Natnael's `feat/favorite-model` will replace it behind the same route.
- `RoutePaths.moderation` currently shows `AuthFeaturePlaceholderScreen`.
  Natnael's `feat/report-flow` adds a `ModerationScreen`. If it keeps the
  `/moderation` path, the Settings shortcut picks it up automatically.

## Other Lammi work not in this PR

- **AI description generator.** `ListingDescriptionField` in
  `lib/features/listings/presentation/screens/listing_form_screen.dart:345`
  (Miruts) already exposes an optional
  `builder(context, ListingDraftValues, controller)` slot. `ListingDraftValues`
  carries the sub-city, neighbourhood, rent, bedrooms, bathrooms and amenities.
  Wiring a generator in needs these decisions and changes:
  - a choice of AI provider and API-key handling
  - an approved HTTP or SDK dependency
  - Miruts passing `builder:` at `listing_form_screen.dart:107`
- **GPS and camera.** These need approved `geolocator` and `image_picker`
  (or similar) dependencies, plus integration in Miruts's listing form
  ("Add placeholder photo") and map ("Near me (coming later)").
- **Release preparation.** Still to do.

## Known limitations

- Theme and notification preferences are held in memory and reset when the
  app restarts.
- The notifications switch only stores a preference. Nothing is delivered.
- Changing the language updates shared state and the user's
  `preferredLanguage`, but UI text stays English until project-wide
  localization exists (integration 4).
- Profile and Settings are reachable in the app only after integrations 1
  and 2. Until then they are exercised through the test harness, while
  theme switching already works in the real app.
