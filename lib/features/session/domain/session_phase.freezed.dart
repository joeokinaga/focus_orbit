// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_phase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionPhase {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionPhase);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionPhase()';
}


}

/// @nodoc
class $SessionPhaseCopyWith<$Res>  {
$SessionPhaseCopyWith(SessionPhase _, $Res Function(SessionPhase) __);
}


/// Adds pattern-matching-related methods to [SessionPhase].
extension SessionPhasePatterns on SessionPhase {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Idle value)?  idle,TResult Function( Running value)?  running,TResult Function( Warning value)?  warning,TResult Function( Completed value)?  completed,TResult Function( Aborted value)?  aborted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Idle() when idle != null:
return idle(_that);case Running() when running != null:
return running(_that);case Warning() when warning != null:
return warning(_that);case Completed() when completed != null:
return completed(_that);case Aborted() when aborted != null:
return aborted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Idle value)  idle,required TResult Function( Running value)  running,required TResult Function( Warning value)  warning,required TResult Function( Completed value)  completed,required TResult Function( Aborted value)  aborted,}){
final _that = this;
switch (_that) {
case Idle():
return idle(_that);case Running():
return running(_that);case Warning():
return warning(_that);case Completed():
return completed(_that);case Aborted():
return aborted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Idle value)?  idle,TResult? Function( Running value)?  running,TResult? Function( Warning value)?  warning,TResult? Function( Completed value)?  completed,TResult? Function( Aborted value)?  aborted,}){
final _that = this;
switch (_that) {
case Idle() when idle != null:
return idle(_that);case Running() when running != null:
return running(_that);case Warning() when warning != null:
return warning(_that);case Completed() when completed != null:
return completed(_that);case Aborted() when aborted != null:
return aborted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  running,TResult Function()?  warning,TResult Function( int rewardCoins)?  completed,TResult Function( AbortReason reason)?  aborted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Idle() when idle != null:
return idle();case Running() when running != null:
return running();case Warning() when warning != null:
return warning();case Completed() when completed != null:
return completed(_that.rewardCoins);case Aborted() when aborted != null:
return aborted(_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  running,required TResult Function()  warning,required TResult Function( int rewardCoins)  completed,required TResult Function( AbortReason reason)  aborted,}) {final _that = this;
switch (_that) {
case Idle():
return idle();case Running():
return running();case Warning():
return warning();case Completed():
return completed(_that.rewardCoins);case Aborted():
return aborted(_that.reason);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  running,TResult? Function()?  warning,TResult? Function( int rewardCoins)?  completed,TResult? Function( AbortReason reason)?  aborted,}) {final _that = this;
switch (_that) {
case Idle() when idle != null:
return idle();case Running() when running != null:
return running();case Warning() when warning != null:
return warning();case Completed() when completed != null:
return completed(_that.rewardCoins);case Aborted() when aborted != null:
return aborted(_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class Idle implements SessionPhase {
  const Idle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Idle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionPhase.idle()';
}


}




/// @nodoc


class Running implements SessionPhase {
  const Running();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Running);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionPhase.running()';
}


}




/// @nodoc


class Warning implements SessionPhase {
  const Warning();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Warning);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionPhase.warning()';
}


}




/// @nodoc


class Completed implements SessionPhase {
  const Completed({required this.rewardCoins});
  

 final  int rewardCoins;

/// Create a copy of SessionPhase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompletedCopyWith<Completed> get copyWith => _$CompletedCopyWithImpl<Completed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Completed&&(identical(other.rewardCoins, rewardCoins) || other.rewardCoins == rewardCoins));
}


@override
int get hashCode => Object.hash(runtimeType,rewardCoins);

@override
String toString() {
  return 'SessionPhase.completed(rewardCoins: $rewardCoins)';
}


}

/// @nodoc
abstract mixin class $CompletedCopyWith<$Res> implements $SessionPhaseCopyWith<$Res> {
  factory $CompletedCopyWith(Completed value, $Res Function(Completed) _then) = _$CompletedCopyWithImpl;
@useResult
$Res call({
 int rewardCoins
});




}
/// @nodoc
class _$CompletedCopyWithImpl<$Res>
    implements $CompletedCopyWith<$Res> {
  _$CompletedCopyWithImpl(this._self, this._then);

  final Completed _self;
  final $Res Function(Completed) _then;

/// Create a copy of SessionPhase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? rewardCoins = null,}) {
  return _then(Completed(
rewardCoins: null == rewardCoins ? _self.rewardCoins : rewardCoins // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class Aborted implements SessionPhase {
  const Aborted({required this.reason});
  

 final  AbortReason reason;

/// Create a copy of SessionPhase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AbortedCopyWith<Aborted> get copyWith => _$AbortedCopyWithImpl<Aborted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Aborted&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'SessionPhase.aborted(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $AbortedCopyWith<$Res> implements $SessionPhaseCopyWith<$Res> {
  factory $AbortedCopyWith(Aborted value, $Res Function(Aborted) _then) = _$AbortedCopyWithImpl;
@useResult
$Res call({
 AbortReason reason
});




}
/// @nodoc
class _$AbortedCopyWithImpl<$Res>
    implements $AbortedCopyWith<$Res> {
  _$AbortedCopyWithImpl(this._self, this._then);

  final Aborted _self;
  final $Res Function(Aborted) _then;

/// Create a copy of SessionPhase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,}) {
  return _then(Aborted(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as AbortReason,
  ));
}


}

// dart format on
