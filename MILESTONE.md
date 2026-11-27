# Kiray Bet — Milestone 1

## 1. What is done

All 15 screens from `PROPOSAL.md` exist, are reachable through `go_router`, and run on in-memory data.

| Proposal screen | Route | Status |
|---|---|---|
| Splash and Language Selection | `/welcome` | Done, language selection is wired to the shared language state |
| Login | `/login` | Done, signs in through the in-memory authentication provider |
| Registration | `/register` | Done, creates tenant/owner accounts in memory (admin signup rejected) |
| Home/Browse | `/listings` | Done, listing data from providers; photos are placeholders |
| Filter and Sort | `/listings/filter` | Done, sub-city, neighbourhood, rent range, bedrooms, amenities, four sort orders |
| Map | `/listings/map` | Done, schematic map with markers and sub-city selector; "Near me" disabled |
| Listing Details | `/listings/:id` | Done, loads by ID, not-found state for unknown IDs; owner contact is a placeholder |
| Favourites | `/favorites` | Done, signed-in user's in-memory favourites |
| Add Listing | `/post` | Done, validated form saving in memory; photo is a placeholder reference |
| Edit Listing | `/listings/:id/edit` | Done, prefilled and validated; owner only |
| My Listings | `/profile/my-listings` | Done, owner's listings with availability updates |
| Viewing Requests | `/viewing-requests`, `/viewing-requests/:listingId` | Done, future-date validation, tenant cancel, owner accept/decline |
| Profile and Settings | `/profile`, `/profile/settings` | Done, profile edit, theme, language, notification preference (session only), sign out |
| Report Listing | `/report/:listingId` | Done, reasons, validation, duplicate report rejected |
| Moderation | `/moderation` | Done, admin only; resolve reports and hide listings |

Extra route: `/onboarding`.

**Structure and state.** Code follows `lib/core` and `lib/features/<feature>/{domain,data,presentation}`. State lives in Riverpod providers with freezed models (`UserProfile`, `Listing`, `ListingFilter`, `ViewingRequest`, `Favorite`, `Report`, `AppSettings`, `OnboardingState`). Each feature uses a repository interface with an in-memory implementation (authentication, listings, viewing requests, favourites, reports, profile, onboarding).

**Navigation and roles.** Role-based bottom navigation: tenant (Browse, Map, Favourites, Viewing requests, Profile and Settings), owner (My listings, Browse, Viewing requests, Profile and Settings), admin (Moderation, Browse, Profile and Settings). Route guards send signed-out users to Login and wrong-role users to their own home. Detail, edit and report routes show a not-found state for unknown IDs.

**Language and currency.** English and Amharic, switched from the shared language provider; rent is shown in Birr through one shared formatter.

**Demo accounts** (demo-only password `Demo1234`): `tenant@kiray.demo`, `owner@kiray.demo`, `admin@kiray.demo`.

## 2. What is not done

Planned for Milestone 2 and the final submission (see `PROPOSAL.md`):

- Firebase Authentication, Cloud Firestore and Firebase Storage
- REST API and area rental statistics (`AreaStat`)
- Drift (SQLite) and SharedPreferences, and offline access to saved listings
- Live GPS and OpenStreetMap maps ("Near me" is disabled)
- Camera and gallery photos (listings use placeholder photo references)
- AI house description generator (not implemented; descriptions are typed manually)

Current limitations: owner contact details are placeholders, and the notification setting is stored for the session only and sends no notifications.

## 3. Pull requests per member

| Member (GitHub) | Authored | Reviewed |
|---|---|---|
| Lelisa Tesfaye (1lelanta) | #1 Skeleton and core, #2 Router and shell, #17 Code structure refactor, #18 Route guards | #4, #8, #11, #13, #15 |
| Miruts Gebremeskel (miruts-code) | #3 Add listing foundation, #4 In-memory listing and viewing requests, #5 Add browse and details, #6 Listing management and requests | #1, #7, #9, #14, #16, #17 |
| Molalign Michael (Mohamiki) | #11 Profile, #12 Settings | #1, #2 |
| Natnael Girmay (nattygirmay-a11y) | #13 Favorite model, #14 Report flow, #15 Localization, #16 Flutter Material refactor | #2, #3, #5 |
| Lammi Abraham (kiyabr) | #7 User accounts and authentication, #8 Shared auth and language state, #9 Login and registration | #2, #6, #12, #18 |

## 4. Analyzer and test output

`flutter analyze --fatal-infos` on the tagged commit:

```text
No issues found! (ran in 3.9s)
```

`flutter test` on the tagged commit:

```text
00:30 +119: All tests passed!
```

## 5. Self-score against the marking list

| Item | Points | Self-score | Evidence |
|---|---|---|---|
| All proposed screens present and navigable | 3 | 3 | All 15 proposal screens exist and are reachable by role through go_router, with unknown-ID handling on parameter routes. |
| Feature-first structure; state in providers, not widgets | 2 | 2 | Code is organised as `lib/core` and `lib/features/<feature>/{domain,data,presentation}`, with freezed models, Riverpod providers and in-memory repositories behind interfaces. |
| Tests present; analyzer and tests clean | 1 | 1 | 119 tests pass and the analyzer reports no issues (output pasted above). |
| Repository hygiene | 1 | 1 | All merged work went through pull requests on feature branches, every merged PR has an approval from someone other than its author, and all five members authored and reviewed PRs. |
| Individual oral check | 3 | 3 | Every member reviewed PRs in features they did not author (2 to 6 reviews each), and the group will walk through the whole structure before the check. |

## 6. One thing we will change before Milestone 2

We will improve the overall UI design by replacing placeholder elements with meaningful, relevant widgets and making the interface more visually appealing and user-friendly.
