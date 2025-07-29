import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amazon_clone_admin/core/models/inventory_item.dart';

final inventoryAdminProvider = StateNotifierProvider<InventoryNotifier, AsyncValue<List<InventoryItem>>>((ref) {
  return InventoryNotifier();
});


class InventoryNotifier extends StateNotifier<AsyncValue<List<InventoryItem>>> {
  InventoryNotifier() : super(const AsyncValue.loading()) {
    fetchInventoryItems();
  }

  Future<void> fetchInventoryItems() async {
    try {
      state = const AsyncValue.loading();
      await Future.delayed(const Duration(seconds: 1));
      state = AsyncValue.data([
        InventoryItem(
          id: '1',
          name: 'Laptop',
          category: 'electronics',
          stock: 10,
          price: 999.99,
          stockStatus: 'In Stock',
          addedDate: DateTime.now().subtract(const Duration(days: 5)),
          lastUpdated: DateTime.now(),
        ),
        InventoryItem(
          id: '2',
          name: 'T-Shirt',
          category: 'clothing',
          stock: 5,
          price: 19.99,
          stockStatus: 'Low Stock',
          addedDate: DateTime.now().subtract(const Duration(days: 2)),
          lastUpdated: DateTime.now(),
        ),
        InventoryItem(
          id: '3',
          name: 'Bowl',
          category: 'home',
          stock: 0,
          price: 9.99,
          stockStatus: 'Out of Stock',
          addedDate: DateTime.now().subtract(const Duration(days: 1)),
          lastUpdated: DateTime.now(),
        ),
      ]);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void addInventoryItem(InventoryItem item) {
    state = state.whenData((items) => [...items, item]);
  }

  void updateInventoryItem(InventoryItem item) {
    state = state.whenData((items) => items.map((e) => e.id == item.id ? item : e).toList());
  }

  void deleteInventoryItem(String itemId) {
    state = state.whenData((items) => items.where((item) => item.id != itemId).toList());
  }
}
