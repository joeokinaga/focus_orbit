// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'focus_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FocusSession {

 SessionId get id; Duration get plannedDuration;/// 進行(tick)は遷移ではないため、elapsedの更新はSessionControllerが
/// copyWithで行う(D12)。
 Duration get elapsed; SessionPhase get phase; MotifId get motifId; SyncMode get syncMode;
/// Create a copy of FocusSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FocusSessionCopyWith<FocusSession> get copyWith => _$FocusSessionCopyWithImpl<FocusSession>(this as FocusSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FocusSession&&(identical(other.id, id) || other.id == id)&&(identical(other.plannedDuration, plannedDuration) || other.plannedDuration == plannedDuration)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.motifId, motifId) || other.motifId == motifId)&&(identical(other.syncMode, syncMode) || other.syncMode == syncMode));
}


@override
int get hashCode => Object.hash(runtimeType,id,plannedDuration,elapsed,phase,motifId,syncMode);

@override
String toString() {
  return 'FocusSession(id: $id, plannedDuration: $plannedDuration, elapsed: $elapsed, phase: $phase, motifId: $motifId, syncMode: $syncMode)';
}


}

/// @nodoc
abstract mixin class $FocusSessionCopyWith<$Res>  {
  factory $FocusSessionCopyWith(FocusSession value, $Res Function(FocusSession) _then) = _$FocusSessionCopyWithImpl;
@useResult
$Res call({
 SessionId id, Duration plannedDuration, Duration elapsed, SessionPhase phase, MotifId motifId, SyncMode syncMode
});


$SessionPhaseCopyWith<$Res> get phase;

}
/// @nodoc
class _$FocusSessionCopyWithImpl<$Res>
    implements $FocusSessionCopyWith<$Res> {
  _$FocusSessionCopyWithImpl(this._self, this._then);

  final FocusSession _self;
  final $Res Function(FocusSession) _then;

/// Create a copy of FocusSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? plannedDuration = null,Object? elapsed = null,Object? phase = null,Object? motifId = null,Object? syncMode = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as SessionId,plannedDuration: null == plannedDuration ? _self.plannedDuration : plannedDuration // ignore: cast_nullable_to_non_nullable
as Duration,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as Duration,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as SessionPhase,motifId: null == motifId ? _self.motifId : motifId // ignore: cast_nullable_to_non_nullable
as MotifId,syncMode: null == syncMode ? _self.syncMode : syncMode // ignore: cast_nullable_to_non_nullable
as SyncMode,
  ));
}
/// Create a copy of FocusSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionPhaseCopyWith<$Res> get phase {
  
  return $SessionPhaseCopyWith<$Res>(_self.phase, (value) {
    return _then(_self.copyWith(phase: value));
  });
}
}


/// Adds pattern-matching-related methods to [FocusSession].
extension FocusSessionPatterns on FocusSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FocusSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FocusSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FocusSession value)  $default,){
final _that = this;
switch (_that) {
case _FocusSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FocusSession value)?  $default,){
final _that = this;
switch (_that) {
case _FocusSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SessionId id,  Duration plannedDuration,  Duration elapsed,  SessionPhase phase,  MotifId motifId,  SyncMode syncMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FocusSession() when $default != null:
return $default(_that.id,_that.plannedDuration,_that.elapsed,_that.phase,_that.motifId,_that.syncMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SessionId id,  Duration plannedDuration,  Duration elapsed,  SessionPhase phase,  MotifId motifId,  SyncMode syncMode)  $default,) {final _that = this;
switch (_that) {
case _FocusSession():
return $default(_that.id,_that.plannedDuration,_that.elapsed,_that.phase,_that.motifId,_that.syncMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SessionId id,  Duration plannedDuration,  Duration elapsed,  SessionPhase phase,  MotifId motifId,  SyncMode syncMode)?  $default,) {final _that = this;
switch (_that) {
case _FocusSession() when $default != null:
return $default(_that.id,_that.plannedDuration,_that.elapsed,_that.phase,_that.motifId,_that.syncMode);case _:
  return null;

}
}

}

/// @nodoc


class _FocusSession implements FocusSession {
  const _FocusSession({required this.id, required this.plannedDuration, required this.elapsed, required this.phase, required this.motifId, required this.syncMode});
  

@override final  SessionId id;
@override final  Duration plannedDuration;
/// 進行(tick)は遷移ではないため、elapsedの更新はSessionControllerが
/// copyWithで行う(D12)。
@override final  Duration elapsed;
@override final  SessionPhase phase;
@override final  MotifId motifId;
@override final  SyncMode syncMode;

/// Create a copy of FocusSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FocusSessionCopyWith<_FocusSession> get copyWith => __$FocusSessionCopyWithImpl<_FocusSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FocusSession&&(identical(other.id, id) || other.id == id)&&(identical(other.plannedDuration, plannedDuration) || other.plannedDuration == plannedDuration)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.motifId, motifId) || other.motifId == motifId)&&(identical(other.syncMode, syncMode) || other.syncMode == syncMode));
}


@override
int get hashCode => Object.hash(runtimeType,id,plannedDuration,elapsed,phase,motifId,syncMode);

@override
String toString() {
  return 'FocusSession(id: $id, plannedDuration: $plannedDuration, elapsed: $elapsed, phase: $phase, motifId: $motifId, syncMode: $syncMode)';
}


}

/// @nodoc
abstract mixin class _$FocusSessionCopyWith<$Res> implements $FocusSessionCopyWith<$Res> {
  factory _$FocusSessionCopyWith(_FocusSession value, $Res Function(_FocusSession) _then) = __$FocusSessionCopyWithImpl;
@override @useResult
$Res call({
 SessionId id, Duration plannedDuration, Duration elapsed, SessionPhase phase, MotifId motifId, SyncMode syncMode
});


@override $SessionPhaseCopyWith<$Res> get phase;

}
/// @nodoc
class __$FocusSessionCopyWithImpl<$Res>
    implements _$FocusSessionCopyWith<$Res> {
  __$FocusSessionCopyWithImpl(this._self, this._then);

  final _FocusSession _self;
  final $Res Function(_FocusSession) _then;

/// Create a copy of FocusSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? plannedDuration = null,Object? elapsed = null,Object? phase = null,Object? motifId = null,Object? syncMode = null,}) {
  return _then(_FocusSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as SessionId,plannedDuration: null == plannedDuration ? _self.plannedDuration : plannedDuration // ignore: cast_nullable_to_non_nullable
as Duration,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as Duration,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as SessionPhase,motifId: null == motifId ? _self.motifId : motifId // ignore: cast_nullable_to_non_nullable
as MotifId,syncMode: null == syncMode ? _self.syncMode : syncMode // ignore: cast_nullable_to_non_nullable
as SyncMode,
  ));
}

/// Create a copy of FocusSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionPhaseCopyWith<$Res> get phase {
  
  return $SessionPhaseCopyWith<$Res>(_self.phase, (value) {
    return _then(_self.copyWith(phase: value));
  });
}
}

// dart format on
