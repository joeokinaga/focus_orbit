// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_stance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeviceStance {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceStance);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DeviceStance()';
}


}

/// @nodoc
class $DeviceStanceCopyWith<$Res>  {
$DeviceStanceCopyWith(DeviceStance _, $Res Function(DeviceStance) __);
}


/// Adds pattern-matching-related methods to [DeviceStance].
extension DeviceStancePatterns on DeviceStance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FaceUpStill value)?  faceUpStill,TResult Function( MicroVibration value)?  microVibration,TResult Function( Lifted value)?  lifted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FaceUpStill() when faceUpStill != null:
return faceUpStill(_that);case MicroVibration() when microVibration != null:
return microVibration(_that);case Lifted() when lifted != null:
return lifted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FaceUpStill value)  faceUpStill,required TResult Function( MicroVibration value)  microVibration,required TResult Function( Lifted value)  lifted,}){
final _that = this;
switch (_that) {
case FaceUpStill():
return faceUpStill(_that);case MicroVibration():
return microVibration(_that);case Lifted():
return lifted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FaceUpStill value)?  faceUpStill,TResult? Function( MicroVibration value)?  microVibration,TResult? Function( Lifted value)?  lifted,}){
final _that = this;
switch (_that) {
case FaceUpStill() when faceUpStill != null:
return faceUpStill(_that);case MicroVibration() when microVibration != null:
return microVibration(_that);case Lifted() when lifted != null:
return lifted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  faceUpStill,TResult Function( double rms)?  microVibration,TResult Function()?  lifted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FaceUpStill() when faceUpStill != null:
return faceUpStill();case MicroVibration() when microVibration != null:
return microVibration(_that.rms);case Lifted() when lifted != null:
return lifted();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  faceUpStill,required TResult Function( double rms)  microVibration,required TResult Function()  lifted,}) {final _that = this;
switch (_that) {
case FaceUpStill():
return faceUpStill();case MicroVibration():
return microVibration(_that.rms);case Lifted():
return lifted();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  faceUpStill,TResult? Function( double rms)?  microVibration,TResult? Function()?  lifted,}) {final _that = this;
switch (_that) {
case FaceUpStill() when faceUpStill != null:
return faceUpStill();case MicroVibration() when microVibration != null:
return microVibration(_that.rms);case Lifted() when lifted != null:
return lifted();case _:
  return null;

}
}

}

/// @nodoc


class FaceUpStill implements DeviceStance {
  const FaceUpStill();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaceUpStill);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DeviceStance.faceUpStill()';
}


}




/// @nodoc


class MicroVibration implements DeviceStance {
  const MicroVibration({required this.rms});
  

 final  double rms;

/// Create a copy of DeviceStance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MicroVibrationCopyWith<MicroVibration> get copyWith => _$MicroVibrationCopyWithImpl<MicroVibration>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MicroVibration&&(identical(other.rms, rms) || other.rms == rms));
}


@override
int get hashCode => Object.hash(runtimeType,rms);

@override
String toString() {
  return 'DeviceStance.microVibration(rms: $rms)';
}


}

/// @nodoc
abstract mixin class $MicroVibrationCopyWith<$Res> implements $DeviceStanceCopyWith<$Res> {
  factory $MicroVibrationCopyWith(MicroVibration value, $Res Function(MicroVibration) _then) = _$MicroVibrationCopyWithImpl;
@useResult
$Res call({
 double rms
});




}
/// @nodoc
class _$MicroVibrationCopyWithImpl<$Res>
    implements $MicroVibrationCopyWith<$Res> {
  _$MicroVibrationCopyWithImpl(this._self, this._then);

  final MicroVibration _self;
  final $Res Function(MicroVibration) _then;

/// Create a copy of DeviceStance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? rms = null,}) {
  return _then(MicroVibration(
rms: null == rms ? _self.rms : rms // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class Lifted implements DeviceStance {
  const Lifted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Lifted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DeviceStance.lifted()';
}


}




// dart format on
