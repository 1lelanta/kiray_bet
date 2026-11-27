import '../domain/report.dart';
import '../domain/reports_repository.dart';

class InMemoryReportsRepository implements ReportsRepository {
  InMemoryReportsRepository({List<Report>? initialReports})
      : _reports = [...?initialReports];

  final List<Report> _reports;

  @override
  void submit(Report report) {
    // Prevent duplicate report IDs.
    if (_reports.any((item) => item.id == report.id)) {
      throw StateError(
        'A report with ID ${report.id} already exists.',
      );
    }

    // A user cannot submit another unresolved report
    // for the same listing.
    final alreadyReported = _reports.any(
      (item) =>
          item.listingId == report.listingId &&
          item.reporterId == report.reporterId &&
          !item.resolved,
    );

    if (alreadyReported) {
      throw StateError(
        'You have already reported this listing.',
      );
    }

    _reports.add(report);
  }

  @override
  List<Report> list() {
    return List.unmodifiable(_reports);
  }

  @override
  void resolve(String reportId) {
    final index = _reports.indexWhere(
      (report) => report.id == reportId,
    );

    if (index == -1) {
      throw StateError('Report $reportId was not found.');
    }

    _reports[index] = _reports[index].copyWith(
      resolved: true,
    );
  }
}
