// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Listing {

 String get id; String get ownerId; String get title; String get description; int get monthlyRentBirr; int get depositMonths; int get bedrooms; int get bathrooms; double get areaSqm; String get subCity; String get neighbourhood; String get address; double get latitude; double get longitude; List<String> get amenities; List<String> get photoUrls; ListingStatus get status; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Listing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListingCopyWith<Listing> get copyWith => _$ListingCopyWithImpl<Listing>(this as Listing, _$identity);

  /// Serializes this Listing to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Listing;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Listing&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.ownerId, _this.ownerId) || other.ownerId == _this.ownerId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.monthlyRentBirr, _this.monthlyRentBirr) || other.monthlyRentBirr == _this.monthlyRentBirr)&&(identical(other.depositMonths, _this.depositMonths) || other.depositMonths == _this.depositMonths)&&(identical(other.bedrooms, _this.bedrooms) || other.bedrooms == _this.bedrooms)&&(identical(other.bathrooms, _this.bathrooms) || other.bathrooms == _this.bathrooms)&&(identical(other.areaSqm, _this.areaSqm) || other.areaSqm == _this.areaSqm)&&(identical(other.subCity, _this.subCity) || other.subCity == _this.subCity)&&(identical(other.neighbourhood, _this.neighbourhood) || other.neighbourhood == _this.neighbourhood)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&const DeepCollectionEquality().equals(other.amenities, _this.amenities)&&const DeepCollectionEquality().equals(other.photoUrls, _this.photoUrls)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Listing;
  return Object.hashAll([runtimeType,_this.id,_this.ownerId,_this.title,_this.description,_this.monthlyRentBirr,_this.depositMonths,_this.bedrooms,_this.bathrooms,_this.areaSqm,_this.subCity,_this.neighbourhood,_this.address,_this.latitude,_this.longitude,const DeepCollectionEquality().hash(_this.amenities),const DeepCollectionEquality().hash(_this.photoUrls),_this.status,_this.createdAt,_this.updatedAt]);
}

