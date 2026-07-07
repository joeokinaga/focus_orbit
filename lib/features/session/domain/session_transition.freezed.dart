// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_transition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionEvent()';
}


}

/// @nodoc
class $SessionEventCopyWith<$Res>  {
$SessionEventCopyWith(SessionEvent _, $Res Function(SessionEvent) __);
}


/// Adds pattern-matching-related methods to [SessionEvent].
extension SessionEventPatterns on SessionEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StartRequested value)?  startRequested,TResult Function( StanceChanged value)?  stanceChanged,TResult Function( GraceTimeout value)?  graceTimeout,TResult Function( TimerCompleted value)?  timerCompleted,TResult Function( UserCancelled value)?  userCancelled,TResult Function( SystemInterrupted value)?  systemInterrupted,TResult Function( RewardClaimed value)?  rewardClaimed,TResult Function( Acknowledged value)?  acknowledged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StartRequested() when startRequested != null:
return startRequested(_that);case StanceChanged() when stanceChanged != null:
return stanceChanged(_that);case GraceTimeout() when graceTimeout != null:
return graceTimeout(_that);case TimerCompleted() when timerCompleted != null:
return timerCompleted(_that);case UserCancelled() when userCancelled != null:
return userCancelled(_that);case SystemInterrupted() when systemInterrupted != null:
return systemInterrupted(_that);case RewardClaimed() when rewardClaimed != null:
return rewardClaimed(_that);case Acknowledged() when acknowledged != null:
return acknowledged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StartRequested value)  startRequested,required TResult Function( StanceChanged value)  stanceChanged,required TResult Function( GraceTimeout value)  graceTimeout,required TResult Function( TimerCompleted value)  timerCompleted,required TResult Function( UserCancelled value)  userCancelled,required TResult Function( SystemInterrupted value)  systemInterrupted,required TResult Function( RewardClaimed value)  rewardClaimed,required TResult Function( Acknowledged value)  acknowledged,}){
final _that = this;
switch (_that) {
case StartRequested():
return startRequested(_that);case StanceChanged():
return stanceChanged(_that);case GraceTimeout():
return graceTimeout(_that);case TimerCompleted():
return timerCompleted(_that);case UserCancelled():
return userCancelled(_that);case SystemInterrupted():
return systemInterrupted(_that);case RewardClaimed():
return rewardClaimed(_that);case Acknowledged():
return acknowledged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StartRequested value)?  startRequested,TResult? Function( StanceChanged value)?  stanceChanged,TResult? Function( GraceTimeout value)?  graceTimeout,TResult? Function( TimerCompleted value)?  timerCompleted,TResult? Function( UserCancelled value)?  userCancelled,TResult? Function( SystemInterrupted value)?  systemInterrupted,TResult? Function( RewardClaimed value)?  rewardClaimed,TResult? Function( Acknowledged value)?  acknowledged,}){
final _that = this;
switch (_that) {
case StartRequested() when startRequested != null:
return startRequested(_that);case StanceChanged() when stanceChanged != null:
return stanceChanged(_that);case GraceTimeout() when graceTimeout != null:
return graceTimeout(_that);case TimerCompleted() when timerCompleted != null:
return timerCompleted(_that);case UserCancelled() when userCancelled != null:
return userCancelled(_that);case SystemInterrupted() when systemInterrupted != null:
return systemInterrupted(_that);case RewardClaimed() when rewardClaimed != null:
return rewardClaimed(_that);case Acknowledged() when acknowledged != null:
return acknowledged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  startRequested,TResult Function( DeviceStance stance)?  stanceChanged,TResult Function()?  graceTimeout,TResult Function( int rewardCoins)?  timerCompleted,TResult Function()?  userCancelled,TResult Function()?  systemInterrupted,TResult Function()?  rewardClaimed,TResult Function()?  acknowledged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StartRequested() when startRequested != null:
return startRequested();case StanceChanged() when stanceChanged != null:
return stanceChanged(_that.stance);case GraceTimeout() when graceTimeout != null:
return graceTimeout();case TimerCompleted() when timerCompleted != null:
return timerCompleted(_that.rewardCoins);case UserCancelled() when userCancelled != null:
return userCancelled();case SystemInterrupted() when systemInterrupted != null:
return systemInterrupted();case RewardClaimed() when rewardClaimed != null:
return rewardClaimed();case Acknowledged() when acknowledged != null:
return acknowledged();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  startRequested,required TResult Function( DeviceStance stance)  stanceChanged,required TResult Function()  graceTimeout,required TResult Function( int rewardCoins)  timerCompleted,required TResult Function()  userCancelled,required TResult Function()  systemInterrupted,required TResult Function()  rewardClaimed,required TResult Function()  acknowledged,}) {final _that = this;
switch (_that) {
case StartRequested():
return startRequested();case StanceChanged():
return stanceChanged(_that.stance);case GraceTimeout():
return graceTimeout();case TimerCompleted():
return timerCompleted(_that.rewardCoins);case UserCancelled():
return userCancelled();case SystemInterrupted():
return systemInterrupted();case RewardClaimed():
return rewardClaimed();case Acknowledged():
return acknowledged();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  startRequested,TResult? Function( DeviceStance stance)?  stanceChanged,TResult? Function()?  graceTimeout,TResult? Function( int rewardCoins)?  timerCompleted,TResult? Function()?  userCancelled,TResult? Function()?  systemInterrupted,TResult? Function()?  rewardClaimed,TResult? Function()?  acknowledged,}) {final _that = this;
switch (_that) {
case StartRequested() when startRequested != null:
return startRequested();case StanceChanged() when stanceChanged != null:
return stanceChanged(_that.stance);case GraceTimeout() when graceTimeout != null:
return graceTimeout();case TimerCompleted() when timerCompleted != null:
return timerCompleted(_that.rewardCoins);case UserCancelled() when userCancelled != null:
return userCancelled();case SystemInterrupted() when systemInterrupted != null:
return systemInterrupted();case RewardClaimed() when rewardClaimed != null:
return rewardClaimed();case Acknowledged() when acknowledged != null:
return acknowledged();case _:
  return null;

}
}

}

