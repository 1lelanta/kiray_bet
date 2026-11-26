import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/features/report/data/in_memory_reports_repository.dart';
import 'package:kiray_bet/features/report/domain/report.dart';

void main() {
  late InMemoryReportsRepository repository;

  Report createReport({
    String id = 'report-1',
    String listingId = 'listing-1',
    String reporterId = 'user-1',
    bool resolved = false,
  }) {
    return Report(
      id: id,
      listingId: listingId,
      reporterId: reporterId,
      reason: 'Fake listing',
      createdAt: DateTime(2026, 11, 26),
      resolved: resolved,
    );
  }

  setUp(() {
    repository = InMemoryReportsRepository();
  });

  test('submits and lists a report', () {
    final report = createReport();

    repository.submit(report);

    expect(repository.list(), [report]);
  });

  test('rejects duplicate unresolved reports from the same user', () {
    repository.submit(createReport());

    expect(
      () => repository.submit(
        createReport(id: 'report-2'),
      ),
      throwsA(isA<StateError>()),
    );
  });

  test('allows different users to report the same listing', () {
    repository.submit(createReport());

    repository.submit(
      createReport(
        id: 'report-2',
        reporterId: 'user-2',
      ),
    );

    expect(repository.list(), hasLength(2));
  });

  test('allows the same user to report again after resolution', () {
    repository.submit(createReport());

    repository.resolve('report-1');

    repository.submit(
      createReport(id: 'report-2'),
    );

    expect(repository.list(), hasLength(2));
    expect(repository.list().last.resolved, false);
  });

  test('resolves a report', () {
    repository.submit(createReport());

    repository.resolve('report-1');

    expect(repository.list().single.resolved, true);
  });

  test('throws when resolving an unknown report', () {
    expect(
      () => repository.resolve('missing-report'),
      throwsA(isA<StateError>()),
    );
  });

  test('rejects duplicate report IDs', () {
    repository.submit(createReport());

    expect(
      () => repository.submit(
        createReport(
          listingId: 'listing-2',
        ),
      ),
      throwsA(isA<StateError>()),
    );
  });
}
