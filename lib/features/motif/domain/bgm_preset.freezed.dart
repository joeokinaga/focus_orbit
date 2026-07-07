// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bgm_preset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BgmPreset {

 String get trackId; double get volume; Duration get fadeIn; bool get loops;
/// Create a copy of BgmPreset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BgmPresetCopyWith<BgmPreset> get copyWith => _$BgmPresetCopyWithImpl<BgmPreset>(this as BgmPreset, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BgmPreset&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.fadeIn, fadeIn) || other.fadeIn == fadeIn)&&(identical(other.loops, loops) || other.loops == loops));
}


@override
int get hashCode => Object.hash(runtimeType,trackId,volume,fadeIn,loops);

@override
String toString() {
  return 'BgmPreset(trackId: $trackId, volume: $volume, fadeIn: $fadeIn, loops: $loops)';
}


}

/// @nodoc
abstract mixin class $BgmPresetCopyWith<$Res>  {
  factory $BgmPresetCopyWith(BgmPreset value, $Res Function(BgmPreset) _then) = _$BgmPresetCopyWithImpl;
@useResult
$Res call({
 String trackId, double volume, Duration fadeIn, bool loops
});




}
/// @nodoc
class _$BgmPresetCopyWithImpl<$Res>
    implements $BgmPresetCopyWith<$Res> {
  _$BgmPresetCopyWithImpl(this._self, this._then);

  final BgmPreset _self;
  final $Res Function(BgmPreset) _then;

/// Create a copy of BgmPreset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? trackId = null,Object? volume = null,Object? fadeIn = null,Object? loops = null,}) {
  return _then(_self.copyWith(
trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,fadeIn: null == fadeIn ? _self.fadeIn : fadeIn // ignore: cast_nullable_to_non_nullable
as Duration,loops: null == loops ? _self.loops : loops // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BgmPreset].
extension BgmPresetPatterns on BgmPreset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BgmPreset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BgmPreset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BgmPreset value)  $default,){
final _that = this;
switch (_that) {
case _BgmPreset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BgmPreset value)?  $default,){
final _that = this;
switch (_that) {
case _BgmPreset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String trackId,  double volume,  Duration fadeIn,  bool loops)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BgmPreset() when $default != null:
return $default(_that.trackId,_that.volume,_that.fadeIn,_that.loops);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String trackId,  double volume,  Duration fadeIn,  bool loops)  $default,) {final _that = this;
switch (_that) {
case _BgmPreset():
return $default(_that.trackId,_that.volume,_that.fadeIn,_that.loops);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String trackId,  double volume,  Duration fadeIn,  bool loops)?  $default,) {final _that = this;
switch (_that) {
case _BgmPreset() when $default != null:
return $default(_that.trackId,_that.volume,_that.fadeIn,_that.loops);case _:
  return null;

}
}

}

/// @nodoc


class _BgmPreset implements BgmPreset {
  const _BgmPreset({required this.trackId, required this.volume, required this.fadeIn, required this.loops}): assert(volume >= 0 && volume <= 1);
  

@override final  String trackId;
@override final  double volume;
@override final  Duration fadeIn;
@override final  bool loops;

/// Create a copy of BgmPreset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BgmPresetCopyWith<_BgmPreset> get copyWith => __$BgmPresetCopyWithImpl<_BgmPreset>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BgmPreset&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.fadeIn, fadeIn) || other.fadeIn == fadeIn)&&(identical(other.loops, loops) || other.loops == loops));
}


@override
int get hashCode => Object.hash(runtimeType,trackId,volume,fadeIn,loops);

@override
String toString() {
  return 'BgmPreset(trackId: $trackId, volume: $volume, fadeIn: $fadeIn, loops: $loops)';
}


}

/// @nodoc
abstract mixin class _$BgmPresetCopyWith<$Res> implements $BgmPresetCopyWith<$Res> {
  factory _$BgmPresetCopyWith(_BgmPreset value, $Res Function(_BgmPreset) _then) = __$BgmPresetCopyWithImpl;
@override @useResult
$Res call({
 String trackId, double volume, Duration fadeIn, bool loops
});




}
/// @nodoc
class __$BgmPresetCopyWithImpl<$Res>
    implements _$BgmPresetCopyWith<$Res> {
  __$BgmPresetCopyWithImpl(this._self, this._then);

  final _BgmPreset _self;
  final $Res Function(_BgmPreset) _then;

/// Create a copy of BgmPreset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trackId = null,Object? volume = null,Object? fadeIn = null,Object? loops = null,}) {
  return _then(_BgmPreset(
trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,fadeIn: null == fadeIn ? _self.fadeIn : fadeIn // ignore: cast_nullable_to_non_nullable
as Duration,loops: null == loops ? _self.loops : loops // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
