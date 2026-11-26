import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/in_memory_listing_repository.dart';
import '../../data/in_memory_viewing_request_repository.dart';
import '../../domain/listing_repository.dart';
import '../../domain/viewing_request_repository.dart';

final listingRepositoryProvider = Provider<ListingRepository>(
  (ref) => InMemoryListingRepository(),
);

final viewingRequestRepositoryProvider = Provider<ViewingRequestRepository>(
  (ref) => InMemoryViewingRequestRepository(),
);

/// Defaults are demo adapters; the authentication layer can rewire these to the signed-in user.
final currentOwnerIdProvider = Provider<String?>((ref) => 'demo-owner-1');
final currentTenantIdProvider = Provider<String?>((ref) => 'demo-tenant-1');
