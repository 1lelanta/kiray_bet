# AI usage disclosure: Kiray Bet, Milestone 1

## Tools used

| Member | Tool | Version / model | Used for |
|---|---|---|---|
| Miruts Gebremeskel | Codex | 6.0 luna| Explanations, debugging suggestions, and implementation guidance for listing features: model/repository, browse, details, listing management, and viewing requests. |
| Lammi Abraham | Antigravity |gemini flash 3.8| Explanations, debugging suggestions, and implementation guidance for authentication: accounts, shared authentication and language state, login, and registration. |
| Lelisa Tesfaye | GitHub Copilot |gpt 6| Explanations, debugging suggestions, and implementation guidance for the project skeleton, core structure, router, shell, and route guards. |
| Natnael Girmay | ChatGPT | 6 | Explanations, debugging suggestions, and implementation guidance for favourites, reports, localization, and the Flutter Material refactor. |
| Molalign Michael | Claude |Opus 5.5| Explanations, debugging suggestions, and implementation guidance for profile and settings features. |


## What was generated and where

| Files / area | Member | AI-use level | What the tool produced | What the team changed or retained responsibility for | How it was checked |
|---|---|---|---|---|---|
| `lib/features/listings/` (listing model/repository, browse, details, listing management, viewing requests) | Miruts |3 — Draft and verify | Explanations of the feature structure and possible fixes, and implementation steps for listing workflows. | I reviewed suggestions against the existing in-memory/provider design and were responsible for the final feature code, and my team members gave comments| Listing repository, form, browse/filter, map, and viewing-request tests in `test/features/listings/`were tested; the integrated app was also covered by Flutter analysis and tests, and through running in chrome. |
| `lib/features/authentication/` (accounts, shared authentication/language state, login, registration) | Lammi |3 — Draft and verify | Explanations and possible fixes for authentication, account state, and language-selection behavior. | I reviewed suggestions and was responsible for the final implementation, my team members reviewed and approved.| by running the authentication repository, provider, and entry-screen tests in `test/features/authentication/`. |
| `lib/features/profile/` (profile, settings) | Molalign |3 — Draft and verify | Explanations and possible fixes for profile editing and settings behavior. | I reviewed suggestions against the shared in-memory state and was responsible for the final implementation | by running the profile, settings, and app-settings tests in `test/features/profile/`. and flutter analyze|
| `lib/features/favorites/`, `lib/features/report/`, `lib/core/localization/` | Natnael |3 — Draft and verify | Explanations and possible fixes for favourites, reporting/moderation, localization, and Material-library compatibility. | I reviewed suggestions and was responsible for the final implementation| Relevant repository, presentation, localization, and widget tests in `test/features/favorites/`, `test/features/report/`, and `test/` were tested.|
| `lib/core/` and `lib/core/router/` (project structure, router, shell, guards) | Lelisa |3 — Draft and verify | Explanations and possible fixes for routing, role access, navigation, and core organization. | I reviewed suggestions against the existing GoRouter/Riverpod design and was responsible for the final implementation and my team members reviewed and approved my implementation. | by testing Router guard and bottom-navigation tests in `test/core/router/`; integrated behavior is also covered by Flutter tests. |


Every pull request was reviewed by a member other than its author before merging (see `MILESTONE.md`).

## Work completed without AI assistance

we designed folder structure, implementation guideline and scope specification independently because we wanted to understand the project requirements, establish a clear direction, and make our own architectural decisions as a team. This helped us agree on the project's organization, define what needed to be implemented, and set consistent guidelines before starting development.

## Problems found in AI output

we faced poor modularization, duplicated logic, unused imports, and inconsistent structure. Some implementations also caused failed tests or missed requirements. We reviewed, corrected, and tested the output to ensure code quality and consistency with our project guidelines.
## Individual declaration

Each member must personally confirm the first two fields and provide their own signature. Do not treat this draft as a completed personal attestation.

| Name | I wrote or reviewed and can explain these files | I entered no passwords, keys or personal data into an AI tool (yes / no) | Signature |
|---|---|---|---|
| Lelisa Tesfaye | `lib/core/constants/route_paths.dart`; `lib/core/router/app_router.dart`; `lib/core/router/app_shell.dart`; `lib/core/localization/common_strings.dart`; `lib/features/listings/data/in_memory_listing_repository.dart`; `lib/features/profile/presentation/screens/profile_details_screen.dart` | yes | Lelisa Tesfaye |
| Miruts Gebremeskel | `lib/features/listings/domain/listing.dart`; `lib/features/listings/data/in_memory_listing_repository.dart`; `lib/features/listings/presentation/screens/listings_screen.dart`; `lib/features/listings/presentation/screens/viewing_requests_screen.dart`; `lib/features/authentication/data/in_memory_authentication_repository.dart`; `lib/features/report/presentation/widgets/report_card.dart` | yes | Miruts Gebremeskel |
| Natnael Girmay | `lib/features/favorites/domain/favorite.dart`; `lib/features/favorites/presentation/widgets/favorite_button.dart`; `lib/features/report/data/in_memory_reports_repository.dart`; `lib/core/localization/l10n.dart`; `lib/core/router/app_router.dart`; `lib/features/listings/presentation/screens/listing_detail_screen.dart` | yes | Natnael Girmay |
| Molalign Michael | `lib/features/profile/presentation/screens/profile_details_screen.dart`; `lib/features/profile/data/in_memory_profile_repository.dart`; `lib/features/profile/presentation/screens/account_settings_screen.dart`; `lib/features/profile/presentation/providers/app_settings_provider.dart`; `lib/core/widgets/app_scaffold.dart`; `lib/core/router/app_shell.dart` | yes | Molalign Michael |
| Lammi Abraham | `lib/features/authentication/domain/user_profile.dart`; `lib/features/authentication/data/in_memory_authentication_repository.dart`; `lib/features/authentication/presentation/providers/authentication_providers.dart`; `lib/features/authentication/presentation/screens/registration_screen.dart`; `lib/core/router/app_router.dart`; `lib/features/listings/presentation/screens/listing_form_screen.dart` | yes | Lammi Abraham |