/// @nodoc


class StartRequested implements SessionEvent {
  const StartRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionEvent.startRequested()';
}


}




/// @nodoc


class StanceChanged implements SessionEvent {
  const StanceChanged(this.stance);
  

 final  DeviceStance stance;

/// Create a copy of SessionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StanceChangedCopyWith<StanceChanged> get copyWith => _$StanceChangedCopyWithImpl<StanceChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StanceChanged&&(identical(other.stance, stance) || other.stance == stance));
}


@override
int get hashCode => Object.hash(runtimeType,stance);

@override
String toString() {
  return 'SessionEvent.stanceChanged(stance: $stance)';
}


}

/// @nodoc
abstract mixin class $StanceChangedCopyWith<$Res> implements $SessionEventCopyWith<$Res> {
  factory $StanceChangedCopyWith(StanceChanged value, $Res Function(StanceChanged) _then) = _$StanceChangedCopyWithImpl;
@useResult
$Res call({
 DeviceStance stance
});


$DeviceStanceCopyWith<$Res> get stance;

}
/// @nodoc
class _$StanceChangedCopyWithImpl<$Res>
    implements $StanceChangedCopyWith<$Res> {
  _$StanceChangedCopyWithImpl(this._self, this._then);

  final StanceChanged _self;
  final $Res Function(StanceChanged) _then;

/// Create a copy of SessionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? stance = null,}) {
  return _then(StanceChanged(
null == stance ? _self.stance : stance // ignore: cast_nullable_to_non_nullable
as DeviceStance,
  ));
}

/// Create a copy of SessionEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceStanceCopyWith<$Res> get stance {
  
  return $DeviceStanceCopyWith<$Res>(_self.stance, (value) {
    return _then(_self.copyWith(stance: value));
  });
}
}

/// @nodoc


class GraceTimeout implements SessionEvent {
  const GraceTimeout();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GraceTimeout);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionEvent.graceTimeout()';
}


}




/// @nodoc


class TimerCompleted implements SessionEvent {
  const TimerCompleted({required this.rewardCoins});
  

 final  int rewardCoins;

/// Create a copy of SessionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimerCompletedCopyWith<TimerCompleted> get copyWith => _$TimerCompletedCopyWithImpl<TimerCompleted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimerCompleted&&(identical(other.rewardCoins, rewardCoins) || other.rewardCoins == rewardCoins));
}


@override
int get hashCode => Object.hash(runtimeType,rewardCoins);

@override
String toString() {
  return 'SessionEvent.timerCompleted(rewardCoins: $rewardCoins)';
}


}

/// @nodoc
abstract mixin class $TimerCompletedCopyWith<$Res> implements $SessionEventCopyWith<$Res> {
  factory $TimerCompletedCopyWith(TimerCompleted value, $Res Function(TimerCompleted) _then) = _$TimerCompletedCopyWithImpl;
@useResult
$Res call({
 int rewardCoins
});




}
/// @nodoc
class _$TimerCompletedCopyWithImpl<$Res>
    implements $TimerCompletedCopyWith<$Res> {
  _$TimerCompletedCopyWithImpl(this._self, this._then);

  final TimerCompleted _self;
  final $Res Function(TimerCompleted) _then;

/// Create a copy of SessionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? rewardCoins = null,}) {
  return _then(TimerCompleted(
rewardCoins: null == rewardCoins ? _self.rewardCoins : rewardCoins // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class UserCancelled implements SessionEvent {
  const UserCancelled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserCancelled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionEvent.userCancelled()';
}


}




/// @nodoc


class SystemInterrupted implements SessionEvent {
  const SystemInterrupted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SystemInterrupted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionEvent.systemInterrupted()';
}


}




/// @nodoc


class RewardClaimed implements SessionEvent {
  const RewardClaimed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RewardClaimed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionEvent.rewardClaimed()';
}


}




/// @nodoc


class Acknowledged implements SessionEvent {
  const Acknowledged();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Acknowledged);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionEvent.acknowledged()';
}


}




// dart format on
