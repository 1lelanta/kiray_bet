// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Listing _$ListingFromJson(Map<String, dynamic> json) => _Listing(
  id: json['id'] as String,
  ownerId: json['ownerId'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  monthlyRentBirr: (json['monthlyRentBirr'] as num).toInt(),
  depositMonths: (json['depositMonths'] as num).toInt(),
  bedrooms: (json['bedrooms'] as num).toInt(),
  bathrooms: (json['bathrooms'] as num).toInt(),
  areaSqm: (json['areaSqm'] as num).toDouble(),
  subCity: json['subCity'] as String,
  neighbourhood: json['neighbourhood'] as String,
  address: json['address'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  amenities:
      (json['amenities'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  photoUrls:
      (json['photoUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  status:
      $enumDecodeNullable(_$ListingStatusEnumMap, json['status']) ??
      ListingStatus.available,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ListingToJson(_Listing instance) => <String, dynamic>{
  'id': instance.id,
  'ownerId': instance.ownerId,
  'title': instance.title,
  'description': instance.description,
  'monthlyRentBirr': instance.monthlyRentBirr,
  'depositMonths': instance.depositMonths,
  'bedrooms': instance.bedrooms,
  'bathrooms': instance.bathrooms,
  'areaSqm': instance.areaSqm,
  'subCity': instance.subCity,
  'neighbourhood': instance.neighbourhood,
  'address': instance.address,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'amenities': instance.amenities,
  'photoUrls': instance.photoUrls,
  'status': _$ListingStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$ListingStatusEnumMap = {
  ListingStatus.available: 'available',
  ListingStatus.rented: 'rented',
  ListingStatus.hidden: 'hidden',
};
