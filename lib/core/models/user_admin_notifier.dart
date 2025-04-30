import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amazon_clone_admin/core/models/user.dart';

class UserAdminNotifier extends AsyncNotifier<List<User>> {
  @override
  Future<List<User>> build() async {
    return fetchUsers();
  }

  Future<List<User>> fetchUsers() async {
    // Replace with your actual data fetching logic
    await Future.delayed(const Duration(seconds: 1));
    return mockUsers;
  }

  Future<List<User>> searchUsers(String query) async {
    // Replace with your actual search logic
    await Future.delayed(const Duration(milliseconds: 300));
    return mockUsers.where((user) {
      return user.name.toLowerCase().contains(query.toLowerCase()) ||
          user.email.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}

final userAdminProvider = AsyncNotifierProvider<UserAdminNotifier, List<User>>(UserAdminNotifier.new);

final List<User> mockUsers = [
  User(
    id: 'USR-001',
    name: 'John Doe',
    email: 'john@example.com',
    role: 'admin',
    registrationDate: DateTime(2023, 1, 15),
  ),
  User(
    id: 'USR-002',
    name: 'Jane Smith',
    email: 'jane@example.com',
    role: 'user',
    registrationDate: DateTime(2023, 2, 20),
  ),
  User(
    id: 'USR-003',
    name: 'Bob Johnson',
    email: 'bob@example.com',
    role: null,
    registrationDate: DateTime(2023, 3, 5),
  ),
];