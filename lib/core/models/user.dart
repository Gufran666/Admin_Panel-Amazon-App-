import 'package:intl/intl.dart';


class User {
  final String id;
  final String name;
  final String email;
  final String? role;
  final DateTime registrationDate;
  final DateTime lastLogin;
  final int orderCount;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    required this.registrationDate,
    required this.lastLogin,
    required this.orderCount,
  });

  String get formattedDate => DateFormat('MMM dd, yyyy').format(registrationDate);

  String get formattedTime => DateFormat('HH:mm').format(registrationDate);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      registrationDate: DateTime.parse(json['registrationDate']),
      lastLogin: DateTime.parse(json['lastLogin']),
      orderCount: json['orderCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'registrationDate': registrationDate.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'orderCount': orderCount,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    DateTime? registrationDate,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      registrationDate: registrationDate ?? this.registrationDate,
      lastLogin: lastLogin ?? this.lastLogin,
      orderCount: orderCount ?? this.orderCount,
    );
  }
}

class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange(this.start, this.end);

  int get durationInDays => end.difference(start).inDays;

  bool contains(DateTime date) {
    return date.isAfter(start) && date.isBefore(end);
  }
}
