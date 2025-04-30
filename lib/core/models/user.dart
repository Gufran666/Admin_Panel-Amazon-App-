class User {
  final String id;
  final String name;
  final String email;
  final String? role;
  final DateTime registrationDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    required this.registrationDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      registrationDate: DateTime.parse(json['registrationDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'registrationDate': registrationDate.toIso8601String(),
    };
  }
}