import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:amazon_clone_admin/presentation/theme/theme.dart';
import 'package:amazon_clone_admin/core/models/inventory_item.dart';
import 'package:amazon_clone_admin/core/providers/inventory_providers.dart';

import '../../core/providers/filteredInventoryItemsProviders.dart';

class InventoryManagementScreen extends HookConsumerWidget {
  const InventoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController _searchController = useTextEditingController();
    final selectedCategory = useState<String?>(null);
    final selectedItems = useState<List<InventoryItem>>([]);
    final showFilters = useState<bool>(false);

    ref.watch(filteredInventoryItemsProvider);

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: Scaffold(
        backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Inventory Management',
            style: TextStyle(
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
              onPressed: () => ref.read(inventoryAdminProvider.notifier).fetchInventoryItems(),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(AppTheme.darkTheme.primaryColor),
                        ),
                        icon: Icon(showFilters.value ? Icons.filter_list_off : Icons.filter_list),
                        label: Text(showFilters.value ? 'Hide Filters' : 'Show Filters'),
                        onPressed: () => showFilters.value = !showFilters.value,
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(AppTheme.darkTheme.primaryColor),
                      ),
                      icon: const Icon(Icons.import_export),
                      label: const Text('Export'),
                      onPressed: () {
                        final inventoryItems = ref.read(inventoryAdminProvider);

                        inventoryItems.when(
                          data: (items) {
                            if (items.isNotEmpty) {
                              _exportInventoryData(items, context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('No inventory items to export.')),
                              );
                            }
                          },
                          loading: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Loading inventory data...')),
                          ),
                          error: (error, stack) => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error loading inventory: $error')),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: Visibility(
                    visible: showFilters.value,
                    maintainState: true,
                    child: _buildFilterSection(
                      context,
                      _searchController,
                      selectedCategory,
                      ref,
                    ),
                  ),
                ),
                if (selectedItems.value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Chip(
                      label: Text('${selectedItems.value.length} items selected'),
                      onDeleted: () => selectedItems.value = [],
                    ),
                  ),
                const SizedBox(height: 16),
                ref.watch(inventoryAdminProvider).when(
                  data: (items) {
                    if (items.isEmpty) {
                      return const Center(
                        child: Text('No inventory items found'),
                      );
                    }
                    return SingleChildScrollView(
                      child: _buildInventoryTable(
                        items,
                        selectedItems,
                        ref,
                        context,
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppTheme.darkTheme.primaryColor,
          onPressed: () => _showAddItemDialog(context, ref),
          label: const Text('Add Item'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }



  Widget _buildFilterSection(
      BuildContext context,
      TextEditingController searchController,
      ValueNotifier<String?> selectedCategory,
      WidgetRef ref,
      ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search inventory',
                      labelStyle: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppTheme.darkTheme.textTheme.bodyMedium!.color!.withAlpha(128),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.darkTheme.primaryColor),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (value) => ref
                        .read(filteredInventoryItemsProvider.notifier)
                        .updateSearchQuery(value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory.value,
                    onChanged: (value) {
                      selectedCategory.value = value;
                      ref
                          .read(filteredInventoryItemsProvider.notifier)
                          .updateCategoryFilter(value);
                    },
                    items: const [
                      DropdownMenuItem(
                        value: null,
                        child: Text('All Categories'),
                      ),
                      DropdownMenuItem(
                        value: 'electronics',
                        child: Text('Electronics'),
                      ),
                      DropdownMenuItem(
                        value: 'clothing',
                        child: Text('Clothing'),
                      ),
                      DropdownMenuItem(
                        value: 'home',
                        child: Text('Home & Kitchen'),
                      ),
                      DropdownMenuItem(
                        value: 'books',
                        child: Text('Books'),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Category',
                      labelStyle: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppTheme.darkTheme.textTheme.bodyMedium!.color!.withAlpha(128),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.darkTheme.primaryColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(AppTheme.darkTheme.primaryColor),
                    ),
                    icon: const Icon(Icons.filter_alt),
                    label: const Text('Advanced Filters'),
                    onPressed: () => _showAdvancedFiltersDialog(context, ref),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(AppTheme.darkTheme.primaryColor),
                  ),
                  icon: const Icon(Icons.restore),
                  label: const Text('Reset Filters'),
                  onPressed: () {
                    searchController.text = '';
                    selectedCategory.value = null;
                    ref.read(filteredInventoryItemsProvider.notifier).resetFilters();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryTable(
      List<InventoryItem> items,
      ValueNotifier<List<InventoryItem>> selectedItems,
      WidgetRef ref,
      BuildContext context,
      ) {
    final selectedCount = useState<int>(0);

    void handleSelectAll(bool? checked) {
      if (checked ?? false) {
        selectedItems.value = items;
      } else {
        selectedItems.value = [];
      }
      selectedCount.value = selectedItems.value.length;
    }

    return PaginatedDataTable(
      rowsPerPage: 10,
      availableRowsPerPage: const [10, 20, 50],
      onRowsPerPageChanged: (int? value) {},
      sortColumnIndex: 0,
      sortAscending: true,
      onSelectAll: handleSelectAll,
      columns: const [
        DataColumn(
          label: Text('ID'),
          tooltip: 'Product ID',
        ),
        DataColumn(
          label: Text('Product Name'),
          tooltip: 'Product Name',
        ),
        DataColumn(
          label: Text('Category'),
          tooltip: 'Product Category',
        ),
        DataColumn(
          label: Text('Stock'),
          tooltip: 'Stock Quantity',
        ),
        DataColumn(
          label: Text('Price'),
          tooltip: 'Product Price',
        ),
        DataColumn(
          label: Text('Status'),
          tooltip: 'Inventory Status',
        ),
        DataColumn(
          label: Text('Actions'),
          tooltip: 'Actions',
        ),
      ],
      source: InventoryDataSource(
        items,
        selectedItems,
            (item) {
          selectedCount.value++;
          selectedItems.value.add(item);
        },
            (item) {
          selectedCount.value--;
          selectedItems.value.remove(item);
        },
        ref,
        context, // Pass context to the data source
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _priceController = TextEditingController();
    final _stockController = TextEditingController();
    final _categoryController = useState<String>('electronics');
    final _statusController = useState<String>('In Stock');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Inventory Item'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  validator: (value) => value!.isEmpty ? 'Please enter product name' : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) => double.tryParse(value!) == null ? 'Please enter valid price' : null,
                ),
                TextFormField(
                  controller: _stockController,
                  decoration: const InputDecoration(labelText: 'Stock Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (value) => int.tryParse(value!) == null ? 'Please enter valid quantity' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _categoryController.value,
                  onChanged: (value) => _categoryController.value = value!,
                  items: const [
                    DropdownMenuItem(
                      value: 'electronics',
                      child: Text('Electronics'),
                    ),
                    DropdownMenuItem(
                      value: 'clothing',
                      child: Text('Clothing'),
                    ),
                    DropdownMenuItem(
                      value: 'home',
                      child: Text('Home & Kitchen'),
                    ),
                    DropdownMenuItem(
                      value: 'books',
                      child: Text('Books'),
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  value: _statusController.value,
                  onChanged: (value) => _statusController.value = value!,
                  items: const [
                    DropdownMenuItem(
                      value: 'In Stock',
                      child: Text('In Stock'),
                    ),
                    DropdownMenuItem(
                      value: 'Low Stock',
                      child: Text('Low Stock'),
                    ),
                    DropdownMenuItem(
                      value: 'Out of Stock',
                      child: Text('Out of Stock'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final newItem = InventoryItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _nameController.text,
                  category: _categoryController.value,
                  stock: int.parse(_stockController.text),
                  price: double.parse(_priceController.text),
                  stockStatus: _statusController.value,
                  addedDate: DateTime.now(),
                  lastUpdated: DateTime.now(),
                );
                ref.read(inventoryAdminProvider.notifier).addInventoryItem(newItem);
                Navigator.pop(context);
              }
            },
            child: const Text('Add Item'),
          ),
        ],
      ),
    );
  }

  void _showAdvancedFiltersDialog(BuildContext context, WidgetRef ref) {
    final _minPriceController = TextEditingController();
    final _maxPriceController = TextEditingController();
    final _minStockController = TextEditingController();
    final _maxStockController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Advanced Filters'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _minPriceController,
                decoration: const InputDecoration(labelText: 'Minimum Price'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _maxPriceController,
                decoration: const InputDecoration(labelText: 'Maximum Price'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _minStockController,
                decoration: const InputDecoration(labelText: 'Minimum Stock'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _maxStockController,
                decoration: const InputDecoration(labelText: 'Maximum Stock'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final minPrice = double.tryParse(_minPriceController.text);
              final maxPrice = double.tryParse(_maxPriceController.text);
              final minStock = int.tryParse(_minStockController.text);
              final maxStock = int.tryParse(_maxStockController.text);

              ref.read(filteredInventoryItemsProvider.notifier).applyAdvancedFilters(
                minPrice: minPrice,
                maxPrice: maxPrice,
                minStock: minStock,
                maxStock: maxStock,
              );

              Navigator.pop(context);
            },
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }

  void _exportInventoryData(List<InventoryItem> items, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export functionality coming soon!')),
    );
  }
}

class InventoryDataSource extends DataTableSource {
  final List<InventoryItem> _items;
  final ValueNotifier<List<InventoryItem>> _selectedItems;
  final void Function(InventoryItem item) _onSelect;
  final void Function(InventoryItem item) _onDeselect;
  final WidgetRef _ref;
  final BuildContext _context;

  InventoryDataSource(
      this._items,
      this._selectedItems,
      this._onSelect,
      this._onDeselect,
      this._ref,
      this._context,
      );

  @override
  DataRow? getRow(int index) {
    if (index < 0 || index >= _items.length) return null;

    final item = _items[index];
    final selected = _selectedItems.value.contains(item);

    return DataRow.byIndex(
      index: index,
      selected: selected,
      onSelectChanged: (value) {
        if (value ?? false) {
          _onSelect(item);
        } else {
          _onDeselect(item);
        }
      },
      cells: [
        DataCell(Text(item.id)),
        DataCell(Text(item.name)),
        DataCell(Text(item.category)),
        DataCell(Text('${item.stock}')),
        DataCell(Text('\$${item.price.toStringAsFixed(2)}')),
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: _getStatusColor(item.stockStatus),
          ),
          child: Text(
            item.stockStatus,
            style: TextStyle(
              color: _getStatusTextColor(item.stockStatus),
            ),
          ),
        )),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditItemDialog(item, _ref, _context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 18,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteItem(item, _ref, _context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 18,
            ),
          ],
        )),
      ],
    );
  }

  void _showEditItemDialog(InventoryItem item, WidgetRef ref, BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: item.name);
    final _priceController = TextEditingController(text: item.price.toString());
    final _stockController = TextEditingController(text: item.stock.toString());
    final _categoryController = useState<String>(item.category);
    final _statusController = useState<String>(item.stockStatus);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Inventory Item'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  validator: (value) => value!.isEmpty ? 'Please enter product name' : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) => double.tryParse(value!) == null ? 'Please enter valid price' : null,
                ),
                TextFormField(
                  controller: _stockController,
                  decoration: const InputDecoration(labelText: 'Stock Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (value) => int.tryParse(value!) == null ? 'Please enter valid quantity' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _categoryController.value,
                  onChanged: (value) => _categoryController.value = value!,
                  items: const [
                    DropdownMenuItem(
                      value: 'electronics',
                      child: Text('Electronics'),
                    ),
                    DropdownMenuItem(
                      value: 'clothing',
                      child: Text('Clothing'),
                    ),
                    DropdownMenuItem(
                      value: 'home',
                      child: Text('Home & Kitchen'),
                    ),
                    DropdownMenuItem(
                      value: 'books',
                      child: Text('Books'),
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  value: _statusController.value,
                  onChanged: (value) => _statusController.value = value!,
                  items: const [
                    DropdownMenuItem(
                      value: 'In Stock',
                      child: Text('In Stock'),
                    ),
                    DropdownMenuItem(
                      value: 'Low Stock',
                      child: Text('Low Stock'),
                    ),
                    DropdownMenuItem(
                      value: 'Out of Stock',
                      child: Text('Out of Stock'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final updatedItem = InventoryItem(
                  id: item.id,
                  name: _nameController.text,
                  category: _categoryController.value,
                  stock: int.parse(_stockController.text),
                  price: double.parse(_priceController.text),
                  stockStatus: _statusController.value,
                  addedDate: item.addedDate,
                  lastUpdated: DateTime.now(),
                );
                ref.read(inventoryAdminProvider.notifier).updateInventoryItem(updatedItem);
                Navigator.pop(context);
              }
            },
            child: const Text('Update Item'),
          ),
        ],
      ),
    );
  }

  void _deleteItem(InventoryItem item, WidgetRef ref, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete ${item.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(inventoryAdminProvider.notifier).deleteInventoryItem(item.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'In Stock':
        return Colors.green[100]!;
      case 'Low Stock':
        return Colors.orange[100]!;
      case 'Out of Stock':
        return Colors.red[100]!;
      default:
        return Colors.transparent;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'In Stock':
        return Colors.green;
      case 'Low Stock':
        return Colors.orange[800]!;
      case 'Out of Stock':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  int get rowCount => _items.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedItems.value.length;
}