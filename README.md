# Kiray Bet

Kiray Bet is a Flutter prototype for discovering and managing rental listings in Addis Ababa. Milestone 1 is a role-based, in-memory application: it demonstrates the main tenant, owner, and administrator workflows without a remote backend or persistent storage.

## Current capabilities

- **Authentication and roles:** seeded demo accounts, tenant/owner registration, shared profile state, role-aware route protection, and role-based navigation.
- **Tenant workflows:** browse listings, filter and sort, view listing details, save favourites, submit viewing requests, and report a listing.
- **Owner workflows:** create and edit listings, update listing availability, and accept or decline viewing requests.
- **Administrator workflows:** review reports, resolve reports, and hide listings from browse results.
- **Profile and settings:** edit profile details, change theme and language, and sign out. The notification preference is session-only and does not send notifications.
- **Localization:** English and Amharic UI, including Amharic display translations for seeded listing titles, descriptions, sub-cities, and neighbourhoods. User-entered listing content remains as entered.
- **Currency:** listing rent is displayed using the shared Ethiopian Birr formatter.

### Navigation

| Role | Bottom navigation |
|---|---|
| Tenant | Browse, Map, Favourites, Viewing Requests, Profile and Settings |
| Owner | My Listings, Browse, Viewing Requests, Profile and Settings |
| Admin | Moderation, Browse, Profile and Settings |

Protected routes redirect signed-out users to Login. Users without the required role are redirected to their role's home and shown an access-denied message. The router uses a single indexed-stack shell to preserve tab state.

### Routes

| Route | Screen or flow |
|---|---|
| `/onboarding`, `/welcome` | Onboarding and language selection |
| `/login`, `/register` | Authentication |
| `/listings`, `/listings/filter`, `/listings/map` | Browse, filter/sort, and map preview |
| `/listings/:id`, `/listings/:id/edit` | Listing details and editing |
| `/favorites` | Saved listings |
| `/post`, `/profile/my-listings` | Listing creation and owner listings |
| `/viewing-requests`, `/viewing-requests/:listingId` | Request list and request flow |
| `/report/:listingId`, `/moderation` | Reporting and administrator moderation |
| `/profile`, `/profile/settings` | Profile and settings |

Unknown listing IDs have not-found handling on detail, edit, and report flows. The map is a local schematic preview; it does not use GPS or online map tiles.

## Technology and architecture

- Flutter and Dart, using Flutter Material widgets.
- Riverpod for application state and dependency injection.
- GoRouter for route configuration, role guards, and the indexed-stack navigation shell.
- Freezed and JSON serialization for immutable domain models.
- Flutter localization delegates plus the app's English/Amharic string layer.

The application entry point is `lib/main.dart`, which starts `KirayBetApp` inside a Riverpod `ProviderScope`. `lib/app.dart` configures the router, themes, locale, and localization delegates.

```text
lib/
├── app.dart
├── main.dart
├── core/
│   ├── constants/       # Route paths, route names, and demo IDs
│   ├── formatters/      # Shared Birr formatting
│   ├── localization/    # Shared English/Amharic strings
│   ├── router/          # GoRouter, guards, and role-based app shell
│   ├── theme/           # Light and dark themes
│   ├── validation/      # Shared form validation
│   └── widgets/         # Shared app, loading, empty, and error widgets
└── features/
    ├── authentication/
    ├── favorites/
    ├── listings/
    ├── onboarding/
    ├── profile/
    └── report/
```

Feature code is organized into `domain/`, `data/`, and `presentation/` layers. Domain repositories define feature contracts; data-layer in-memory implementations provide the current data source; presentation providers and screens connect the UI to those contracts. Freezed model classes live in the domain layers. The `compare/` directory is currently scaffolding only and is not connected to the router or bottom navigation.

## Demo accounts

All demo accounts use the password `Demo1234`.

| Role | Email |
|---|---|
| Tenant | `tenant@kiray.demo` |
| Owner | `owner@kiray.demo` |
| Admin | `admin@kiray.demo` |

These are local demonstration credentials, not production accounts.

## Run locally

### Requirements

- Flutter SDK with a Dart SDK compatible with the project's `^3.13.5` constraint.
- An available Flutter target such as an emulator, simulator, or connected device.

### Commands

```bash
flutter pub get
flutter run
```

Run static analysis and the test suite with:

```bash
flutter analyze --fatal-infos
flutter test
```

The latest recorded Milestone 1 validation reports no analyzer issues and 119 passing tests across 29 test files.

## Current limitations

- Authentication, listings, favourites, viewing requests, profile settings, and reports are held in memory; changes do not persist across app restarts.
- There is no Firebase, REST service, database, or offline storage integration.
- Map markers are illustrative; live maps, GPS, and location search are not implemented.
- Listing images and owner contact details are placeholders; camera and gallery upload are not implemented.
- Notification settings do not deliver notifications.
- Listing descriptions are entered manually; an AI description generator is not implemented.
