import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:amazon_clone_admin/core/design_system/app_theme.dart';
import 'package:amazon_clone_admin/core/models/order.dart';
import 'package:intl/intl.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late List<Order> orders = [
    Order(
      id: 'ORD-2023-0001',
      date: DateTime.now().subtract(const Duration(days: 2)),
      totalAmount: 149.99,
      status: 'delivered',
      items: [
        OrderItem(productId: 'P101', productName: 'Wireless Headphones', quantity: 1),
      ],
    ),
    Order(
      id: 'ORD-2023-0002',
      date: DateTime.now().subtract(const Duration(days: 5)),
      totalAmount: 99.99,
      status: 'shipped',
      items: [
        OrderItem(productId: 'P102', productName: 'Smart Watch', quantity: 1),
      ],
    ),
    Order(
      id: 'ORD-2023-0003',
      date: DateTime.now().subtract(const Duration(days: 10)),
      totalAmount: 249.99,
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));

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
              color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
              onPressed: () {
                // Focus on search field
                FocusScope.of(context).requestFocus(FocusNode());
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
          color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.darkTheme.textTheme.bodyMedium!.color!.withOpacity(0.5),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.darkTheme.primaryColor,
          ),
        ),
        prefixIcon: Icon(
          Icons.search,
          color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
          onPressed: () {
            _searchController.clear();
          },
        ),
      ),
      style: TextStyle(
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
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
                      color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat.yMMMMd().format(order.date),
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$${order.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                        ),
                        onPressed: () {
                          setState(() {
                            _orderExpansionStates[index] = !_orderExpansionStates[index]!;
                          });
                          aptic HFeedback.lightImpact();
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
                            color: AppTheme.darkTheme.dividerColor,
                            thickness: 1,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Order Details',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppTheme.darkTheme.textTheme.titleLarge!.color,
                            ),
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
                                color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
                              ),
                            ),
                            subtitle: Text(
                              'Qty: ${item.quantity}',
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                              ),
                            ),
                            trailing: Text(
                              '\$${(item.quantity * 49.99).toStringAsFixed(2)}', // Assuming product price
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
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
}