// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stance_thresholds.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StanceThresholds {

/// これ以上のz軸重力成分で「上向き」(例: 8.5)
 double get faceUpGravityZMin;/// 移動窓RMSがこれ以下で「完全静止」(例: 0.06)
 double get stillRmsMax;/// RMSがこれ以下なら「微小振動」、超えたらlifted扱い(例: 0.9)
 double get vibrationRmsMax;/// RMS計算の移動窓幅(例: 400ms)
 Duration get rmsWindow;/// 状態確定に必要な持続時間=チャタリング防止(例: 250ms)
 Duration get commitDebounce;
/// Create a copy of StanceThresholds
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StanceThresholdsCopyWith<StanceThresholds> get copyWith => _$StanceThresholdsCopyWithImpl<StanceThresholds>(this as StanceThresholds, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StanceThresholds&&(identical(other.faceUpGravityZMin, faceUpGravityZMin) || other.faceUpGravityZMin == faceUpGravityZMin)&&(identical(other.stillRmsMax, stillRmsMax) || other.stillRmsMax == stillRmsMax)&&(identical(other.vibrationRmsMax, vibrationRmsMax) || other.vibrationRmsMax == vibrationRmsMax)&&(identical(other.rmsWindow, rmsWindow) || other.rmsWindow == rmsWindow)&&(identical(other.commitDebounce, commitDebounce) || other.commitDebounce == commitDebounce));
}


@override
int get hashCode => Object.hash(runtimeType,faceUpGravityZMin,stillRmsMax,vibrationRmsMax,rmsWindow,commitDebounce);

@override
String toString() {
  return 'StanceThresholds(faceUpGravityZMin: $faceUpGravityZMin, stillRmsMax: $stillRmsMax, vibrationRmsMax: $vibrationRmsMax, rmsWindow: $rmsWindow, commitDebounce: $commitDebounce)';
}


}

/// @nodoc
abstract mixin class $StanceThresholdsCopyWith<$Res>  {
  factory $StanceThresholdsCopyWith(StanceThresholds value, $Res Function(StanceThresholds) _then) = _$StanceThresholdsCopyWithImpl;
@useResult
$Res call({
 double faceUpGravityZMin, double stillRmsMax, double vibrationRmsMax, Duration rmsWindow, Duration commitDebounce
});




}
/// @nodoc
class _$StanceThresholdsCopyWithImpl<$Res>
    implements $StanceThresholdsCopyWith<$Res> {
  _$StanceThresholdsCopyWithImpl(this._self, this._then);

  final StanceThresholds _self;
  final $Res Function(StanceThresholds) _then;

/// Create a copy of StanceThresholds
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? faceUpGravityZMin = null,Object? stillRmsMax = null,Object? vibrationRmsMax = null,Object? rmsWindow = null,Object? commitDebounce = null,}) {
  return _then(_self.copyWith(
faceUpGravityZMin: null == faceUpGravityZMin ? _self.faceUpGravityZMin : faceUpGravityZMin // ignore: cast_nullable_to_non_nullable
as double,stillRmsMax: null == stillRmsMax ? _self.stillRmsMax : stillRmsMax // ignore: cast_nullable_to_non_nullable
as double,vibrationRmsMax: null == vibrationRmsMax ? _self.vibrationRmsMax : vibrationRmsMax // ignore: cast_nullable_to_non_nullable
as double,rmsWindow: null == rmsWindow ? _self.rmsWindow : rmsWindow // ignore: cast_nullable_to_non_nullable
as Duration,commitDebounce: null == commitDebounce ? _self.commitDebounce : commitDebounce // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}

}


/// Adds pattern-matching-related methods to [StanceThresholds].
extension StanceThresholdsPatterns on StanceThresholds {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StanceThresholds value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StanceThresholds() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StanceThresholds value)  $default,){
final _that = this;
switch (_that) {
case _StanceThresholds():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StanceThresholds value)?  $default,){
final _that = this;
switch (_that) {
case _StanceThresholds() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double faceUpGravityZMin,  double stillRmsMax,  double vibrationRmsMax,  Duration rmsWindow,  Duration commitDebounce)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StanceThresholds() when $default != null:
return $default(_that.faceUpGravityZMin,_that.stillRmsMax,_that.vibrationRmsMax,_that.rmsWindow,_that.commitDebounce);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double faceUpGravityZMin,  double stillRmsMax,  double vibrationRmsMax,  Duration rmsWindow,  Duration commitDebounce)  $default,) {final _that = this;
switch (_that) {
case _StanceThresholds():
return $default(_that.faceUpGravityZMin,_that.stillRmsMax,_that.vibrationRmsMax,_that.rmsWindow,_that.commitDebounce);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double faceUpGravityZMin,  double stillRmsMax,  double vibrationRmsMax,  Duration rmsWindow,  Duration commitDebounce)?  $default,) {final _that = this;
switch (_that) {
case _StanceThresholds() when $default != null:
return $default(_that.faceUpGravityZMin,_that.stillRmsMax,_that.vibrationRmsMax,_that.rmsWindow,_that.commitDebounce);case _:
  return null;

}
}

}

