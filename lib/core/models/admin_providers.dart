import 'package:flutter/foundation.dart';
import 'package:amazon_clone_admin/core/models/order.dart';
import 'package:amazon_clone_admin/core/models/product.dart';
import 'package:amazon_clone_admin/core/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminProviders with ChangeNotifier {
  List<Order> _orders = [];
  List<Product> _products = [];
  bool _isDarkMode = true;

  List<Order> get orders => _orders;
  List<Product> get products => _products;
  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  Future<void> loadOrders() async {
    // Simulated API call
    await Future.delayed(const Duration(seconds: 1));
    _orders = List.generate(10, (index) => Order(
      id: 'ORD-${index + 100}',
      userId: 'U${index + 1}',
      date: DateTime.now().subtract(Duration(days: index)),
      total: (index + 1) * 50,
      status: index % 3 == 0 ? 'Processing' :
      index % 3 == 1 ? 'Shipped' : 'Delivered',
      items: [],
    ));
    notifyListeners();
  }

  Future<void> loadProducts() async {
    // Simulated API call
    await Future.delayed(const Duration(seconds: 1));
    _products = List.generate(5, (index) => Product(
      id: 'PROD-${index + 100}',
      name: 'Product ${index + 1}',
      category: index % 2 == 0 ? 'Electronics' : 'Home & Kitchen',
      price: (index + 1) * 100,
      stock: index * 10 + 50,
      reorderThreshold: 20,
      rating: 4.5,
      reviewsCount: 150,
    ));
    notifyListeners();
  }
}

final userAdminProvider = StateNotifierProvider<UserAdminNotifier, AsyncValue<List<User>>>((ref) {
  return UserAdminNotifier();
});

class UserAdminNotifier extends StateNotifier<AsyncValue<List<User>>> {
  UserAdminNotifier() : super(const AsyncValue.loading()) {
    _loadInitialUsers();
  }

  Future<void> _loadInitialUsers() async {
    state = const AsyncValue.loading();
    try {

      await Future.delayed(const Duration(seconds: 1));
      state = AsyncValue.data(mockUsers);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addUser(User user) async {
    state.whenData((users) {
      state = AsyncValue.data([...users, user]);
    });
  }

  Future<List<User>> searchUsers(String query) async {
    return state.value?.where((user) {
      return user.name.toLowerCase().contains(query.toLowerCase()) ||
          user.email.toLowerCase().contains(query.toLowerCase());
    }).toList() ?? [];
  }
}

final List<User> mockUsers = [
  User(
    id: '1',
    name: 'Admin User',
    email: 'admin@example.com',
    role: 'admin',
    registrationDate: DateTime.now().subtract(const Duration(days: 30)),
    orderCount: 15,
    lastLogin: DateTime.now().subtract(const Duration(days: 10)),
  ),
  User(
    id: '2',
    name: 'John Doe',
    email: 'john.doe@example.com',
    role: 'customer',
    registrationDate: DateTime.now().subtract(const Duration(days: 60)),
    orderCount: 7,
    lastLogin: DateTime.now().subtract(const Duration(days: 25)),
  ),
];
