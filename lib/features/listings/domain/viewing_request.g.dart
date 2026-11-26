// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'viewing_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ViewingRequest _$ViewingRequestFromJson(Map<String, dynamic> json) =>
    _ViewingRequest(
      id: json['id'] as String,
      listingId: json['listingId'] as String,
      tenantId: json['tenantId'] as String,
      ownerId: json['ownerId'] as String,
      proposedDateTime: DateTime.parse(json['proposedDateTime'] as String),
      message: json['message'] as String?,
      status:
          $enumDecodeNullable(_$ViewingRequestStatusEnumMap, json['status']) ??
          ViewingRequestStatus.pending,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ViewingRequestToJson(_ViewingRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'listingId': instance.listingId,
      'tenantId': instance.tenantId,
      'ownerId': instance.ownerId,
      'proposedDateTime': instance.proposedDateTime.toIso8601String(),
      'message': instance.message,
      'status': _$ViewingRequestStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$ViewingRequestStatusEnumMap = {
  ViewingRequestStatus.pending: 'pending',
  ViewingRequestStatus.accepted: 'accepted',
  ViewingRequestStatus.declined: 'declined',
  ViewingRequestStatus.cancelled: 'cancelled',
};
