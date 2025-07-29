import 'package:amazon_clone_admin/core/models/product.dart';
import 'package:amazon_clone_admin/core/models/order.dart';
import 'package:amazon_clone_admin/core/models/user.dart';
import 'package:logger/logger.dart';

final logger = Logger();

abstract class RecommendationService {
  Future<List<Product>> getSuggestedProductsToRestock();
  Future<List<Order>> getSuggestedOrdersToFollowUp();
  Future<List<User>> getSuggestedUsersToEngage();
}

class MockRecommendationService implements RecommendationService {
  @override
  Future<List<Product>> getSuggestedProductsToRestock() async {
    try {
      // Mock implementation - in real app, this would analyze inventory data
      await Future.delayed(const Duration(seconds: 1));
      return [
        Product(
          id: 'P101',
          name: 'Wireless Headphones',
          category: 'Electronics',
          price: 149.99,
          stock: 15,
          reorderThreshold: 20,
          rating: 4.5,
          reviewsCount: 250,
        ),
        Product(
          id: 'P102',
          name: 'Smart Watch',
          category: 'Electronics',
          price: 99.99,
          stock: 8,
          reorderThreshold: 15,
          rating: 4.2,
          reviewsCount: 180,
        ),
        Product(
          id: 'P103',
          name: 'Bluetooth Speaker',
          category: 'Electronics',
          price: 79.99,
          stock: 5,
          reorderThreshold: 10,
          rating: 4.7,
          reviewsCount: 310,
        ),
      ];
    } catch (e, stackTrace) {
      logger.e('Error getting suggested products to restock', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<Order>> getSuggestedOrdersToFollowUp() async {
    try {
      // Mock implementation - in real app, this would analyze order status
      await Future.delayed(const Duration(seconds: 1));
      return [
        Order(
          id: 'O101',
          userId: 'U101',
          total: 149.99,
          status: 'pending',
          date: DateTime.now().subtract(const Duration(days: 7)),
          items: [
            OrderItem(productId: 'P101', productName: 'Wireless Headphones', quantity: 1),
            OrderItem(productId: 'P102', productName: 'Smart Watch', quantity: 1),
          ],
        ),
        Order(
          id: 'O102',
          userId: 'U102',
          total: 79.99,
          status: 'shipped',
          date: DateTime.now().subtract(const Duration(days: 3)),
          items: [
            OrderItem(productId: 'P103', productName: 'Bluetooth Speaker', quantity: 2),
          ],
        ),
      ];
    } catch (e, stackTrace) {
      logger.e('Error getting suggested orders to follow up', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<User>> getSuggestedUsersToEngage() async {
    try {
      // Mock implementation - in real app, this would analyze user activity
      await Future.delayed(const Duration(seconds: 1));
      return [
        User(
          id: 'U101',
          name: 'John Doe',
          email: 'john@example.com',
          role: 'customer', // Added missing attribute
          lastLogin: DateTime.now().subtract(const Duration(days: 30)),
          registrationDate: DateTime.now().subtract(const Duration(days: 365)), // Added missing attribute
          orderCount: 5,
        ),
        User(
          id: 'U102',
          name: 'Jane Smith',
          email: 'jane@example.com',
          role: 'customer',
          lastLogin: DateTime.now().subtract(const Duration(days: 45)),
          registrationDate: DateTime.now().subtract(const Duration(days: 400)),
          orderCount: 8,
        ),
      ];
    } catch (e, stackTrace) {
      logger.e('Error getting suggested users to engage', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

class RecommendationServiceFactory {
  static RecommendationService create() {
    return MockRecommendationService();
  }
}
