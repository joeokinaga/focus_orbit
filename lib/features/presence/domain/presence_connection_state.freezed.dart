// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'presence_connection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PresenceConnectionState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PresenceConnectionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PresenceConnectionState()';
}


}

/// @nodoc
class $PresenceConnectionStateCopyWith<$Res>  {
$PresenceConnectionStateCopyWith(PresenceConnectionState _, $Res Function(PresenceConnectionState) __);
}


/// Adds pattern-matching-related methods to [PresenceConnectionState].
extension PresenceConnectionStatePatterns on PresenceConnectionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Connected value)?  connected,TResult Function( Reconnecting value)?  reconnecting,TResult Function( SoloFallback value)?  soloFallback,TResult Function( Disconnected value)?  disconnected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Connected() when connected != null:
return connected(_that);case Reconnecting() when reconnecting != null:
return reconnecting(_that);case SoloFallback() when soloFallback != null:
return soloFallback(_that);case Disconnected() when disconnected != null:
return disconnected(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Connected value)  connected,required TResult Function( Reconnecting value)  reconnecting,required TResult Function( SoloFallback value)  soloFallback,required TResult Function( Disconnected value)  disconnected,}){
final _that = this;
switch (_that) {
case Connected():
return connected(_that);case Reconnecting():
return reconnecting(_that);case SoloFallback():
return soloFallback(_that);case Disconnected():
return disconnected(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Connected value)?  connected,TResult? Function( Reconnecting value)?  reconnecting,TResult? Function( SoloFallback value)?  soloFallback,TResult? Function( Disconnected value)?  disconnected,}){
final _that = this;
switch (_that) {
case Connected() when connected != null:
return connected(_that);case Reconnecting() when reconnecting != null:
return reconnecting(_that);case SoloFallback() when soloFallback != null:
return soloFallback(_that);case Disconnected() when disconnected != null:
return disconnected(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  connected,TResult Function()?  reconnecting,TResult Function()?  soloFallback,TResult Function()?  disconnected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Connected() when connected != null:
return connected();case Reconnecting() when reconnecting != null:
return reconnecting();case SoloFallback() when soloFallback != null:
return soloFallback();case Disconnected() when disconnected != null:
return disconnected();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  connected,required TResult Function()  reconnecting,required TResult Function()  soloFallback,required TResult Function()  disconnected,}) {final _that = this;
switch (_that) {
case Connected():
return connected();case Reconnecting():
return reconnecting();case SoloFallback():
return soloFallback();case Disconnected():
return disconnected();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  connected,TResult? Function()?  reconnecting,TResult? Function()?  soloFallback,TResult? Function()?  disconnected,}) {final _that = this;
switch (_that) {
case Connected() when connected != null:
return connected();case Reconnecting() when reconnecting != null:
return reconnecting();case SoloFallback() when soloFallback != null:
return soloFallback();case Disconnected() when disconnected != null:
return disconnected();case _:
  return null;

}
}

}

/// @nodoc


class Connected implements PresenceConnectionState {
  const Connected();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Connected);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PresenceConnectionState.connected()';
}


}




/// @nodoc


class Reconnecting implements PresenceConnectionState {
  const Reconnecting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Reconnecting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PresenceConnectionState.reconnecting()';
}


}




/// @nodoc


class SoloFallback implements PresenceConnectionState {
  const SoloFallback();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SoloFallback);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PresenceConnectionState.soloFallback()';
}


}




/// @nodoc


class Disconnected implements PresenceConnectionState {
  const Disconnected();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Disconnected);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PresenceConnectionState.disconnected()';
}


}




// dart format on