/// @nodoc


class _StanceThresholds implements StanceThresholds {
  const _StanceThresholds({required this.faceUpGravityZMin, required this.stillRmsMax, required this.vibrationRmsMax, required this.rmsWindow, required this.commitDebounce}): assert(stillRmsMax < vibrationRmsMax, 'still上限はvibration上限より小さいこと'),assert(faceUpGravityZMin > 0);
  

/// これ以上のz軸重力成分で「上向き」(例: 8.5)
@override final  double faceUpGravityZMin;
/// 移動窓RMSがこれ以下で「完全静止」(例: 0.06)
@override final  double stillRmsMax;
/// RMSがこれ以下なら「微小振動」、超えたらlifted扱い(例: 0.9)
@override final  double vibrationRmsMax;
/// RMS計算の移動窓幅(例: 400ms)
@override final  Duration rmsWindow;
/// 状態確定に必要な持続時間=チャタリング防止(例: 250ms)
@override final  Duration commitDebounce;

/// Create a copy of StanceThresholds
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StanceThresholdsCopyWith<_StanceThresholds> get copyWith => __$StanceThresholdsCopyWithImpl<_StanceThresholds>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StanceThresholds&&(identical(other.faceUpGravityZMin, faceUpGravityZMin) || other.faceUpGravityZMin == faceUpGravityZMin)&&(identical(other.stillRmsMax, stillRmsMax) || other.stillRmsMax == stillRmsMax)&&(identical(other.vibrationRmsMax, vibrationRmsMax) || other.vibrationRmsMax == vibrationRmsMax)&&(identical(other.rmsWindow, rmsWindow) || other.rmsWindow == rmsWindow)&&(identical(other.commitDebounce, commitDebounce) || other.commitDebounce == commitDebounce));
}


@override
int get hashCode => Object.hash(runtimeType,faceUpGravityZMin,stillRmsMax,vibrationRmsMax,rmsWindow,commitDebounce);

@override
String toString() {
  return 'StanceThresholds(faceUpGravityZMin: $faceUpGravityZMin, stillRmsMax: $stillRmsMax, vibrationRmsMax: $vibrationRmsMax, rmsWindow: $rmsWindow, commitDebounce: $commitDebounce)';
}


}

/// @nodoc
abstract mixin class _$StanceThresholdsCopyWith<$Res> implements $StanceThresholdsCopyWith<$Res> {
  factory _$StanceThresholdsCopyWith(_StanceThresholds value, $Res Function(_StanceThresholds) _then) = __$StanceThresholdsCopyWithImpl;
@override @useResult
$Res call({
 double faceUpGravityZMin, double stillRmsMax, double vibrationRmsMax, Duration rmsWindow, Duration commitDebounce
});




}
/// @nodoc
class __$StanceThresholdsCopyWithImpl<$Res>
    implements _$StanceThresholdsCopyWith<$Res> {
  __$StanceThresholdsCopyWithImpl(this._self, this._then);

  final _StanceThresholds _self;
  final $Res Function(_StanceThresholds) _then;

/// Create a copy of StanceThresholds
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? faceUpGravityZMin = null,Object? stillRmsMax = null,Object? vibrationRmsMax = null,Object? rmsWindow = null,Object? commitDebounce = null,}) {
  return _then(_StanceThresholds(
faceUpGravityZMin: null == faceUpGravityZMin ? _self.faceUpGravityZMin : faceUpGravityZMin // ignore: cast_nullable_to_non_nullable
as double,stillRmsMax: null == stillRmsMax ? _self.stillRmsMax : stillRmsMax // ignore: cast_nullable_to_non_nullable
as double,vibrationRmsMax: null == vibrationRmsMax ? _self.vibrationRmsMax : vibrationRmsMax // ignore: cast_nullable_to_non_nullable
as double,rmsWindow: null == rmsWindow ? _self.rmsWindow : rmsWindow // ignore: cast_nullable_to_non_nullable
as Duration,commitDebounce: null == commitDebounce ? _self.commitDebounce : commitDebounce // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

// dart format on
