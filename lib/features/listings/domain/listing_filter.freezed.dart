// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listing_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ListingFilter {

 String? get subCity; String? get neighbourhood; int? get minRent; int? get maxRent; int? get bedrooms; List<String> get amenities; ListingSortOrder get sortOrder;
/// Create a copy of ListingFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListingFilterCopyWith<ListingFilter> get copyWith => _$ListingFilterCopyWithImpl<ListingFilter>(this as ListingFilter, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ListingFilter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListingFilter&&(identical(other.subCity, _this.subCity) || other.subCity == _this.subCity)&&(identical(other.neighbourhood, _this.neighbourhood) || other.neighbourhood == _this.neighbourhood)&&(identical(other.minRent, _this.minRent) || other.minRent == _this.minRent)&&(identical(other.maxRent, _this.maxRent) || other.maxRent == _this.maxRent)&&(identical(other.bedrooms, _this.bedrooms) || other.bedrooms == _this.bedrooms)&&const DeepCollectionEquality().equals(other.amenities, _this.amenities)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder));
}


@override
int get hashCode {
  final _this = this as ListingFilter;
  return Object.hash(runtimeType,_this.subCity,_this.neighbourhood,_this.minRent,_this.maxRent,_this.bedrooms,const DeepCollectionEquality().hash(_this.amenities),_this.sortOrder);
}

@override
String toString() {
  final _this = this as ListingFilter;
  return 'ListingFilter(subCity: ${_this.subCity}, neighbourhood: ${_this.neighbourhood}, minRent: ${_this.minRent}, maxRent: ${_this.maxRent}, bedrooms: ${_this.bedrooms}, amenities: ${_this.amenities}, sortOrder: ${_this.sortOrder})';
}


}

/// @nodoc
abstract mixin class $ListingFilterCopyWith<$Res>  {
  factory $ListingFilterCopyWith(ListingFilter value, $Res Function(ListingFilter) _then) = _$ListingFilterCopyWithImpl;
@useResult
$Res call({
 String? subCity, String? neighbourhood, int? minRent, int? maxRent, int? bedrooms, List<String> amenities, ListingSortOrder sortOrder
});




}
/// @nodoc
class _$ListingFilterCopyWithImpl<$Res>
    implements $ListingFilterCopyWith<$Res> {
  _$ListingFilterCopyWithImpl(this._self, this._then);

  final ListingFilter _self;
  final $Res Function(ListingFilter) _then;

/// Create a copy of ListingFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subCity = freezed,Object? neighbourhood = freezed,Object? minRent = freezed,Object? maxRent = freezed,Object? bedrooms = freezed,Object? amenities = null,Object? sortOrder = null,}) {
  return _then(ListingFilter(
subCity: freezed == subCity ? _self.subCity : subCity // ignore: cast_nullable_to_non_nullable
as String?,neighbourhood: freezed == neighbourhood ? _self.neighbourhood : neighbourhood // ignore: cast_nullable_to_non_nullable
as String?,minRent: freezed == minRent ? _self.minRent : minRent // ignore: cast_nullable_to_non_nullable
as int?,maxRent: freezed == maxRent ? _self.maxRent : maxRent // ignore: cast_nullable_to_non_nullable
as int?,bedrooms: freezed == bedrooms ? _self.bedrooms : bedrooms // ignore: cast_nullable_to_non_nullable
as int?,amenities: null == amenities ? _self.amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as ListingSortOrder,
  ));
}

}


