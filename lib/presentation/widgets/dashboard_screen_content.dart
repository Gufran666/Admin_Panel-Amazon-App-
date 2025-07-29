import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:amazon_clone_admin/core/models/order.dart';
import 'package:amazon_clone_admin/core/models/product.dart';

class ChartData {
  final String day;
  final double value;

  ChartData(this.day, this.value);
}

class DashboardScreenContent extends HookWidget {
  const DashboardScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    useTabController(initialLength: 2);
    useState(true);
    final _chartLegendStates = useState([true, false]);
    final _ordersScrollController = useScrollController();
    final _productsScrollController = useScrollController();
    final _refreshController = useState(RefreshController());

    final List<ChartData> chartData = [
      ChartData('Mon', 120),
      ChartData('Tue', 150),
      ChartData('Wed', 180),
      ChartData('Thu', 160),
      ChartData('Fri', 200),
      ChartData('Sat', 220),
      ChartData('Sun', 190),
    ];

    return SmartRefresher(
      controller: _refreshController.value,
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        _refreshController.value.refreshCompleted();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildNotificationsSection(context),
            const SizedBox(height: 24),
            _buildMetricsRow(context),
            const SizedBox(height: 24),
            _buildChartsSection(context, chartData, _chartLegendStates),
            const SizedBox(height: 24),
            _buildRecentOrders(context, _ordersScrollController),
            const SizedBox(height: 24),
            _buildProductOverview(context, _productsScrollController),
            const SizedBox(height: 24),
            _buildQuickActions(context),
            const SizedBox(height: 24),
            _buildRecentActivities(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Theme.of(context).textTheme.titleLarge!.color,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {
                    // Show all notifications
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...List.generate(
              3,
                  (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: index == 0
                          ? Colors.green
                          : index == 1
                          ? Colors.blue
                          : Colors.orange,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        index == 0
                            ? Icons.check_circle
                            : index == 1
                            ? Icons.info
                            : Icons.warning,
                        color: index == 0
                            ? Colors.green
                            : index == 1
                            ? Colors.blue
                            : Colors.orange,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              index == 0
                                  ? 'New User Registration'
                                  : index == 1
                                  ? 'Low Stock Alert'
                                  : 'Order Delivered',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).textTheme.bodyMedium!.color,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              index == 0
                                  ? 'A new user has registered in your store'
                                  : index == 1
                                  ? 'Product #123 is running low on stock'
                                  : 'Order #456 has been delivered',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).textTheme.bodyMedium!.color!.withAlpha(200),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        children: [
                          Text(
                            index == 0
                                ? '5m'
                                : index == 1
                                ? '1h'
                                : '2h',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: index == 0
                                  ? Colors.green
                                  : index == 1
                                  ? Colors.blue
                                  : Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMetricCard('Users', '1,234', Colors.blue, Icons.people, context),
        _buildMetricCard('Orders', '876', Colors.purple, Icons.receipt_long, context),
        _buildMetricCard('Revenue', '\$12,345', Colors.green, Icons.attach_money, context),
        _buildMetricCard('Products', '456', Colors.orange, Icons.production_quantity_limits, context),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, Color color, IconData icon, BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Theme.of(context).cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to detailed metrics
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartsSection(BuildContext context, List<ChartData> chartData, ValueNotifier<List<bool>> _chartLegendStates) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weekly Sales Overview',
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Theme.of(context).textTheme.titleLarge!.color,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // Show chart options menu
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(),
                tooltipBehavior: TooltipBehavior(enable: true),
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                ),
                series: <CartesianSeries<ChartData, String>>[
                  ColumnSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.day,
                    yValueMapper: (ChartData data, _) => data.value,
                    name: 'Sales',
                    color: Theme.of(context).primaryColor,
                    isVisibleInLegend: _chartLegendStates.value[0],
                  ),
                  LineSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.day,
                    yValueMapper: (ChartData data, _) => data.value,
                    name: 'Trend',
                    color: Theme.of(context).colorScheme.secondary,
                    isVisibleInLegend: _chartLegendStates.value[1],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrders(BuildContext context, ScrollController _ordersScrollController) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Orders',
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Theme.of(context).textTheme.titleLarge!.color,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // Show filter options
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                controller: _ordersScrollController,
                itemCount: 10,
                itemBuilder: (context, index) {
                  final order = Order(
                    id: 'ORD-${index + 100}',
                    userId: 'U${index + 1}',
                    date: DateTime.now().subtract(Duration(days: index)),
                    total: (index + 1) * 50,
                    status: index % 3 == 0 ? 'Processing' : index % 3 == 1 ? 'Shipped' : 'Delivered',
                    items: [],
                  );
                  return _buildOrderItem(order, context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(Order order, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          // Navigate to order details
        },
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withAlpha(70),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Icon(Icons.shopping_cart)),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.id,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
                Text(
                  'Placed on ${DateFormat.yMMMd().format(order.date)}',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyMedium!.color!.withAlpha(200),
                  ),
                ),
                Text(
                  order.status,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: order.status == 'Processing' ? Colors.orange : order.status == 'Shipped' ? Colors.blue : Colors.green,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              '\$${order.total}',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductOverview(BuildContext context, ScrollController _productsScrollController) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Products',
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Theme.of(context).textTheme.titleLarge!.color,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    // Refresh products
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ListView.builder(
                      controller: _productsScrollController,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final product = Product(
                          id: 'PROD-${index + 100}',
                          name: 'Product ${index + 1}',
                          category: index % 2 == 0 ? 'Electronics' : 'Home & Kitchen',
                          price: (index + 1) * 100,
                          stock: index * 10 + 50,
                          reorderThreshold: 20,
                          rating: 4.5,
                          reviewsCount: 150,
                        );
                        return _buildProductItem(product, context);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        textStyle: TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      onPressed: () {
                        // Navigate to product management
                      },
                      child: const Text('Manage Products'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(Product product, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          // Navigate to product details
        },
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withAlpha(50),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Icon(Icons.check_box_outline_blank)),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
                Text(
                  product.category,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyMedium!.color!.withAlpha(200),
                  ),
                ),
                Text(
                  'In Stock: ${product.stock}',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: product.stock < 20 ? Colors.red : Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              '\$${product.price}',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Theme.of(context).textTheme.titleLarge!.color,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickActionCard('Add Product', Icons.add, context),
                _buildQuickActionCard('Add User', Icons.person_add, context),
                _buildQuickActionCard('View Analytics', Icons.analytics, context),
                _buildQuickActionCard('Manage Inventory', Icons.inventory_2, context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Handle card tap
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivities(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activities',
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Theme.of(context).textTheme.titleLarge!.color,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {
                    // Show all activities
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...List.generate(
              5,
                  (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withAlpha(100),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(
                          index % 2 == 0 ? Icons.person : Icons.shopping_cart,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            index % 2 == 0
                                ? 'User ${index + 1} logged in'
                                : 'Order ${index + 1} processed',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat.jms().format(
                              DateTime.now().subtract(
                                Duration(minutes: index * 5),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).textTheme.bodyMedium!.color!.withAlpha(180),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}