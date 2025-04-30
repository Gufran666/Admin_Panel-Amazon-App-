import 'package:json_annotation/json_annotation.dart';

part 'admin_user.g.dart';

@JsonSerializable()
class AdminUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isEnabled;
  final String themePreference;
  final Map<String, dynamic> dashboardPreferences;
  final List<String> notificationPreferences;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'admin',
    this.isEnabled = true,
    this.themePreference = 'dark',
    this.dashboardPreferences = const {},
    this.notificationPreferences = const [],
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) => _$AdminUserFromJson(json);

  Map<String, dynamic> toJson() => _$AdminUserToJson(this);

  AdminUser copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    bool? isEnabled,
    String? themePreference,
    Map<String, dynamic>? dashboardPreferences,
    List<String>? notificationPreferences,
  }) {
    return AdminUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isEnabled: isEnabled ?? this.isEnabled,
      themePreference: themePreference ?? this.themePreference,
      dashboardPreferences: dashboardPreferences ?? this.dashboardPreferences,
      notificationPreferences: notificationPreferences ?? this.notificationPreferences,
    );
  }
}