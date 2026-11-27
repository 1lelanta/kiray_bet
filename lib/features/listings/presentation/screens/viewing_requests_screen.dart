import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../domain/listing.dart';
import '../../domain/viewing_request.dart';
import '../listing_strings.dart';
import '../providers/listing_data_providers.dart';
import '../providers/listing_providers.dart';
import '../providers/viewing_request_providers.dart';

class ViewingRequestsScreen extends ConsumerWidget {
  ViewingRequestsScreen({super.key, this.listingId});
  final String? listingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenant = ref.watch(tenantViewingRequestsProvider);
    final owner = ref.watch(ownerViewingRequestsProvider);
    return AppScaffold(
      title: ListingStrings.viewingRequests,
      floatingActionButton: listingId == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _create(context, ref),
              icon: Icon(Icons.event_available),
              label: Text(ListingStrings.requestViewing),
            ),
      body: ListView(
        children: [
          tenant.when(
            data: (items) => items.isEmpty
                ? const SizedBox.shrink()
                : _section(
                    ListingStrings.myRequests,
                    items,
                    (item) => item.status == ViewingRequestStatus.pending
                        ? TextButton(
                            onPressed: () => _update(
                              ref,
                              item,
                              ViewingRequestStatus.cancelled,
                            ),
                            child: Text(ListingStrings.cancel),
                          )
                        : Text(item.status.name),
                  ),
            loading: () => LinearProgressIndicator(),
            error: (e, s) => Text(ListingStrings.error),
          ),
          owner.when(
            data: (items) => items.isEmpty
                ? const SizedBox.shrink()
                : _section(
                    ListingStrings.requestsForMyListings,
                    items,
                    (item) => item.status == ViewingRequestStatus.pending
                        ? Wrap(
                            children: [
                              TextButton(
                                onPressed: () => _update(
                                  ref,
                                  item,
                                  ViewingRequestStatus.accepted,
                                ),
                                child: Text(ListingStrings.accept),
                              ),
                              TextButton(
                                onPressed: () => _update(
                                  ref,
                                  item,
                                  ViewingRequestStatus.declined,
                                ),
                                child: Text(ListingStrings.decline),
                              ),
                            ],
                          )
                        : Text(item.status.name),
                  ),
            loading: () => LinearProgressIndicator(),
            error: (e, s) => Text(ListingStrings.error),
          ),
        ],
      ),
    );
  }

  Widget _section(
    String title,
    List<ViewingRequest> items,
    Widget Function(ViewingRequest) action,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(12),
        child: Text(title, style: TextStyle(fontSize: 18)),
      ),
      ...items.map(
        (item) => Card(
          child: ListTile(
            title: Text('${item.listingId} · ${item.proposedDateTime}'),
            subtitle: Text(item.message ?? item.status.name),
            trailing: action(item),
          ),
        ),
      ),
    ],
  );

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final tenantId = ref.read(currentTenantIdProvider);
    final listing = await ref.read(listingByIdProvider(listingId!).future);
    if (!context.mounted) return;
    if (tenantId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ListingStrings.signInRequired)),
      );
      return;
    }
    if (listing == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(ListingStrings.notFound)));
      return;
    }
    if (listing.status != ListingStatus.available ||
        listing.ownerId == tenantId ||
        listing.ownerId == ref.read(currentOwnerIdProvider)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ListingStrings.requestUnavailable)),
      );
      return;
    }
    final day = await showDatePicker(
      context: context,
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 365)),
      initialDate: DateTime.now().add(Duration(days: 1)),
    );
    if (day == null || !context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 10, minute: 0),
    );
    if (time == null || !context.mounted) return;
    final proposed = DateTime(
      day.year,
      day.month,
      day.day,
      time.hour,
      time.minute,
    );
    if (!proposed.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ListingStrings.futureDateRequired)),
      );
      return;
    }
    final messageController = TextEditingController();
    final message = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(ListingStrings.optionalMessage),
        content: TextField(
          controller: messageController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: ListingStrings.messageHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, ''),
            child: Text(ListingStrings.skip),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, messageController.text.trim()),
            child: Text(ListingStrings.continueLabel),
          ),
        ],
      ),
    );
    messageController.dispose();
    if (message == null || !context.mounted) return;
    final request = ViewingRequest(
      id: 'viewing-${DateTime.now().microsecondsSinceEpoch}',
      listingId: listing.id,
      tenantId: tenantId,
      ownerId: listing.ownerId,
      proposedDateTime: proposed,
      message: message.isEmpty ? null : message,
      createdAt: DateTime.now(),
    );
    await ref.read(viewingRequestRepositoryProvider).create(request);
    ref.invalidate(tenantViewingRequestsProvider);
    ref.invalidate(ownerViewingRequestsProvider);
  }

  Future<void> _update(
    WidgetRef ref,
    ViewingRequest request,
    ViewingRequestStatus status,
  ) async {
    await ref
        .read(viewingRequestRepositoryProvider)
        .updateStatus(request.id, status);
    ref.invalidate(tenantViewingRequestsProvider);
    ref.invalidate(ownerViewingRequestsProvider);
  }
}
