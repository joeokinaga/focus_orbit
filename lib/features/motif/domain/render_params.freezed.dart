// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'render_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RenderParams {

 int get primaryColorArgb; int get secondaryColorArgb; double get particleDensity; double get flowSpeed; double get ambientGlow;
/// Create a copy of RenderParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenderParamsCopyWith<RenderParams> get copyWith => _$RenderParamsCopyWithImpl<RenderParams>(this as RenderParams, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenderParams&&(identical(other.primaryColorArgb, primaryColorArgb) || other.primaryColorArgb == primaryColorArgb)&&(identical(other.secondaryColorArgb, secondaryColorArgb) || other.secondaryColorArgb == secondaryColorArgb)&&(identical(other.particleDensity, particleDensity) || other.particleDensity == particleDensity)&&(identical(other.flowSpeed, flowSpeed) || other.flowSpeed == flowSpeed)&&(identical(other.ambientGlow, ambientGlow) || other.ambientGlow == ambientGlow));
}


@override
int get hashCode => Object.hash(runtimeType,primaryColorArgb,secondaryColorArgb,particleDensity,flowSpeed,ambientGlow);

@override
String toString() {
  return 'RenderParams(primaryColorArgb: $primaryColorArgb, secondaryColorArgb: $secondaryColorArgb, particleDensity: $particleDensity, flowSpeed: $flowSpeed, ambientGlow: $ambientGlow)';
}


}

/// @nodoc
abstract mixin class $RenderParamsCopyWith<$Res>  {
  factory $RenderParamsCopyWith(RenderParams value, $Res Function(RenderParams) _then) = _$RenderParamsCopyWithImpl;
@useResult
$Res call({
 int primaryColorArgb, int secondaryColorArgb, double particleDensity, double flowSpeed, double ambientGlow
});




}
/// @nodoc
class _$RenderParamsCopyWithImpl<$Res>
    implements $RenderParamsCopyWith<$Res> {
  _$RenderParamsCopyWithImpl(this._self, this._then);

  final RenderParams _self;
  final $Res Function(RenderParams) _then;

/// Create a copy of RenderParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? primaryColorArgb = null,Object? secondaryColorArgb = null,Object? particleDensity = null,Object? flowSpeed = null,Object? ambientGlow = null,}) {
  return _then(_self.copyWith(
primaryColorArgb: null == primaryColorArgb ? _self.primaryColorArgb : primaryColorArgb // ignore: cast_nullable_to_non_nullable
as int,secondaryColorArgb: null == secondaryColorArgb ? _self.secondaryColorArgb : secondaryColorArgb // ignore: cast_nullable_to_non_nullable
as int,particleDensity: null == particleDensity ? _self.particleDensity : particleDensity // ignore: cast_nullable_to_non_nullable
as double,flowSpeed: null == flowSpeed ? _self.flowSpeed : flowSpeed // ignore: cast_nullable_to_non_nullable
as double,ambientGlow: null == ambientGlow ? _self.ambientGlow : ambientGlow // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RenderParams].
extension RenderParamsPatterns on RenderParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RenderParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RenderParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RenderParams value)  $default,){
final _that = this;
switch (_that) {
case _RenderParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RenderParams value)?  $default,){
final _that = this;
switch (_that) {
case _RenderParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int primaryColorArgb,  int secondaryColorArgb,  double particleDensity,  double flowSpeed,  double ambientGlow)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RenderParams() when $default != null:
return $default(_that.primaryColorArgb,_that.secondaryColorArgb,_that.particleDensity,_that.flowSpeed,_that.ambientGlow);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int primaryColorArgb,  int secondaryColorArgb,  double particleDensity,  double flowSpeed,  double ambientGlow)  $default,) {final _that = this;
switch (_that) {
case _RenderParams():
return $default(_that.primaryColorArgb,_that.secondaryColorArgb,_that.particleDensity,_that.flowSpeed,_that.ambientGlow);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int primaryColorArgb,  int secondaryColorArgb,  double particleDensity,  double flowSpeed,  double ambientGlow)?  $default,) {final _that = this;
switch (_that) {
case _RenderParams() when $default != null:
return $default(_that.primaryColorArgb,_that.secondaryColorArgb,_that.particleDensity,_that.flowSpeed,_that.ambientGlow);case _:
  return null;

}
}

}

/// @nodoc


class _RenderParams implements RenderParams {
  const _RenderParams({required this.primaryColorArgb, required this.secondaryColorArgb, required this.particleDensity, required this.flowSpeed, required this.ambientGlow}): assert(particleDensity >= 0 && particleDensity <= 1),assert(flowSpeed > 0),assert(ambientGlow >= 0 && ambientGlow <= 1);
  

@override final  int primaryColorArgb;
@override final  int secondaryColorArgb;
@override final  double particleDensity;
@override final  double flowSpeed;
@override final  double ambientGlow;

/// Create a copy of RenderParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RenderParamsCopyWith<_RenderParams> get copyWith => __$RenderParamsCopyWithImpl<_RenderParams>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RenderParams&&(identical(other.primaryColorArgb, primaryColorArgb) || other.primaryColorArgb == primaryColorArgb)&&(identical(other.secondaryColorArgb, secondaryColorArgb) || other.secondaryColorArgb == secondaryColorArgb)&&(identical(other.particleDensity, particleDensity) || other.particleDensity == particleDensity)&&(identical(other.flowSpeed, flowSpeed) || other.flowSpeed == flowSpeed)&&(identical(other.ambientGlow, ambientGlow) || other.ambientGlow == ambientGlow));
}


@override
int get hashCode => Object.hash(runtimeType,primaryColorArgb,secondaryColorArgb,particleDensity,flowSpeed,ambientGlow);

@override
String toString() {
  return 'RenderParams(primaryColorArgb: $primaryColorArgb, secondaryColorArgb: $secondaryColorArgb, particleDensity: $particleDensity, flowSpeed: $flowSpeed, ambientGlow: $ambientGlow)';
}


}

/// @nodoc
abstract mixin class _$RenderParamsCopyWith<$Res> implements $RenderParamsCopyWith<$Res> {
  factory _$RenderParamsCopyWith(_RenderParams value, $Res Function(_RenderParams) _then) = __$RenderParamsCopyWithImpl;
@override @useResult
$Res call({
 int primaryColorArgb, int secondaryColorArgb, double particleDensity, double flowSpeed, double ambientGlow
});




}
/// @nodoc
class __$RenderParamsCopyWithImpl<$Res>
    implements _$RenderParamsCopyWith<$Res> {
  __$RenderParamsCopyWithImpl(this._self, this._then);

  final _RenderParams _self;
  final $Res Function(_RenderParams) _then;

/// Create a copy of RenderParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? primaryColorArgb = null,Object? secondaryColorArgb = null,Object? particleDensity = null,Object? flowSpeed = null,Object? ambientGlow = null,}) {
  return _then(_RenderParams(
primaryColorArgb: null == primaryColorArgb ? _self.primaryColorArgb : primaryColorArgb // ignore: cast_nullable_to_non_nullable
as int,secondaryColorArgb: null == secondaryColorArgb ? _self.secondaryColorArgb : secondaryColorArgb // ignore: cast_nullable_to_non_nullable
as int,particleDensity: null == particleDensity ? _self.particleDensity : particleDensity // ignore: cast_nullable_to_non_nullable
as double,flowSpeed: null == flowSpeed ? _self.flowSpeed : flowSpeed // ignore: cast_nullable_to_non_nullable
as double,ambientGlow: null == ambientGlow ? _self.ambientGlow : ambientGlow // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
