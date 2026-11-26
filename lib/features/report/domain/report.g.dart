// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Report _$ReportFromJson(Map<String, dynamic> json) => _Report(
  id: json['id'] as String,
  listingId: json['listingId'] as String,
  reporterId: json['reporterId'] as String,
  reason: json['reason'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  resolved: json['resolved'] as bool,
);

Map<String, dynamic> _$ReportToJson(_Report instance) => <String, dynamic>{
  'id': instance.id,
  'listingId': instance.listingId,
  'reporterId': instance.reporterId,
  'reason': instance.reason,
  'createdAt': instance.createdAt.toIso8601String(),
  'resolved': instance.resolved,
};
