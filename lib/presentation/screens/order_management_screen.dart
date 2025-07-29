import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amazon_clone_admin/core/models/order.dart';
import 'package:intl/intl.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late List<Order> orders = [
    Order(
      id: 'ORD-2023-0001',
      userId: 'U103',
      date: DateTime.now().subtract(const Duration(days: 2)),
      total: 149.99,
      status: 'delivered',
      items: [
        OrderItem(productId: 'P101', productName: 'Wireless Headphones', quantity: 1),
      ],
    ),
    Order(
      id: 'ORD-2023-0002',
      userId: 'U101',
      date: DateTime.now().subtract(const Duration(days: 5)),
      total: 99.99,
      status: 'shipped',
      items: [
        OrderItem(productId: 'P102', productName: 'Smart Watch', quantity: 1),
      ],
    ),
    Order(
      id: 'ORD-2023-0003',
      userId: 'U102',
      date: DateTime.now().subtract(const Duration(days: 10)),
      total: 249.99,
      status: 'pending',
      items: [
        OrderItem(productId: 'P103', productName: 'Bluetooth Speaker', quantity: 2),
      ],
    ),
  ];

  late List<Order> _filteredOrders;
  late List<bool> _orderExpansionStates;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredOrders = orders;
    _orderExpansionStates = List.filled(orders.length, false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterOrders(String query) {
    setState(() {
      _filteredOrders = orders.where((order) {
        return order.id.toLowerCase().contains(query.toLowerCase()) ||
            order.items.any((item) => item.productName.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    });
  }

  void _updateOrderStatus(Order order, String newStatus) {
    int orderIndex = orders.indexWhere((o) => o.id == order.id);
    if (orderIndex != -1) {
      setState(() {
        orders[orderIndex] = orders[orderIndex].copyWith(status: newStatus);
        _filteredOrders = [...orders];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order ${order.id} status updated to $newStatus'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Theme.of(context).textTheme.bodyMedium!.color,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Order Management',
          style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: Theme.of(context).textTheme.bodyMedium!.color,
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Text('Export Orders'),
              ),
              const PopupMenuItem(
                value: 'refresh',
                child: Text('Refresh Data'),
              ),
            ],
            onSelected: (value) {
              if (value == 'export') {
                _exportOrders();
              } else if (value == 'refresh') {
                _refreshOrders();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildOrderList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddOrderDialog(),
        label: const Text('Add Order'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'Search orders',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).textTheme.bodyMedium!.color!.withAlpha(130),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          color: Theme.of(context).textTheme.bodyMedium!.color,
          onPressed: () {
            _searchController.clear();
            _filterOrders('');
          },
        ),
      ),
      style: TextStyle(
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: Theme.of(context).textTheme.bodyLarge!.color,
      ),
      onChanged: _filterOrders,
    );
  }

  Widget _buildOrderList() {
    return Flexible(
      child: ListView.builder(
        itemCount: _filteredOrders.length,
        itemBuilder: (context, index) {
          final order = _filteredOrders[index];
          bool isExpanded = _orderExpansionStates[index] ?? false;

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    _getStatusIcon(order.status),
                    color: _getStatusColor(order.status),
                  ),
                  title: Text(
                    order.id,
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat.yMMMMd().format(order.date),
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$${order.total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                        onPressed: () {
                          setState(() {
                            _orderExpansionStates[index] = !_orderExpansionStates[index]!;
                          });
                          HapticFeedback.lightImpact();
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _orderExpansionStates[index] = !_orderExpansionStates[index]!;
                    });
                    HapticFeedback.lightImpact();
                  },
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Visibility(
                    visible: isExpanded,
                    maintainState: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          Divider(
                            color: Theme.of(context).dividerColor,
                            thickness: 1,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Order Details',
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Theme.of(context).textTheme.titleLarge!.color,
                                ),
                              ),
                              DropdownButton<String>(
                                value: order.status,
                                onChanged: (value) {
                                  _updateOrderStatus(order, value!);
                                },
                                items: const [
                                  DropdownMenuItem(
                                    value: 'pending',
                                    child: Text('Pending'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'shipped',
                                    child: Text('Shipped'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'delivered',
                                    child: Text('Delivered'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...order.items.map((item) => ListTile(
                            dense: true,
                            title: Text(
                              item.productName,
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Theme.of(context).textTheme.bodyLarge!.color,
                              ),
                            ),
                            subtitle: Text(
                              'Qty: ${item.quantity}',
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Theme.of(context).textTheme.bodyMedium!.color,
                              ),
                            ),
                            trailing: Text(
                              '\$${(item.quantity * 49.99).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Theme.of(context).textTheme.bodyLarge!.color,
                              ),
                            ),
                          )).toList(),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'delivered':
        return Icons.check_circle;
      case 'shipped':
        return Icons.local_shipping;
      case 'pending':
        return Icons.hourglass_empty;
      default:
        return Icons.help;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _exportOrders() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting orders...')),
    );
    // Implement export functionality
  }

  void _refreshOrders() {
    setState(() {
      // Simulate data refresh
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Orders refreshed')),
    );
  }

  void _showAddOrderDialog() {
    final _formKey = GlobalKey<FormState>();
    final _orderItems = <OrderItem>[];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Order'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Order ID'),
                validator: (value) => value!.isEmpty ? 'Please enter an order ID' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Total Amount'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter an amount' : null,
              ),
              ElevatedButton(
                onPressed: () {
                  _orderItems.add(
                    OrderItem(
                      productId: 'P${DateTime.now().millisecondsSinceEpoch}',
                      productName: 'Product ${_orderItems.length + 1}',
                      quantity: 1,
                    ),
                  );
                  setState(() {});
                },
                child: const Text('Add Product'),
              ),
              if (_orderItems.isNotEmpty)
                Column(
                  children: _orderItems.map((item) => ListTile(
                    title: Text(item.productName),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _orderItems.remove(item);
                        setState(() {});
                      },
                    ),
                  )).toList(),
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
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order created')),
                );
              }
            },
            child: const Text('Create Order'),
          ),
        ],
      ),
    );
  }
}