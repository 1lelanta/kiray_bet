import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kiray_bet/core/widgets/app_scaffold.dart';
import 'package:kiray_bet/core/widgets/empty_state.dart';
import 'package:kiray_bet/features/authentication/presentation/providers/authentication_providers.dart';
import 'package:kiray_bet/features/listings/presentation/providers/listing_providers.dart';
import 'package:kiray_bet/features/report/presentation/providers/reports_providers.dart';
import 'package:kiray_bet/features/report/presentation/report_strings.dart';

class ReportScamScreen extends ConsumerStatefulWidget {
  const ReportScamScreen({super.key, required this.listingId});

  final String listingId;

  @override
  ConsumerState<ReportScamScreen> createState() => _ReportScamScreenState();
}

class _ReportScamScreenState extends ConsumerState<ReportScamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _detailsController = TextEditingController();

  String? _selectedReason;
  bool _isSubmitting = false;
  bool _submitted = false;

  final List<String> _reasons = [
    ReportStrings.fakeListing,
    ReportStrings.alreadyRented,
    ReportStrings.duplicate,
    ReportStrings.wrongInformation,
    ReportStrings.inappropriate,
    ReportStrings.other,
  ];

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (_selectedReason == null) {
      setState(() {});
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(ReportStrings.reasonRequired)));
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      var reason = _selectedReason!;

      if (_selectedReason == ReportStrings.other) {
        reason = '$reason: ${_detailsController.text.trim()}';
      }

      ref
          .read(reportsProvider.notifier)
          .submit(listingId: widget.listingId, reason: reason);

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
        _submitted = true;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() => _isSubmitting = false);

      final message = error is StateError
          ? error.message.toString()
          : ReportStrings.error;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final listing = ref.watch(listingByIdProvider(widget.listingId));

    if (user == null) {
      return AppScaffold(
        title: ReportStrings.title,
        body: EmptyState(
          icon: Icons.login,
          title: ReportStrings.signInRequired,
        ),
      );
    }

    return AppScaffold(
      title: ReportStrings.title,
      body: listing.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(ReportStrings.listingNotFound)),
        data: (item) {
          if (item == null) {
            return Center(child: Text(ReportStrings.listingNotFound));
          }

          if (_submitted) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 56,
                    color: Colors.green,
                  ),
                  SizedBox(height: 16),
                  Text(ReportStrings.success, textAlign: TextAlign.center),
                ],
              ),
            );
          }

          return Form(
            key: _formKey,
            child: ListView(
              children: [
                Text(
                  '${ReportStrings.listingLabel}: ${item.title}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 20),
                Text(
                  ReportStrings.chooseReason,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8),

                RadioGroup<String>(
                  groupValue: _selectedReason,
                  onChanged: (value) {
                    if (_isSubmitting) return;
                    setState(() {
                      _selectedReason = value;
                    });
                  },
                  child: Column(
                    children: [
                      ..._reasons.map(
                        (reason) => RadioListTile<String>(
                          title: Text(reason),
                          value: reason,
                          enabled: !_isSubmitting,
                        ),
                      ),
                    ],
                  ),
                ),

                if (_selectedReason == ReportStrings.other) ...[
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _detailsController,
                    enabled: !_isSubmitting,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: ReportStrings.otherDetails,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (_selectedReason == ReportStrings.other &&
                          (value == null || value.trim().isEmpty)) {
                        return ReportStrings.otherRequired;
                      }

                      return null;
                    },
                  ),
                ],

                SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReport,
                  child: Text(
                    _isSubmitting
                        ? ReportStrings.submitting
                        : ReportStrings.submit,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
