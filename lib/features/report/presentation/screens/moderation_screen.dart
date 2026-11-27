import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kiray_bet/core/widgets/app_scaffold.dart';
import 'package:kiray_bet/core/widgets/empty_state.dart';
import 'package:kiray_bet/features/authentication/domain/user_profile.dart';
import 'package:kiray_bet/features/authentication/presentation/providers/authentication_providers.dart';
import 'package:kiray_bet/features/listings/domain/listing.dart';
import 'package:kiray_bet/features/listings/presentation/providers/listing_data_providers.dart';
import 'package:kiray_bet/features/listings/presentation/providers/listing_providers.dart';
import 'package:kiray_bet/features/report/domain/report.dart';
import 'package:kiray_bet/features/report/presentation/moderation_strings.dart';
import 'package:kiray_bet/features/report/presentation/providers/reports_providers.dart';

class ModerationScreen extends ConsumerStatefulWidget {
  const ModerationScreen({super.key});

  @override
  ConsumerState<ModerationScreen> createState() =>
      _ModerationScreenState();
}

class _ModerationScreenState
    extends ConsumerState<ModerationScreen> {
  bool _showResolved = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    if (user == null || user.role != UserRole.admin) {
      return const AppScaffold(
        title: ModerationStrings.title,
        body: EmptyState(
          icon: Icons.lock_outline,
          title: ModerationStrings.accessDenied,
        ),
      );
    }

    final reports = ref.watch(reportsProvider);

    final filteredReports = reports
        .where((report) => report.resolved == _showResolved)
        .toList();

    return AppScaffold(
      title: ModerationStrings.title,
      body: Column(
        children: [
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment<bool>(
                value: false,
                label: Text(ModerationStrings.open),
              ),
              ButtonSegment<bool>(
                value: true,
                label: Text(ModerationStrings.resolved),
              ),
            ],
            selected: {_showResolved},
            onSelectionChanged: (selection) {
              setState(() {
                _showResolved = selection.first;
              });
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filteredReports.isEmpty
                ? EmptyState(
                    icon: Icons.inbox_outlined,
                    title: _showResolved
                        ? ModerationStrings.noResolvedReports
                        : ModerationStrings.noOpenReports,
                  )
                : ListView.separated(
                    itemCount: filteredReports.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return ReportCard(
                        report: filteredReports[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ReportCard extends ConsumerWidget {
  const ReportCard({
    super.key,
    required this.report,
  });

  final Report report;

  Future<void> _hideListing(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      await ref
          .read(listingRepositoryProvider)
          .updateListingStatus(
            report.listingId,
            ListingStatus.hidden,
          );

      ref.read(reportsProvider.notifier).resolve(report.id);

      // Refresh listing data so hidden listings disappear from Browse.
      ref.invalidate(allListingsProvider);
      ref.invalidate(listingByIdProvider(report.listingId));

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(ModerationStrings.hideSuccess),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(ModerationStrings.actionError),
        ),
      );
    }
  }

  void _resolveWithoutHiding(
    BuildContext context,
    WidgetRef ref,
  ) {
    try {
      ref.read(reportsProvider.notifier).resolve(report.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(ModerationStrings.resolveSuccess),
        ),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(ModerationStrings.actionError),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listing = ref.watch(
      listingByIdProvider(report.listingId),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: listing.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (_, _) => const Text(
            ModerationStrings.listingNotFound,
          ),
          data: (item) {
            if (item == null) {
              return const Text(
                ModerationStrings.listingNotFound,
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text('Listing ID: ${report.listingId}'),
                Text('Reporter ID: ${report.reporterId}'),
                Text('Reason: ${report.reason}'),
                Text(
                  'Submitted: ${report.createdAt.toLocal()}',
                ),
                Text(
                  report.resolved
                      ? ModerationStrings.resolved
                      : ModerationStrings.open,
                ),
                if (!report.resolved) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _hideListing(
                          context,
                          ref,
                        ),
                        icon: const Icon(Icons.visibility_off),
                        label: const Text(
                          ModerationStrings.hideListing,
                        ),
                      ),
                      TextButton(
                        onPressed: () => _resolveWithoutHiding(
                          context,
                          ref,
                        ),
                        child: const Text(
                          ModerationStrings.resolveWithoutHiding,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
