// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'economy_ledger.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EconomyState {

 Wallet get wallet; UnlockState get unlocks;/// 永続台帳(drift, T7)のインメモリ射影。べき等性の真実はDBのUNIQUE制約。
 Set<String> get appliedKeys;
/// Create a copy of EconomyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EconomyStateCopyWith<EconomyState> get copyWith => _$EconomyStateCopyWithImpl<EconomyState>(this as EconomyState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EconomyState&&(identical(other.wallet, wallet) || other.wallet == wallet)&&(identical(other.unlocks, unlocks) || other.unlocks == unlocks)&&const DeepCollectionEquality().equals(other.appliedKeys, appliedKeys));
}


@override
int get hashCode => Object.hash(runtimeType,wallet,unlocks,const DeepCollectionEquality().hash(appliedKeys));

@override
String toString() {
  return 'EconomyState(wallet: $wallet, unlocks: $unlocks, appliedKeys: $appliedKeys)';
}


}

/// @nodoc
abstract mixin class $EconomyStateCopyWith<$Res>  {
  factory $EconomyStateCopyWith(EconomyState value, $Res Function(EconomyState) _then) = _$EconomyStateCopyWithImpl;
@useResult
$Res call({
 Wallet wallet, UnlockState unlocks, Set<String> appliedKeys
});


$WalletCopyWith<$Res> get wallet;$UnlockStateCopyWith<$Res> get unlocks;

}
/// @nodoc
class _$EconomyStateCopyWithImpl<$Res>
    implements $EconomyStateCopyWith<$Res> {
  _$EconomyStateCopyWithImpl(this._self, this._then);

  final EconomyState _self;
  final $Res Function(EconomyState) _then;

/// Create a copy of EconomyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wallet = null,Object? unlocks = null,Object? appliedKeys = null,}) {
  return _then(_self.copyWith(
wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as Wallet,unlocks: null == unlocks ? _self.unlocks : unlocks // ignore: cast_nullable_to_non_nullable
as UnlockState,appliedKeys: null == appliedKeys ? _self.appliedKeys : appliedKeys // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}
/// Create a copy of EconomyState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletCopyWith<$Res> get wallet {
  
  return $WalletCopyWith<$Res>(_self.wallet, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}/// Create a copy of EconomyState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnlockStateCopyWith<$Res> get unlocks {
  
  return $UnlockStateCopyWith<$Res>(_self.unlocks, (value) {
    return _then(_self.copyWith(unlocks: value));
  });
}
}


/// Adds pattern-matching-related methods to [EconomyState].
extension EconomyStatePatterns on EconomyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EconomyState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EconomyState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EconomyState value)  $default,){
final _that = this;
switch (_that) {
case _EconomyState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EconomyState value)?  $default,){
final _that = this;
switch (_that) {
case _EconomyState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Wallet wallet,  UnlockState unlocks,  Set<String> appliedKeys)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EconomyState() when $default != null:
return $default(_that.wallet,_that.unlocks,_that.appliedKeys);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Wallet wallet,  UnlockState unlocks,  Set<String> appliedKeys)  $default,) {final _that = this;
switch (_that) {
case _EconomyState():
return $default(_that.wallet,_that.unlocks,_that.appliedKeys);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Wallet wallet,  UnlockState unlocks,  Set<String> appliedKeys)?  $default,) {final _that = this;
switch (_that) {
case _EconomyState() when $default != null:
return $default(_that.wallet,_that.unlocks,_that.appliedKeys);case _:
  return null;

}
}

}

/// @nodoc


class _EconomyState implements EconomyState {
  const _EconomyState({required this.wallet, required this.unlocks, required final  Set<String> appliedKeys}): _appliedKeys = appliedKeys;
  

@override final  Wallet wallet;
@override final  UnlockState unlocks;
/// 永続台帳(drift, T7)のインメモリ射影。べき等性の真実はDBのUNIQUE制約。
 final  Set<String> _appliedKeys;
/// 永続台帳(drift, T7)のインメモリ射影。べき等性の真実はDBのUNIQUE制約。
@override Set<String> get appliedKeys {
  if (_appliedKeys is EqualUnmodifiableSetView) return _appliedKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_appliedKeys);
}


/// Create a copy of EconomyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EconomyStateCopyWith<_EconomyState> get copyWith => __$EconomyStateCopyWithImpl<_EconomyState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EconomyState&&(identical(other.wallet, wallet) || other.wallet == wallet)&&(identical(other.unlocks, unlocks) || other.unlocks == unlocks)&&const DeepCollectionEquality().equals(other._appliedKeys, _appliedKeys));
}


@override
int get hashCode => Object.hash(runtimeType,wallet,unlocks,const DeepCollectionEquality().hash(_appliedKeys));

@override
String toString() {
  return 'EconomyState(wallet: $wallet, unlocks: $unlocks, appliedKeys: $appliedKeys)';
}


}

/// @nodoc
abstract mixin class _$EconomyStateCopyWith<$Res> implements $EconomyStateCopyWith<$Res> {
  factory _$EconomyStateCopyWith(_EconomyState value, $Res Function(_EconomyState) _then) = __$EconomyStateCopyWithImpl;
@override @useResult
$Res call({
 Wallet wallet, UnlockState unlocks, Set<String> appliedKeys
});


@override $WalletCopyWith<$Res> get wallet;@override $UnlockStateCopyWith<$Res> get unlocks;

}
/// @nodoc
class __$EconomyStateCopyWithImpl<$Res>
    implements _$EconomyStateCopyWith<$Res> {
  __$EconomyStateCopyWithImpl(this._self, this._then);

  final _EconomyState _self;
  final $Res Function(_EconomyState) _then;

/// Create a copy of EconomyState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wallet = null,Object? unlocks = null,Object? appliedKeys = null,}) {
  return _then(_EconomyState(
wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as Wallet,unlocks: null == unlocks ? _self.unlocks : unlocks // ignore: cast_nullable_to_non_nullable
as UnlockState,appliedKeys: null == appliedKeys ? _self._appliedKeys : appliedKeys // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

/// Create a copy of EconomyState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletCopyWith<$Res> get wallet {
  
  return $WalletCopyWith<$Res>(_self.wallet, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}/// Create a copy of EconomyState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnlockStateCopyWith<$Res> get unlocks {
  
  return $UnlockStateCopyWith<$Res>(_self.unlocks, (value) {
    return _then(_self.copyWith(unlocks: value));
  });
}
}

// dart format on
