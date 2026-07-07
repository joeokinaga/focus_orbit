// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coin_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoinTransaction {

 String get idempotencyKey; int get amount; DateTime get occurredAt;
/// Create a copy of CoinTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoinTransactionCopyWith<CoinTransaction> get copyWith => _$CoinTransactionCopyWithImpl<CoinTransaction>(this as CoinTransaction, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoinTransaction&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}


@override
int get hashCode => Object.hash(runtimeType,idempotencyKey,amount,occurredAt);

@override
String toString() {
  return 'CoinTransaction(idempotencyKey: $idempotencyKey, amount: $amount, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class $CoinTransactionCopyWith<$Res>  {
  factory $CoinTransactionCopyWith(CoinTransaction value, $Res Function(CoinTransaction) _then) = _$CoinTransactionCopyWithImpl;
@useResult
$Res call({
 String idempotencyKey, int amount, DateTime occurredAt
});




}
/// @nodoc
class _$CoinTransactionCopyWithImpl<$Res>
    implements $CoinTransactionCopyWith<$Res> {
  _$CoinTransactionCopyWithImpl(this._self, this._then);

  final CoinTransaction _self;
  final $Res Function(CoinTransaction) _then;

/// Create a copy of CoinTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idempotencyKey = null,Object? amount = null,Object? occurredAt = null,}) {
  return _then(_self.copyWith(
idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CoinTransaction].
extension CoinTransactionPatterns on CoinTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Earn value)?  earn,TResult Function( SpendUnlock value)?  spendUnlock,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Earn() when earn != null:
return earn(_that);case SpendUnlock() when spendUnlock != null:
return spendUnlock(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Earn value)  earn,required TResult Function( SpendUnlock value)  spendUnlock,}){
final _that = this;
switch (_that) {
case Earn():
return earn(_that);case SpendUnlock():
return spendUnlock(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Earn value)?  earn,TResult? Function( SpendUnlock value)?  spendUnlock,}){
final _that = this;
switch (_that) {
case Earn() when earn != null:
return earn(_that);case SpendUnlock() when spendUnlock != null:
return spendUnlock(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String idempotencyKey,  int amount,  DateTime occurredAt)?  earn,TResult Function( String idempotencyKey,  int amount,  MotifId motifId,  DateTime occurredAt)?  spendUnlock,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Earn() when earn != null:
return earn(_that.idempotencyKey,_that.amount,_that.occurredAt);case SpendUnlock() when spendUnlock != null:
return spendUnlock(_that.idempotencyKey,_that.amount,_that.motifId,_that.occurredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String idempotencyKey,  int amount,  DateTime occurredAt)  earn,required TResult Function( String idempotencyKey,  int amount,  MotifId motifId,  DateTime occurredAt)  spendUnlock,}) {final _that = this;
switch (_that) {
case Earn():
return earn(_that.idempotencyKey,_that.amount,_that.occurredAt);case SpendUnlock():
return spendUnlock(_that.idempotencyKey,_that.amount,_that.motifId,_that.occurredAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String idempotencyKey,  int amount,  DateTime occurredAt)?  earn,TResult? Function( String idempotencyKey,  int amount,  MotifId motifId,  DateTime occurredAt)?  spendUnlock,}) {final _that = this;
switch (_that) {
case Earn() when earn != null:
return earn(_that.idempotencyKey,_that.amount,_that.occurredAt);case SpendUnlock() when spendUnlock != null:
return spendUnlock(_that.idempotencyKey,_that.amount,_that.motifId,_that.occurredAt);case _:
  return null;

}
}

}

/// @nodoc


class Earn extends CoinTransaction {
  const Earn({required this.idempotencyKey, required this.amount, required this.occurredAt}): assert(amount > 0),super._();
  

@override final  String idempotencyKey;
@override final  int amount;
@override final  DateTime occurredAt;

/// Create a copy of CoinTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EarnCopyWith<Earn> get copyWith => _$EarnCopyWithImpl<Earn>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Earn&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}


@override
int get hashCode => Object.hash(runtimeType,idempotencyKey,amount,occurredAt);

@override
String toString() {
  return 'CoinTransaction.earn(idempotencyKey: $idempotencyKey, amount: $amount, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class $EarnCopyWith<$Res> implements $CoinTransactionCopyWith<$Res> {
  factory $EarnCopyWith(Earn value, $Res Function(Earn) _then) = _$EarnCopyWithImpl;
@override @useResult
$Res call({
 String idempotencyKey, int amount, DateTime occurredAt
});




}
/// @nodoc
class _$EarnCopyWithImpl<$Res>
    implements $EarnCopyWith<$Res> {
  _$EarnCopyWithImpl(this._self, this._then);

  final Earn _self;
  final $Res Function(Earn) _then;

/// Create a copy of CoinTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idempotencyKey = null,Object? amount = null,Object? occurredAt = null,}) {
  return _then(Earn(
idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class SpendUnlock extends CoinTransaction {
  const SpendUnlock({required this.idempotencyKey, required this.amount, required this.motifId, required this.occurredAt}): assert(amount > 0),super._();
  

@override final  String idempotencyKey;
@override final  int amount;
 final  MotifId motifId;
@override final  DateTime occurredAt;

/// Create a copy of CoinTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpendUnlockCopyWith<SpendUnlock> get copyWith => _$SpendUnlockCopyWithImpl<SpendUnlock>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpendUnlock&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.motifId, motifId) || other.motifId == motifId)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}


@override
int get hashCode => Object.hash(runtimeType,idempotencyKey,amount,motifId,occurredAt);

@override
String toString() {
  return 'CoinTransaction.spendUnlock(idempotencyKey: $idempotencyKey, amount: $amount, motifId: $motifId, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class $SpendUnlockCopyWith<$Res> implements $CoinTransactionCopyWith<$Res> {
  factory $SpendUnlockCopyWith(SpendUnlock value, $Res Function(SpendUnlock) _then) = _$SpendUnlockCopyWithImpl;
@override @useResult
$Res call({
 String idempotencyKey, int amount, MotifId motifId, DateTime occurredAt
});




}
/// @nodoc
class _$SpendUnlockCopyWithImpl<$Res>
    implements $SpendUnlockCopyWith<$Res> {
  _$SpendUnlockCopyWithImpl(this._self, this._then);

  final SpendUnlock _self;
  final $Res Function(SpendUnlock) _then;

/// Create a copy of CoinTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idempotencyKey = null,Object? amount = null,Object? motifId = null,Object? occurredAt = null,}) {
  return _then(SpendUnlock(
idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,motifId: null == motifId ? _self.motifId : motifId // ignore: cast_nullable_to_non_nullable
as MotifId,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
