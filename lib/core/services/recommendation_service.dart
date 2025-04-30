import 'package:amazon_clone_admin/core/models/admin_user.dart';
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
          currentStock: 15,
          reorderThreshold: 20,
        ),
        Product(
          id: 'P102',
          name: 'Smart Watch',
          category: 'Electronics',
          currentStock: 8,
          reorderThreshold: 15,
        ),
        Product(
          id: 'P103',
          name: 'Bluetooth Speaker',
          category: 'Electronics',
          currentStock: 5,
          reorderThreshold: 10,
        ),
      ];
    } catch (e, stackTrace) {
      logger.e('Error getting suggested products to restock', e, stackTrace);
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
          totalAmount: 149.99,
          status: 'pending',
          items: [
            OrderItem(productId: 'P101', quantity: 1),
            OrderItem(productId: 'P102', quantity: 1),
          ],
        ),
        Order(
          id: 'O102',
          userId: 'U102',
          totalAmount: 79.99,
          status: 'shipped',
          items: [
            OrderItem(productId: 'P103', quantity: 2),
          ],
        ),
      ];
    } catch (e, stackTrace) {
      logger.e('Error getting suggested orders to follow up', e, stackTrace);
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
          lastLogin: DateTime.now().subtract(const Duration(days: 30)),
          orderCount: 5,
        ),
        User(
          id: 'U102',
          name: 'Jane Smith',
          email: 'jane@example.com',
          lastLogin: DateTime.now().subtract(const Duration(days: 45)),
          orderCount: 8,
        ),
      ];
    } catch (e, stackTrace) {
      logger.e('Error getting suggested users to engage', e, stackTrace);
      rethrow;
    }
  }
}

class RecommendationServiceFactory {
  static RecommendationService create() {
    return MockRecommendationService();
  }
}