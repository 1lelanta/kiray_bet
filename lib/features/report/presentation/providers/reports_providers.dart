
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/authentication/presentation/providers/authentication_providers.dart';
import '../../data/in_memory_reports_repository.dart';
import '../../domain/report.dart';
import '../../domain/reports_repository.dart';

final reportsRepositoryProvider = Provider<ReportsRepository>(
  (ref) => InMemoryReportsRepository(),
);

final reportsProvider =
    NotifierProvider<ReportsNotifier, List<Report>>(
  ReportsNotifier.new,
);

class ReportsNotifier extends Notifier<List<Report>> {
  @override
  List<Report> build() {
    return ref.read(reportsRepositoryProvider).list();
  }

  void submit({
    required String listingId,
    required String reason,
  }) {
    final user = ref.read(currentUserProvider);

    if (user == null) {
      throw StateError('You must sign in before submitting a report.');
    }

    final report = Report(
      id: 'report-${DateTime.now().microsecondsSinceEpoch}',
      listingId: listingId,
      reporterId: user.id,
      reason: reason,
      createdAt: DateTime.now(),
      resolved: false,
    );

    final repository = ref.read(reportsRepositoryProvider);

    repository.submit(report);

    state = repository.list();
  }

  void resolve(String reportId) {
    final repository = ref.read(reportsRepositoryProvider);

    repository.resolve(reportId);

    state = repository.list();
  }

  void refresh() {
    state = ref.read(reportsRepositoryProvider).list();
  }
}