/// Adds pattern-matching-related methods to [ListingFilter].
extension ListingFilterPatterns on ListingFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListingFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListingFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListingFilter value)  $default,){
final _that = this;
switch (_that) {
case _ListingFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListingFilter value)?  $default,){
final _that = this;
switch (_that) {
case _ListingFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? subCity,  String? neighbourhood,  int? minRent,  int? maxRent,  int? bedrooms,  List<String> amenities,  ListingSortOrder sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListingFilter() when $default != null:
return $default(_that.subCity,_that.neighbourhood,_that.minRent,_that.maxRent,_that.bedrooms,_that.amenities,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? subCity,  String? neighbourhood,  int? minRent,  int? maxRent,  int? bedrooms,  List<String> amenities,  ListingSortOrder sortOrder)  $default,) {final _that = this;
switch (_that) {
case _ListingFilter():
return $default(_that.subCity,_that.neighbourhood,_that.minRent,_that.maxRent,_that.bedrooms,_that.amenities,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? subCity,  String? neighbourhood,  int? minRent,  int? maxRent,  int? bedrooms,  List<String> amenities,  ListingSortOrder sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _ListingFilter() when $default != null:
return $default(_that.subCity,_that.neighbourhood,_that.minRent,_that.maxRent,_that.bedrooms,_that.amenities,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc


class _ListingFilter extends ListingFilter {
  const _ListingFilter({this.subCity, this.neighbourhood, this.minRent, this.maxRent, this.bedrooms,  List<String> amenities = const <String>[], this.sortOrder = ListingSortOrder.newest}): _amenities = amenities,super._();
  

@override final  String? subCity;
@override final  String? neighbourhood;
@override final  int? minRent;
@override final  int? maxRent;
@override final  int? bedrooms;
 final  List<String> _amenities;
@override@JsonKey() List<String> get amenities {
  if (_amenities is EqualUnmodifiableListView) return _amenities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_amenities);
}

@override@JsonKey() final  ListingSortOrder sortOrder;

/// Create a copy of ListingFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListingFilterCopyWith<_ListingFilter> get copyWith => __$ListingFilterCopyWithImpl<_ListingFilter>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListingFilter&&(identical(other.subCity, subCity) || other.subCity == subCity)&&(identical(other.neighbourhood, neighbourhood) || other.neighbourhood == neighbourhood)&&(identical(other.minRent, minRent) || other.minRent == minRent)&&(identical(other.maxRent, maxRent) || other.maxRent == maxRent)&&(identical(other.bedrooms, bedrooms) || other.bedrooms == bedrooms)&&const DeepCollectionEquality().equals(other.amenities, _amenities)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode {
    return Object.hash(runtimeType,subCity,neighbourhood,minRent,maxRent,bedrooms,const DeepCollectionEquality().hash(_amenities),sortOrder);
}

@override
String toString() {
    return 'ListingFilter(subCity: $subCity, neighbourhood: $neighbourhood, minRent: $minRent, maxRent: $maxRent, bedrooms: $bedrooms, amenities: $amenities, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$ListingFilterCopyWith<$Res> implements $ListingFilterCopyWith<$Res> {
  factory _$ListingFilterCopyWith(_ListingFilter value, $Res Function(_ListingFilter) _then) = __$ListingFilterCopyWithImpl;
@override @useResult
$Res call({
 String? subCity, String? neighbourhood, int? minRent, int? maxRent, int? bedrooms, List<String> amenities, ListingSortOrder sortOrder
});




}
/// @nodoc
class __$ListingFilterCopyWithImpl<$Res>
    implements _$ListingFilterCopyWith<$Res> {
  __$ListingFilterCopyWithImpl(this._self, this._then);

  final _ListingFilter _self;
  final $Res Function(_ListingFilter) _then;

/// Create a copy of ListingFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subCity = freezed,Object? neighbourhood = freezed,Object? minRent = freezed,Object? maxRent = freezed,Object? bedrooms = freezed,Object? amenities = null,Object? sortOrder = null,}) {
  return _then(_ListingFilter(
subCity: freezed == subCity ? _self.subCity : subCity // ignore: cast_nullable_to_non_nullable
as String?,neighbourhood: freezed == neighbourhood ? _self.neighbourhood : neighbourhood // ignore: cast_nullable_to_non_nullable
as String?,minRent: freezed == minRent ? _self.minRent : minRent // ignore: cast_nullable_to_non_nullable
as int?,maxRent: freezed == maxRent ? _self.maxRent : maxRent // ignore: cast_nullable_to_non_nullable
as int?,bedrooms: freezed == bedrooms ? _self.bedrooms : bedrooms // ignore: cast_nullable_to_non_nullable
as int?,amenities: null == amenities ? _self._amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as ListingSortOrder,
  ));
}


}

// dart format on
