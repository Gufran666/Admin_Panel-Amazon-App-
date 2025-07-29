class InventoryItem {
  final String id;
  String name;
  String category;
  int stock;
  double price;
  String stockStatus;
  DateTime addedDate;
  DateTime lastUpdated;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.stock,
    required this.price,
    required this.stockStatus,
    required this.addedDate,
    required this.lastUpdated,
});

  InventoryItem copyWith({
    String? name,
    String? category,
    int? stock,
    double? price,
    String? stockStatus,
    DateTime? lastUpdated,
}) {
    return InventoryItem(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      price: price ?? this.price,
      stockStatus: stockStatus ?? this.stockStatus,
      addedDate: addedDate,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }
}