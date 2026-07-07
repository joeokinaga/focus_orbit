// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unlock_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UnlockState {

 Set<MotifId> get unlockedIds;
/// Create a copy of UnlockState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnlockStateCopyWith<UnlockState> get copyWith => _$UnlockStateCopyWithImpl<UnlockState>(this as UnlockState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnlockState&&const DeepCollectionEquality().equals(other.unlockedIds, unlockedIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(unlockedIds));

@override
String toString() {
  return 'UnlockState(unlockedIds: $unlockedIds)';
}


}

/// @nodoc
abstract mixin class $UnlockStateCopyWith<$Res>  {
  factory $UnlockStateCopyWith(UnlockState value, $Res Function(UnlockState) _then) = _$UnlockStateCopyWithImpl;
@useResult
$Res call({
 Set<MotifId> unlockedIds
});




}
/// @nodoc
class _$UnlockStateCopyWithImpl<$Res>
    implements $UnlockStateCopyWith<$Res> {
  _$UnlockStateCopyWithImpl(this._self, this._then);

  final UnlockState _self;
  final $Res Function(UnlockState) _then;

/// Create a copy of UnlockState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? unlockedIds = null,}) {
  return _then(_self.copyWith(
unlockedIds: null == unlockedIds ? _self.unlockedIds : unlockedIds // ignore: cast_nullable_to_non_nullable
as Set<MotifId>,
  ));
}

}


/// Adds pattern-matching-related methods to [UnlockState].
extension UnlockStatePatterns on UnlockState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnlockState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnlockState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnlockState value)  $default,){
final _that = this;
switch (_that) {
case _UnlockState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnlockState value)?  $default,){
final _that = this;
switch (_that) {
case _UnlockState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<MotifId> unlockedIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnlockState() when $default != null:
return $default(_that.unlockedIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<MotifId> unlockedIds)  $default,) {final _that = this;
switch (_that) {
case _UnlockState():
return $default(_that.unlockedIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<MotifId> unlockedIds)?  $default,) {final _that = this;
switch (_that) {
case _UnlockState() when $default != null:
return $default(_that.unlockedIds);case _:
  return null;

}
}

}

/// @nodoc


class _UnlockState extends UnlockState {
  const _UnlockState({required final  Set<MotifId> unlockedIds}): _unlockedIds = unlockedIds,super._();
  

 final  Set<MotifId> _unlockedIds;
@override Set<MotifId> get unlockedIds {
  if (_unlockedIds is EqualUnmodifiableSetView) return _unlockedIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_unlockedIds);
}


/// Create a copy of UnlockState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnlockStateCopyWith<_UnlockState> get copyWith => __$UnlockStateCopyWithImpl<_UnlockState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnlockState&&const DeepCollectionEquality().equals(other._unlockedIds, _unlockedIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_unlockedIds));

@override
String toString() {
  return 'UnlockState(unlockedIds: $unlockedIds)';
}


}

/// @nodoc
abstract mixin class _$UnlockStateCopyWith<$Res> implements $UnlockStateCopyWith<$Res> {
  factory _$UnlockStateCopyWith(_UnlockState value, $Res Function(_UnlockState) _then) = __$UnlockStateCopyWithImpl;
@override @useResult
$Res call({
 Set<MotifId> unlockedIds
});




}
/// @nodoc
class __$UnlockStateCopyWithImpl<$Res>
    implements _$UnlockStateCopyWith<$Res> {
  __$UnlockStateCopyWithImpl(this._self, this._then);

  final _UnlockState _self;
  final $Res Function(_UnlockState) _then;

/// Create a copy of UnlockState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? unlockedIds = null,}) {
  return _then(_UnlockState(
unlockedIds: null == unlockedIds ? _self._unlockedIds : unlockedIds // ignore: cast_nullable_to_non_nullable
as Set<MotifId>,
  ));
}


}

// dart format on