@override
String toString() {
  final _this = this as Listing;
  return 'Listing(id: ${_this.id}, ownerId: ${_this.ownerId}, title: ${_this.title}, description: ${_this.description}, monthlyRentBirr: ${_this.monthlyRentBirr}, depositMonths: ${_this.depositMonths}, bedrooms: ${_this.bedrooms}, bathrooms: ${_this.bathrooms}, areaSqm: ${_this.areaSqm}, subCity: ${_this.subCity}, neighbourhood: ${_this.neighbourhood}, address: ${_this.address}, latitude: ${_this.latitude}, longitude: ${_this.longitude}, amenities: ${_this.amenities}, photoUrls: ${_this.photoUrls}, status: ${_this.status}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $ListingCopyWith<$Res>  {
  factory $ListingCopyWith(Listing value, $Res Function(Listing) _then) = _$ListingCopyWithImpl;
@useResult
$Res call({
 String id, String ownerId, String title, String description, int monthlyRentBirr, int depositMonths, int bedrooms, int bathrooms, double areaSqm, String subCity, String neighbourhood, String address, double latitude, double longitude, List<String> amenities, List<String> photoUrls, ListingStatus status, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ListingCopyWithImpl<$Res>
    implements $ListingCopyWith<$Res> {
  _$ListingCopyWithImpl(this._self, this._then);

  final Listing _self;
  final $Res Function(Listing) _then;

/// Create a copy of Listing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerId = null,Object? title = null,Object? description = null,Object? monthlyRentBirr = null,Object? depositMonths = null,Object? bedrooms = null,Object? bathrooms = null,Object? areaSqm = null,Object? subCity = null,Object? neighbourhood = null,Object? address = null,Object? latitude = null,Object? longitude = null,Object? amenities = null,Object? photoUrls = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(Listing(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,monthlyRentBirr: null == monthlyRentBirr ? _self.monthlyRentBirr : monthlyRentBirr // ignore: cast_nullable_to_non_nullable
as int,depositMonths: null == depositMonths ? _self.depositMonths : depositMonths // ignore: cast_nullable_to_non_nullable
as int,bedrooms: null == bedrooms ? _self.bedrooms : bedrooms // ignore: cast_nullable_to_non_nullable
as int,bathrooms: null == bathrooms ? _self.bathrooms : bathrooms // ignore: cast_nullable_to_non_nullable
as int,areaSqm: null == areaSqm ? _self.areaSqm : areaSqm // ignore: cast_nullable_to_non_nullable
as double,subCity: null == subCity ? _self.subCity : subCity // ignore: cast_nullable_to_non_nullable
as String,neighbourhood: null == neighbourhood ? _self.neighbourhood : neighbourhood // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,amenities: null == amenities ? _self.amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>,photoUrls: null == photoUrls ? _self.photoUrls : photoUrls // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ListingStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Listing].
extension ListingPatterns on Listing {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Listing value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Listing() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Listing value)  $default,){
final _that = this;
switch (_that) {
case _Listing():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Listing value)?  $default,){
final _that = this;
switch (_that) {
case _Listing() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerId,  String title,  String description,  int monthlyRentBirr,  int depositMonths,  int bedrooms,  int bathrooms,  double areaSqm,  String subCity,  String neighbourhood,  String address,  double latitude,  double longitude,  List<String> amenities,  List<String> photoUrls,  ListingStatus status,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Listing() when $default != null:
return $default(_that.id,_that.ownerId,_that.title,_that.description,_that.monthlyRentBirr,_that.depositMonths,_that.bedrooms,_that.bathrooms,_that.areaSqm,_that.subCity,_that.neighbourhood,_that.address,_that.latitude,_that.longitude,_that.amenities,_that.photoUrls,_that.status,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerId,  String title,  String description,  int monthlyRentBirr,  int depositMonths,  int bedrooms,  int bathrooms,  double areaSqm,  String subCity,  String neighbourhood,  String address,  double latitude,  double longitude,  List<String> amenities,  List<String> photoUrls,  ListingStatus status,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Listing():
return $default(_that.id,_that.ownerId,_that.title,_that.description,_that.monthlyRentBirr,_that.depositMonths,_that.bedrooms,_that.bathrooms,_that.areaSqm,_that.subCity,_that.neighbourhood,_that.address,_that.latitude,_that.longitude,_that.amenities,_that.photoUrls,_that.status,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerId,  String title,  String description,  int monthlyRentBirr,  int depositMonths,  int bedrooms,  int bathrooms,  double areaSqm,  String subCity,  String neighbourhood,  String address,  double latitude,  double longitude,  List<String> amenities,  List<String> photoUrls,  ListingStatus status,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Listing() when $default != null:
return $default(_that.id,_that.ownerId,_that.title,_that.description,_that.monthlyRentBirr,_that.depositMonths,_that.bedrooms,_that.bathrooms,_that.areaSqm,_that.subCity,_that.neighbourhood,_that.address,_that.latitude,_that.longitude,_that.amenities,_that.photoUrls,_that.status,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Listing implements Listing {
  const _Listing({required this.id, required this.ownerId, required this.title, required this.description, required this.monthlyRentBirr, required this.depositMonths, required this.bedrooms, required this.bathrooms, required this.areaSqm, required this.subCity, required this.neighbourhood, required this.address, required this.latitude, required this.longitude,  List<String> amenities = const <String>[],  List<String> photoUrls = const <String>[], this.status = ListingStatus.available, required this.createdAt, required this.updatedAt}): _amenities = amenities,_photoUrls = photoUrls;
  factory _Listing.fromJson(Map<String, dynamic> json) => _$ListingFromJson(json);

@override final  String id;
@override final  String ownerId;
@override final  String title;
@override final  String description;
@override final  int monthlyRentBirr;
@override final  int depositMonths;
@override final  int bedrooms;
@override final  int bathrooms;
@override final  double areaSqm;
@override final  String subCity;
@override final  String neighbourhood;
@override final  String address;
@override final  double latitude;
@override final  double longitude;
 final  List<String> _amenities;
@override@JsonKey() List<String> get amenities {
  if (_amenities is EqualUnmodifiableListView) return _amenities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_amenities);
}

 final  List<String> _photoUrls;
@override@JsonKey() List<String> get photoUrls {
  if (_photoUrls is EqualUnmodifiableListView) return _photoUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photoUrls);
}

@override@JsonKey() final  ListingStatus status;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Listing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListingCopyWith<_Listing> get copyWith => __$ListingCopyWithImpl<_Listing>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Listing&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.monthlyRentBirr, monthlyRentBirr) || other.monthlyRentBirr == monthlyRentBirr)&&(identical(other.depositMonths, depositMonths) || other.depositMonths == depositMonths)&&(identical(other.bedrooms, bedrooms) || other.bedrooms == bedrooms)&&(identical(other.bathrooms, bathrooms) || other.bathrooms == bathrooms)&&(identical(other.areaSqm, areaSqm) || other.areaSqm == areaSqm)&&(identical(other.subCity, subCity) || other.subCity == subCity)&&(identical(other.neighbourhood, neighbourhood) || other.neighbourhood == neighbourhood)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&const DeepCollectionEquality().equals(other.amenities, _amenities)&&const DeepCollectionEquality().equals(other.photoUrls, _photoUrls)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,ownerId,title,description,monthlyRentBirr,depositMonths,bedrooms,bathrooms,areaSqm,subCity,neighbourhood,address,latitude,longitude,const DeepCollectionEquality().hash(_amenities),const DeepCollectionEquality().hash(_photoUrls),status,createdAt,updatedAt]);
}

@override
String toString() {
    return 'Listing(id: $id, ownerId: $ownerId, title: $title, description: $description, monthlyRentBirr: $monthlyRentBirr, depositMonths: $depositMonths, bedrooms: $bedrooms, bathrooms: $bathrooms, areaSqm: $areaSqm, subCity: $subCity, neighbourhood: $neighbourhood, address: $address, latitude: $latitude, longitude: $longitude, amenities: $amenities, photoUrls: $photoUrls, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ListingCopyWith<$Res> implements $ListingCopyWith<$Res> {
  factory _$ListingCopyWith(_Listing value, $Res Function(_Listing) _then) = __$ListingCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerId, String title, String description, int monthlyRentBirr, int depositMonths, int bedrooms, int bathrooms, double areaSqm, String subCity, String neighbourhood, String address, double latitude, double longitude, List<String> amenities, List<String> photoUrls, ListingStatus status, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ListingCopyWithImpl<$Res>
    implements _$ListingCopyWith<$Res> {
  __$ListingCopyWithImpl(this._self, this._then);

  final _Listing _self;
  final $Res Function(_Listing) _then;

/// Create a copy of Listing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerId = null,Object? title = null,Object? description = null,Object? monthlyRentBirr = null,Object? depositMonths = null,Object? bedrooms = null,Object? bathrooms = null,Object? areaSqm = null,Object? subCity = null,Object? neighbourhood = null,Object? address = null,Object? latitude = null,Object? longitude = null,Object? amenities = null,Object? photoUrls = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Listing(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,monthlyRentBirr: null == monthlyRentBirr ? _self.monthlyRentBirr : monthlyRentBirr // ignore: cast_nullable_to_non_nullable
as int,depositMonths: null == depositMonths ? _self.depositMonths : depositMonths // ignore: cast_nullable_to_non_nullable
as int,bedrooms: null == bedrooms ? _self.bedrooms : bedrooms // ignore: cast_nullable_to_non_nullable
as int,bathrooms: null == bathrooms ? _self.bathrooms : bathrooms // ignore: cast_nullable_to_non_nullable
as int,areaSqm: null == areaSqm ? _self.areaSqm : areaSqm // ignore: cast_nullable_to_non_nullable
as double,subCity: null == subCity ? _self.subCity : subCity // ignore: cast_nullable_to_non_nullable
as String,neighbourhood: null == neighbourhood ? _self.neighbourhood : neighbourhood // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,amenities: null == amenities ? _self._amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>,photoUrls: null == photoUrls ? _self._photoUrls : photoUrls // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ListingStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
