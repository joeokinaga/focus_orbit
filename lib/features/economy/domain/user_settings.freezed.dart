// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserSettings {

 MotifId get selectedMotifId; Duration get defaultSessionDuration; bool get bgmEnabled;
/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<UserSettings> get copyWith => _$UserSettingsCopyWithImpl<UserSettings>(this as UserSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSettings&&(identical(other.selectedMotifId, selectedMotifId) || other.selectedMotifId == selectedMotifId)&&(identical(other.defaultSessionDuration, defaultSessionDuration) || other.defaultSessionDuration == defaultSessionDuration)&&(identical(other.bgmEnabled, bgmEnabled) || other.bgmEnabled == bgmEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,selectedMotifId,defaultSessionDuration,bgmEnabled);

@override
String toString() {
  return 'UserSettings(selectedMotifId: $selectedMotifId, defaultSessionDuration: $defaultSessionDuration, bgmEnabled: $bgmEnabled)';
}


}

/// @nodoc
abstract mixin class $UserSettingsCopyWith<$Res>  {
  factory $UserSettingsCopyWith(UserSettings value, $Res Function(UserSettings) _then) = _$UserSettingsCopyWithImpl;
@useResult
$Res call({
 MotifId selectedMotifId, Duration defaultSessionDuration, bool bgmEnabled
});




}
/// @nodoc
class _$UserSettingsCopyWithImpl<$Res>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._self, this._then);

  final UserSettings _self;
  final $Res Function(UserSettings) _then;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedMotifId = null,Object? defaultSessionDuration = null,Object? bgmEnabled = null,}) {
  return _then(_self.copyWith(
selectedMotifId: null == selectedMotifId ? _self.selectedMotifId : selectedMotifId // ignore: cast_nullable_to_non_nullable
as MotifId,defaultSessionDuration: null == defaultSessionDuration ? _self.defaultSessionDuration : defaultSessionDuration // ignore: cast_nullable_to_non_nullable
as Duration,bgmEnabled: null == bgmEnabled ? _self.bgmEnabled : bgmEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserSettings].
extension UserSettingsPatterns on UserSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserSettings value)  $default,){
final _that = this;
switch (_that) {
case _UserSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserSettings value)?  $default,){
final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MotifId selectedMotifId,  Duration defaultSessionDuration,  bool bgmEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
return $default(_that.selectedMotifId,_that.defaultSessionDuration,_that.bgmEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MotifId selectedMotifId,  Duration defaultSessionDuration,  bool bgmEnabled)  $default,) {final _that = this;
switch (_that) {
case _UserSettings():
return $default(_that.selectedMotifId,_that.defaultSessionDuration,_that.bgmEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MotifId selectedMotifId,  Duration defaultSessionDuration,  bool bgmEnabled)?  $default,) {final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
return $default(_that.selectedMotifId,_that.defaultSessionDuration,_that.bgmEnabled);case _:
  return null;

}
}

}

/// @nodoc


class _UserSettings implements UserSettings {
  const _UserSettings({required this.selectedMotifId, required this.defaultSessionDuration, required this.bgmEnabled});
  

@override final  MotifId selectedMotifId;
@override final  Duration defaultSessionDuration;
@override final  bool bgmEnabled;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserSettingsCopyWith<_UserSettings> get copyWith => __$UserSettingsCopyWithImpl<_UserSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSettings&&(identical(other.selectedMotifId, selectedMotifId) || other.selectedMotifId == selectedMotifId)&&(identical(other.defaultSessionDuration, defaultSessionDuration) || other.defaultSessionDuration == defaultSessionDuration)&&(identical(other.bgmEnabled, bgmEnabled) || other.bgmEnabled == bgmEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,selectedMotifId,defaultSessionDuration,bgmEnabled);

@override
String toString() {
  return 'UserSettings(selectedMotifId: $selectedMotifId, defaultSessionDuration: $defaultSessionDuration, bgmEnabled: $bgmEnabled)';
}


}

/// @nodoc
abstract mixin class _$UserSettingsCopyWith<$Res> implements $UserSettingsCopyWith<$Res> {
  factory _$UserSettingsCopyWith(_UserSettings value, $Res Function(_UserSettings) _then) = __$UserSettingsCopyWithImpl;
@override @useResult
$Res call({
 MotifId selectedMotifId, Duration defaultSessionDuration, bool bgmEnabled
});




}
/// @nodoc
class __$UserSettingsCopyWithImpl<$Res>
    implements _$UserSettingsCopyWith<$Res> {
  __$UserSettingsCopyWithImpl(this._self, this._then);

  final _UserSettings _self;
  final $Res Function(_UserSettings) _then;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedMotifId = null,Object? defaultSessionDuration = null,Object? bgmEnabled = null,}) {
  return _then(_UserSettings(
selectedMotifId: null == selectedMotifId ? _self.selectedMotifId : selectedMotifId // ignore: cast_nullable_to_non_nullable
as MotifId,defaultSessionDuration: null == defaultSessionDuration ? _self.defaultSessionDuration : defaultSessionDuration // ignore: cast_nullable_to_non_nullable
as Duration,bgmEnabled: null == bgmEnabled ? _self.bgmEnabled : bgmEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
