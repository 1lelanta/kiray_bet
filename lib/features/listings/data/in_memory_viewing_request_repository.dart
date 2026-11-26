import '../domain/viewing_request.dart';
import '../domain/viewing_request_repository.dart';

import 'package:kiray_bet/core/constants/demo_ids.dart';

class InMemoryViewingRequestRepository implements ViewingRequestRepository {
  InMemoryViewingRequestRepository({List<ViewingRequest>? requests})
    : _requests = [...(requests ?? _demoRequests)];

  final List<ViewingRequest> _requests;

  @override
  Future<ViewingRequest> create(ViewingRequest request) async {
    if (!request.proposedDateTime.isAfter(DateTime.now())) {
      throw ArgumentError('The proposed viewing time must be in the future.');
    }
    if (_requests.any((item) => item.id == request.id)) {
      throw StateError('A request with ID ${request.id} already exists.');
    }
    _requests.add(request);
    return request;
  }

  @override
  Future<List<ViewingRequest>> listByTenant(String tenantId) async =>
      List.unmodifiable(_requests.where((item) => item.tenantId == tenantId));

  @override
  Future<List<ViewingRequest>> listByOwner(String ownerId) async =>
      List.unmodifiable(_requests.where((item) => item.ownerId == ownerId));

  @override
  Future<ViewingRequest> updateStatus(
    String requestId,
    ViewingRequestStatus status,
  ) async {
    final index = _requests.indexWhere((item) => item.id == requestId);
    if (index < 0) throw StateError('Request $requestId was not found.');
    final updated = _requests[index].copyWith(status: status);
    _requests[index] = updated;
    return updated;
  }
}

final _demoRequests = <ViewingRequest>[
  ViewingRequest(
    id: 'viewing-demo-1',
    listingId: 'bole-01',
    tenantId: DemoIds.tenant,
    ownerId: DemoIds.owner,
    proposedDateTime: DateTime.now().add(const Duration(days: 2)),
    message: 'Would Saturday morning work?',
    createdAt: DateTime.now(),
  ),
  ViewingRequest(
    id: 'viewing-demo-2',
    listingId: 'kirkos-01',
    tenantId: DemoIds.tenant,
    ownerId: DemoIds.owner,
    proposedDateTime: DateTime.now().add(const Duration(days: 4)),
    createdAt: DateTime.now(),
  ),
];
