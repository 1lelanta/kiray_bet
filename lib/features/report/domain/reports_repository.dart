import 'report.dart';

abstract interface class ReportsRepository {
  void submit(Report report);

  List<Report> list();

  void resolve(String reportId);
}
