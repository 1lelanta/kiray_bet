import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/features/listings/data/in_memory_viewing_request_repository.dart';
import 'package:kiray_bet/features/listings/domain/viewing_request.dart';

void main() {
  test(
    'validates future requests and supports tenant and owner status actions',
    () async {
      final repository = InMemoryViewingRequestRepository(requests: []);
      final now = DateTime.now();
      final request = ViewingRequest(
        id: 'request-1',
        listingId: 'listing-1',
        tenantId: 'tenant-1',
        ownerId: 'owner-1',
        proposedDateTime: now.add(const Duration(days: 1)),
        createdAt: now,
      );

      await expectLater(
        repository.create(
          request.copyWith(
            proposedDateTime: now.subtract(const Duration(days: 1)),
          ),
        ),
        throwsArgumentError,
      );

      await repository.create(request);
      expect(await repository.listByTenant('tenant-1'), [request]);
      expect(await repository.listByOwner('owner-1'), [request]);

      final accepted = await repository.updateStatus(
        request.id,
        ViewingRequestStatus.accepted,
      );
      expect(accepted.status, ViewingRequestStatus.accepted);
      final cancelled = await repository.updateStatus(
        request.id,
        ViewingRequestStatus.cancelled,
      );
      expect(cancelled.status, ViewingRequestStatus.cancelled);
      await expectLater(
        repository.updateStatus('unknown', ViewingRequestStatus.declined),
        throwsStateError,
      );
    },
  );
}
