import 'package:freezed_annotation/freezed_annotation.dart';

part 'viewing_request.freezed.dart';
part 'viewing_request.g.dart';

enum ViewingRequestStatus { pending, accepted, declined, cancelled }

@freezed
abstract class ViewingRequest with _$ViewingRequest {
  const factory ViewingRequest({
    required String id,
    required String listingId,
    required String tenantId,
    required String ownerId,
    required DateTime proposedDateTime,
    String? message,
    @Default(ViewingRequestStatus.pending) ViewingRequestStatus status,
    required DateTime createdAt,
  }) = _ViewingRequest;

  factory ViewingRequest.fromJson(Map<String, dynamic> json) =>
      _$ViewingRequestFromJson(json);
}
