// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'viewing_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ViewingRequest {

 String get id; String get listingId; String get tenantId; String get ownerId; DateTime get proposedDateTime; String? get message; ViewingRequestStatus get status; DateTime get createdAt;
/// Create a copy of ViewingRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ViewingRequestCopyWith<ViewingRequest> get copyWith => _$ViewingRequestCopyWithImpl<ViewingRequest>(this as ViewingRequest, _$identity);

  /// Serializes this ViewingRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ViewingRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ViewingRequest&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.listingId, _this.listingId) || other.listingId == _this.listingId)&&(identical(other.tenantId, _this.tenantId) || other.tenantId == _this.tenantId)&&(identical(other.ownerId, _this.ownerId) || other.ownerId == _this.ownerId)&&(identical(other.proposedDateTime, _this.proposedDateTime) || other.proposedDateTime == _this.proposedDateTime)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ViewingRequest;
  return Object.hash(runtimeType,_this.id,_this.listingId,_this.tenantId,_this.ownerId,_this.proposedDateTime,_this.message,_this.status,_this.createdAt);
}

@override
String toString() {
  final _this = this as ViewingRequest;
  return 'ViewingRequest(id: ${_this.id}, listingId: ${_this.listingId}, tenantId: ${_this.tenantId}, ownerId: ${_this.ownerId}, proposedDateTime: ${_this.proposedDateTime}, message: ${_this.message}, status: ${_this.status}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ViewingRequestCopyWith<$Res>  {
  factory $ViewingRequestCopyWith(ViewingRequest value, $Res Function(ViewingRequest) _then) = _$ViewingRequestCopyWithImpl;
@useResult
$Res call({
 String id, String listingId, String tenantId, String ownerId, DateTime proposedDateTime, String? message, ViewingRequestStatus status, DateTime createdAt
});




}
/// @nodoc
class _$ViewingRequestCopyWithImpl<$Res>
    implements $ViewingRequestCopyWith<$Res> {
  _$ViewingRequestCopyWithImpl(this._self, this._then);

  final ViewingRequest _self;
  final $Res Function(ViewingRequest) _then;

/// Create a copy of ViewingRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? listingId = null,Object? tenantId = null,Object? ownerId = null,Object? proposedDateTime = null,Object? message = freezed,Object? status = null,Object? createdAt = null,}) {
  return _then(ViewingRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,listingId: null == listingId ? _self.listingId : listingId // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,proposedDateTime: null == proposedDateTime ? _self.proposedDateTime : proposedDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewingRequestStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ViewingRequest].
extension ViewingRequestPatterns on ViewingRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ViewingRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ViewingRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ViewingRequest value)  $default,){
final _that = this;
switch (_that) {
case _ViewingRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ViewingRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ViewingRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String listingId,  String tenantId,  String ownerId,  DateTime proposedDateTime,  String? message,  ViewingRequestStatus status,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ViewingRequest() when $default != null:
return $default(_that.id,_that.listingId,_that.tenantId,_that.ownerId,_that.proposedDateTime,_that.message,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String listingId,  String tenantId,  String ownerId,  DateTime proposedDateTime,  String? message,  ViewingRequestStatus status,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ViewingRequest():
return $default(_that.id,_that.listingId,_that.tenantId,_that.ownerId,_that.proposedDateTime,_that.message,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String listingId,  String tenantId,  String ownerId,  DateTime proposedDateTime,  String? message,  ViewingRequestStatus status,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ViewingRequest() when $default != null:
return $default(_that.id,_that.listingId,_that.tenantId,_that.ownerId,_that.proposedDateTime,_that.message,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ViewingRequest implements ViewingRequest {
  const _ViewingRequest({required this.id, required this.listingId, required this.tenantId, required this.ownerId, required this.proposedDateTime, this.message, this.status = ViewingRequestStatus.pending, required this.createdAt});
  factory _ViewingRequest.fromJson(Map<String, dynamic> json) => _$ViewingRequestFromJson(json);

@override final  String id;
@override final  String listingId;
@override final  String tenantId;
@override final  String ownerId;
@override final  DateTime proposedDateTime;
@override final  String? message;
@override@JsonKey() final  ViewingRequestStatus status;
@override final  DateTime createdAt;

/// Create a copy of ViewingRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ViewingRequestCopyWith<_ViewingRequest> get copyWith => __$ViewingRequestCopyWithImpl<_ViewingRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ViewingRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ViewingRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.listingId, listingId) || other.listingId == listingId)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.proposedDateTime, proposedDateTime) || other.proposedDateTime == proposedDateTime)&&(identical(other.message, message) || other.message == message)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,listingId,tenantId,ownerId,proposedDateTime,message,status,createdAt);
}

@override
String toString() {
    return 'ViewingRequest(id: $id, listingId: $listingId, tenantId: $tenantId, ownerId: $ownerId, proposedDateTime: $proposedDateTime, message: $message, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ViewingRequestCopyWith<$Res> implements $ViewingRequestCopyWith<$Res> {
  factory _$ViewingRequestCopyWith(_ViewingRequest value, $Res Function(_ViewingRequest) _then) = __$ViewingRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String listingId, String tenantId, String ownerId, DateTime proposedDateTime, String? message, ViewingRequestStatus status, DateTime createdAt
});




}
/// @nodoc
class __$ViewingRequestCopyWithImpl<$Res>
    implements _$ViewingRequestCopyWith<$Res> {
  __$ViewingRequestCopyWithImpl(this._self, this._then);

  final _ViewingRequest _self;
  final $Res Function(_ViewingRequest) _then;

/// Create a copy of ViewingRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? listingId = null,Object? tenantId = null,Object? ownerId = null,Object? proposedDateTime = null,Object? message = freezed,Object? status = null,Object? createdAt = null,}) {
  return _then(_ViewingRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,listingId: null == listingId ? _self.listingId : listingId // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,proposedDateTime: null == proposedDateTime ? _self.proposedDateTime : proposedDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ViewingRequestStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
