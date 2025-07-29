import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amazon_clone_admin/core/models/inventory_item.dart';
import 'inventory_providers.dart';

final filteredInventoryItemsProvider = StateNotifierProvider<FilterNotifier, AsyncValue<List<InventoryItem>>>((ref) {
  final inventoryItems = ref.watch(inventoryAdminProvider);
  return FilterNotifier(inventoryItems);
});

class FilterNotifier extends StateNotifier<AsyncValue<List<InventoryItem>>> {
  FilterNotifier(AsyncValue<List<InventoryItem>> inventoryItems) : super(inventoryItems);

  void updateSearchQuery(String query) {
    state = state.whenData((items) {
      if (query.isEmpty) {
        return items;
      }
      return items.where((item) =>
      item.name.toLowerCase().contains(query.toLowerCase()) ||
          item.category.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void updateCategoryFilter(String? category) {
    state = state.whenData((items) {
      if (category == null) {
        return items;
      }
      return items.where((item) => item.category == category).toList();
    });
  }

  void resetFilters() {
    state = state.whenData((items) => items);
  }

  void sortItems(int columnIndex, bool ascending) {
    state = state.whenData((items) => items);
  }

  void applyAdvancedFilters({
    double? minPrice,
    double? maxPrice,
    int? minStock,
    int? maxStock,
  }) {
    state = state.whenData((items) {
      List<InventoryItem> filtered = items;

      if (minPrice != null) {
        filtered = filtered.where((item) => item.price >= minPrice).toList();
      }
      if (maxPrice != null) {
        filtered = filtered.where((item) => item.price <= maxPrice).toList();
      }
      if (minStock != null) {
        filtered = filtered.where((item) => item.stock >= minStock).toList();
      }
      if (maxStock != null) {
        filtered = filtered.where((item) => item.stock <= maxStock).toList();
      }

      return filtered;
    });
  }
}
