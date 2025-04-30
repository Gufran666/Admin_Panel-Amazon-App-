// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminUser _$AdminUserFromJson(Map<String, dynamic> json) => AdminUser(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  role: json['role'] as String? ?? 'admin',
  isEnabled: json['isEnabled'] as bool? ?? true,
  themePreference: json['themePreference'] as String? ?? 'dark',
  dashboardPreferences:
      json['dashboardPreferences'] as Map<String, dynamic>? ?? const {},
  notificationPreferences:
      (json['notificationPreferences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$AdminUserToJson(AdminUser instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'role': instance.role,
  'isEnabled': instance.isEnabled,
  'themePreference': instance.themePreference,
  'dashboardPreferences': instance.dashboardPreferences,
  'notificationPreferences': instance.notificationPreferences,
};
