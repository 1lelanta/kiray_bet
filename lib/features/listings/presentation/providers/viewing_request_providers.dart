import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/viewing_request.dart';
import 'listing_data_providers.dart';

final tenantViewingRequestsProvider = FutureProvider<List<ViewingRequest>>((
  ref,
) {
  final id = ref.watch(currentTenantIdProvider);
  if (id == null) return Future.value(const <ViewingRequest>[]);
  return ref.watch(viewingRequestRepositoryProvider).listByTenant(id);
});

final ownerViewingRequestsProvider = FutureProvider<List<ViewingRequest>>((
  ref,
) {
  final id = ref.watch(currentOwnerIdProvider);
  if (id == null) return Future.value(const <ViewingRequest>[]);
  return ref.watch(viewingRequestRepositoryProvider).listByOwner(id);
});
