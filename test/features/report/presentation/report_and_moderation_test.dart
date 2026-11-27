
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kiray_bet/features/authentication/presentation/providers/authentication_providers.dart';
import 'package:kiray_bet/features/listings/data/in_memory_listing_repository.dart';
import 'package:kiray_bet/features/listings/domain/listing.dart';
import 'package:kiray_bet/features/listings/presentation/providers/listing_data_providers.dart';
import 'package:kiray_bet/features/report/data/in_memory_reports_repository.dart';
import 'package:kiray_bet/features/report/domain/report.dart';
import 'package:kiray_bet/features/report/presentation/moderation_strings.dart';
import 'package:kiray_bet/features/report/presentation/providers/reports_providers.dart';
import 'package:kiray_bet/features/report/presentation/report_strings.dart';
import 'package:kiray_bet/features/report/presentation/screens/moderation_screen.dart';
import 'package:kiray_bet/features/report/presentation/screens/report_scam_screen.dart';

Listing createListing() {
  final now = DateTime(2026, 11, 26);

  return Listing(
    id: 'listing-1',
    ownerId: 'owner-1',
    title: 'Test apartment',
    description: 'Test description',
    monthlyRentBirr: 20000,
    depositMonths: 2,
    bedrooms: 2,
    bathrooms: 1,
    areaSqm: 80,
    subCity: 'Bole',
    neighbourhood: 'Bole Atlas',
    address: 'Test address',
    latitude: 8.995,
    longitude: 38.789,
    amenities: const [],
    photoUrls: const [],
    status: ListingStatus.available,
    createdAt: now,
    updatedAt: now,
  );
}

Report createReport() {
  return Report(
    id: 'report-1',
    listingId: 'listing-1',
    reporterId: 'user-1',
    reason: 'Fake listing',
    createdAt: DateTime(2026, 11, 26),
    resolved: false,
  );
}

void main() {
  testWidgets('non-admin users cannot access moderation', (tester) async {
    final container = ProviderContainer();

    addTearDown(container.dispose);

    await container.read(currentUserProvider.notifier).signIn(
          email: 'tenant@kiray.demo',
          password: 'Demo1234',
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child:  MaterialApp(
          home: ModerationScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text(ModerationStrings.accessDenied), findsOneWidget);
  });

  testWidgets('admin can hide a listing and resolve its report',
      (tester) async {
    final listingRepository = InMemoryListingRepository(
      initialListings: [createListing()],
    );

    final reportsRepository = InMemoryReportsRepository(
      initialReports: [createReport()],
    );

    final container = ProviderContainer(
      overrides: [
        listingRepositoryProvider.overrideWith(
          (ref) => listingRepository,
        ),
        reportsRepositoryProvider.overrideWith(
          (ref) => reportsRepository,
        ),
      ],
    );

    addTearDown(container.dispose);

    await container.read(currentUserProvider.notifier).signIn(
          email: 'admin@kiray.demo',
          password: 'Demo1234',
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child:  MaterialApp(
          home: ModerationScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Test apartment'), findsOneWidget);

    await tester.ensureVisible(
      find.text(ModerationStrings.hideListing),
    );
    await tester.tap(find.text(ModerationStrings.hideListing));
    await tester.pumpAndSettle();

    final updatedListing =
        await listingRepository.getListingById('listing-1');

    expect(updatedListing?.status, ListingStatus.hidden);
    expect(reportsRepository.list().single.resolved, isTrue);
  });

  
testWidgets('Other requires details before report submission',
    (tester) async {
  final listingRepository = InMemoryListingRepository(
    initialListings: [createListing()],
  );

  final reportsRepository = InMemoryReportsRepository();

  final container = ProviderContainer(
    overrides: [
      listingRepositoryProvider.overrideWith(
        (ref) => listingRepository,
      ),
      reportsRepositoryProvider.overrideWith(
        (ref) => reportsRepository,
      ),
    ],
  );

  addTearDown(container.dispose);

  await container.read(currentUserProvider.notifier).signIn(
        email: 'tenant@kiray.demo',
        password: 'Demo1234',
      );

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child:  MaterialApp(
        home: ReportScamScreen(listingId: 'listing-1'),
      ),
    ),
  );

  await tester.pumpAndSettle();

  expect(find.text('Listing: Test apartment'), findsOneWidget);
  expect(find.text(ReportStrings.chooseReason), findsOneWidget);
  expect(find.text(ReportStrings.other), findsOneWidget);

  await tester.tap(find.text(ReportStrings.other));
  await tester.pumpAndSettle();

  expect(find.byType(TextFormField), findsOneWidget);

  await tester.scrollUntilVisible(
    find.text(ReportStrings.submit),
    300,
    scrollable: find.byType(Scrollable).first,
  );

  final submitButton = find.byType(ElevatedButton);

  expect(submitButton, findsOneWidget);

  await tester.tap(submitButton);
  await tester.pumpAndSettle();

  expect(find.text(ReportStrings.otherRequired), findsOneWidget);
  expect(reportsRepository.list(), isEmpty);

  await tester.enterText(
    find.byType(TextFormField),
    'The photos do not match the property.',
  );

  await tester.scrollUntilVisible(
    find.text(ReportStrings.submit),
    300,
    scrollable: find.byType(Scrollable).first,
  );

  await tester.tap(submitButton);
  await tester.pumpAndSettle();

  expect(find.text(ReportStrings.success), findsOneWidget);
  expect(reportsRepository.list(), hasLength(1));
  expect(
    reportsRepository.list().single.reason,
    contains('The photos do not match the property.'),
  );
});
}
