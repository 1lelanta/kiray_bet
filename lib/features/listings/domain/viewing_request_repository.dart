import 'viewing_request.dart';

abstract interface class ViewingRequestRepository {
  Future<ViewingRequest> create(ViewingRequest request);
  Future<List<ViewingRequest>> listByTenant(String tenantId);
  Future<List<ViewingRequest>> listByOwner(String ownerId);
  Future<ViewingRequest> updateStatus(
    String requestId,
    ViewingRequestStatus status,
  );
}
