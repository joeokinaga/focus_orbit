// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'motion_sample.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MotionSample {

 double get gravityX; double get gravityY; double get gravityZ; double get userX; double get userY; double get userZ; DateTime get timestamp;
/// Create a copy of MotionSample
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MotionSampleCopyWith<MotionSample> get copyWith => _$MotionSampleCopyWithImpl<MotionSample>(this as MotionSample, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MotionSample&&(identical(other.gravityX, gravityX) || other.gravityX == gravityX)&&(identical(other.gravityY, gravityY) || other.gravityY == gravityY)&&(identical(other.gravityZ, gravityZ) || other.gravityZ == gravityZ)&&(identical(other.userX, userX) || other.userX == userX)&&(identical(other.userY, userY) || other.userY == userY)&&(identical(other.userZ, userZ) || other.userZ == userZ)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,gravityX,gravityY,gravityZ,userX,userY,userZ,timestamp);

@override
String toString() {
  return 'MotionSample(gravityX: $gravityX, gravityY: $gravityY, gravityZ: $gravityZ, userX: $userX, userY: $userY, userZ: $userZ, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $MotionSampleCopyWith<$Res>  {
  factory $MotionSampleCopyWith(MotionSample value, $Res Function(MotionSample) _then) = _$MotionSampleCopyWithImpl;
@useResult
$Res call({
 double gravityX, double gravityY, double gravityZ, double userX, double userY, double userZ, DateTime timestamp
});




}
/// @nodoc
class _$MotionSampleCopyWithImpl<$Res>
    implements $MotionSampleCopyWith<$Res> {
  _$MotionSampleCopyWithImpl(this._self, this._then);

  final MotionSample _self;
  final $Res Function(MotionSample) _then;

/// Create a copy of MotionSample
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gravityX = null,Object? gravityY = null,Object? gravityZ = null,Object? userX = null,Object? userY = null,Object? userZ = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
gravityX: null == gravityX ? _self.gravityX : gravityX // ignore: cast_nullable_to_non_nullable
as double,gravityY: null == gravityY ? _self.gravityY : gravityY // ignore: cast_nullable_to_non_nullable
as double,gravityZ: null == gravityZ ? _self.gravityZ : gravityZ // ignore: cast_nullable_to_non_nullable
as double,userX: null == userX ? _self.userX : userX // ignore: cast_nullable_to_non_nullable
as double,userY: null == userY ? _self.userY : userY // ignore: cast_nullable_to_non_nullable
as double,userZ: null == userZ ? _self.userZ : userZ // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MotionSample].
extension MotionSamplePatterns on MotionSample {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MotionSample value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MotionSample() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MotionSample value)  $default,){
final _that = this;
switch (_that) {
case _MotionSample():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MotionSample value)?  $default,){
final _that = this;
switch (_that) {
case _MotionSample() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double gravityX,  double gravityY,  double gravityZ,  double userX,  double userY,  double userZ,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MotionSample() when $default != null:
return $default(_that.gravityX,_that.gravityY,_that.gravityZ,_that.userX,_that.userY,_that.userZ,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double gravityX,  double gravityY,  double gravityZ,  double userX,  double userY,  double userZ,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _MotionSample():
return $default(_that.gravityX,_that.gravityY,_that.gravityZ,_that.userX,_that.userY,_that.userZ,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double gravityX,  double gravityY,  double gravityZ,  double userX,  double userY,  double userZ,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _MotionSample() when $default != null:
return $default(_that.gravityX,_that.gravityY,_that.gravityZ,_that.userX,_that.userY,_that.userZ,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc


class _MotionSample implements MotionSample {
  const _MotionSample({required this.gravityX, required this.gravityY, required this.gravityZ, required this.userX, required this.userY, required this.userZ, required this.timestamp});
  

@override final  double gravityX;
@override final  double gravityY;
@override final  double gravityZ;
@override final  double userX;
@override final  double userY;
@override final  double userZ;
@override final  DateTime timestamp;

/// Create a copy of MotionSample
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MotionSampleCopyWith<_MotionSample> get copyWith => __$MotionSampleCopyWithImpl<_MotionSample>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MotionSample&&(identical(other.gravityX, gravityX) || other.gravityX == gravityX)&&(identical(other.gravityY, gravityY) || other.gravityY == gravityY)&&(identical(other.gravityZ, gravityZ) || other.gravityZ == gravityZ)&&(identical(other.userX, userX) || other.userX == userX)&&(identical(other.userY, userY) || other.userY == userY)&&(identical(other.userZ, userZ) || other.userZ == userZ)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,gravityX,gravityY,gravityZ,userX,userY,userZ,timestamp);

@override
String toString() {
  return 'MotionSample(gravityX: $gravityX, gravityY: $gravityY, gravityZ: $gravityZ, userX: $userX, userY: $userY, userZ: $userZ, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$MotionSampleCopyWith<$Res> implements $MotionSampleCopyWith<$Res> {
  factory _$MotionSampleCopyWith(_MotionSample value, $Res Function(_MotionSample) _then) = __$MotionSampleCopyWithImpl;
@override @useResult
$Res call({
 double gravityX, double gravityY, double gravityZ, double userX, double userY, double userZ, DateTime timestamp
});




}
/// @nodoc
class __$MotionSampleCopyWithImpl<$Res>
    implements _$MotionSampleCopyWith<$Res> {
  __$MotionSampleCopyWithImpl(this._self, this._then);

  final _MotionSample _self;
  final $Res Function(_MotionSample) _then;

/// Create a copy of MotionSample
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gravityX = null,Object? gravityY = null,Object? gravityZ = null,Object? userX = null,Object? userY = null,Object? userZ = null,Object? timestamp = null,}) {
  return _then(_MotionSample(
gravityX: null == gravityX ? _self.gravityX : gravityX // ignore: cast_nullable_to_non_nullable
as double,gravityY: null == gravityY ? _self.gravityY : gravityY // ignore: cast_nullable_to_non_nullable
as double,gravityZ: null == gravityZ ? _self.gravityZ : gravityZ // ignore: cast_nullable_to_non_nullable
as double,userX: null == userX ? _self.userX : userX // ignore: cast_nullable_to_non_nullable
as double,userY: null == userY ? _self.userY : userY // ignore: cast_nullable_to_non_nullable
as double,userZ: null == userZ ? _self.userZ : userZ // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
