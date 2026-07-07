// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_presence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoomPresence {

 RoomId get roomId; int get occupantCount; int get activeCount;/// T8エッジ#6: TTL結果整合下での鮮度提示に使う
 DateTime get asOf;
/// Create a copy of RoomPresence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomPresenceCopyWith<RoomPresence> get copyWith => _$RoomPresenceCopyWithImpl<RoomPresence>(this as RoomPresence, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomPresence&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.occupantCount, occupantCount) || other.occupantCount == occupantCount)&&(identical(other.activeCount, activeCount) || other.activeCount == activeCount)&&(identical(other.asOf, asOf) || other.asOf == asOf));
}


@override
int get hashCode => Object.hash(runtimeType,roomId,occupantCount,activeCount,asOf);

@override
String toString() {
  return 'RoomPresence(roomId: $roomId, occupantCount: $occupantCount, activeCount: $activeCount, asOf: $asOf)';
}


}

/// @nodoc
abstract mixin class $RoomPresenceCopyWith<$Res>  {
  factory $RoomPresenceCopyWith(RoomPresence value, $Res Function(RoomPresence) _then) = _$RoomPresenceCopyWithImpl;
@useResult
$Res call({
 RoomId roomId, int occupantCount, int activeCount, DateTime asOf
});




}
/// @nodoc
class _$RoomPresenceCopyWithImpl<$Res>
    implements $RoomPresenceCopyWith<$Res> {
  _$RoomPresenceCopyWithImpl(this._self, this._then);

  final RoomPresence _self;
  final $Res Function(RoomPresence) _then;

/// Create a copy of RoomPresence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roomId = null,Object? occupantCount = null,Object? activeCount = null,Object? asOf = null,}) {
  return _then(_self.copyWith(
roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as RoomId,occupantCount: null == occupantCount ? _self.occupantCount : occupantCount // ignore: cast_nullable_to_non_nullable
as int,activeCount: null == activeCount ? _self.activeCount : activeCount // ignore: cast_nullable_to_non_nullable
as int,asOf: null == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RoomPresence].
extension RoomPresencePatterns on RoomPresence {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomPresence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomPresence() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomPresence value)  $default,){
final _that = this;
switch (_that) {
case _RoomPresence():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomPresence value)?  $default,){
final _that = this;
switch (_that) {
case _RoomPresence() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RoomId roomId,  int occupantCount,  int activeCount,  DateTime asOf)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomPresence() when $default != null:
return $default(_that.roomId,_that.occupantCount,_that.activeCount,_that.asOf);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RoomId roomId,  int occupantCount,  int activeCount,  DateTime asOf)  $default,) {final _that = this;
switch (_that) {
case _RoomPresence():
return $default(_that.roomId,_that.occupantCount,_that.activeCount,_that.asOf);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RoomId roomId,  int occupantCount,  int activeCount,  DateTime asOf)?  $default,) {final _that = this;
switch (_that) {
case _RoomPresence() when $default != null:
return $default(_that.roomId,_that.occupantCount,_that.activeCount,_that.asOf);case _:
  return null;

}
}

}

/// @nodoc


class _RoomPresence implements RoomPresence {
  const _RoomPresence({required this.roomId, required this.occupantCount, required this.activeCount, required this.asOf}): assert(occupantCount >= 0 && activeCount >= 0 && activeCount <= occupantCount);
  

@override final  RoomId roomId;
@override final  int occupantCount;
@override final  int activeCount;
/// T8エッジ#6: TTL結果整合下での鮮度提示に使う
@override final  DateTime asOf;

/// Create a copy of RoomPresence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomPresenceCopyWith<_RoomPresence> get copyWith => __$RoomPresenceCopyWithImpl<_RoomPresence>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomPresence&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.occupantCount, occupantCount) || other.occupantCount == occupantCount)&&(identical(other.activeCount, activeCount) || other.activeCount == activeCount)&&(identical(other.asOf, asOf) || other.asOf == asOf));
}


@override
int get hashCode => Object.hash(runtimeType,roomId,occupantCount,activeCount,asOf);

@override
String toString() {
  return 'RoomPresence(roomId: $roomId, occupantCount: $occupantCount, activeCount: $activeCount, asOf: $asOf)';
}


}

/// @nodoc
abstract mixin class _$RoomPresenceCopyWith<$Res> implements $RoomPresenceCopyWith<$Res> {
  factory _$RoomPresenceCopyWith(_RoomPresence value, $Res Function(_RoomPresence) _then) = __$RoomPresenceCopyWithImpl;
@override @useResult
$Res call({
 RoomId roomId, int occupantCount, int activeCount, DateTime asOf
});




}
/// @nodoc
class __$RoomPresenceCopyWithImpl<$Res>
    implements _$RoomPresenceCopyWith<$Res> {
  __$RoomPresenceCopyWithImpl(this._self, this._then);

  final _RoomPresence _self;
  final $Res Function(_RoomPresence) _then;

/// Create a copy of RoomPresence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roomId = null,Object? occupantCount = null,Object? activeCount = null,Object? asOf = null,}) {
  return _then(_RoomPresence(
roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as RoomId,occupantCount: null == occupantCount ? _self.occupantCount : occupantCount // ignore: cast_nullable_to_non_nullable
as int,activeCount: null == activeCount ? _self.activeCount : activeCount // ignore: cast_nullable_to_non_nullable
as int,asOf: null == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
