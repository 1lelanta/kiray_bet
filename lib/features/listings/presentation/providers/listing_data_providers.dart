import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../authentication/domain/user_profile.dart';
import '../../../authentication/presentation/providers/authentication_providers.dart';
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

/// Listing workflows use the ID from the shared signed-in user state.
final currentOwnerIdProvider = Provider<String?>(
  (ref) => ref.watch(currentUserProvider)?.role == UserRole.owner
      ? ref.watch(currentUserProvider)?.id
      : null,
);

final currentTenantIdProvider = Provider<String?>(
  (ref) => ref.watch(currentUserProvider)?.role == UserRole.tenant
      ? ref.watch(currentUserProvider)?.id
      : null,
);
