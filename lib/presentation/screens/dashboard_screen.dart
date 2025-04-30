import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:amazon_clone_admin/presentation/theme/theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _metricsTabController;
  late List<ChartSeriesController> _chartControllers;
  final List<ChartData> chartData = [
    ChartData('Mon', 120),
    ChartData('Tue', 150),
    ChartData('Wed', 180),
    ChartData('Thu', 160),
    ChartData('Fri', 200),
    ChartData('Sat', 220),
    ChartData('Sun', 190),
  ];

  @override
  void initState() {
    super.initState();
    _metricsTabController = TabController(length: 2, vsync: this);
    _chartControllers = [];
  }

  @override
  void dispose() {
    _metricsTabController.dispose();
    super.dispose();
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
            icon: const Icon(Icons.menu),
            color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
            onPressed: () {
              // Open sidebar menu
            },
          ),
          title: Text(
            'Admin Dashboard',
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
                // Open search
              },
            ),
          ],
          bottom: TabBar(
            controller: _metricsTabController,
            tabs: [
              Tab(
                text: 'Today',
                icon: Icon(
                  Icons.today,
                  color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                ),
              ),
              Tab(
                text: 'Week',
                icon: Icon(
                  Icons.calendar_today,
                  color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildMetricsRow(),
              const SizedBox(height: 24),
              _buildChartsSection(),
              const SizedBox(height: 24),
              _buildRecentOrders(),
              const SizedBox(height: 24),
              _buildProductOverview(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMetricCard('Users', '1,234', Colors.blue),
        _buildMetricCard('Orders', '876', Colors.purple),
        _buildMetricCard('Revenue', '\$12,345', Colors.green),
        _buildMetricCard('Products', '456', Colors.orange),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppTheme.darkTheme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
              ),
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
    );
  }

  Widget _buildChartsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Weekly Sales Overview',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries>[
                  ColumnSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.day,
                    yValueMapper: (ChartData data, _) => data.value,
                    name: 'Sales',
                    color: AppTheme.darkTheme.primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrders() {
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
            const Text(
              'Recent Orders',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.darkTheme.primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(child: Icon(Icons.shopping_cart)),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${index + 100}',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                            ),
                          ),
                          Text(
                            'Placed on ${DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]}',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: AppTheme.darkTheme.textTheme.bodyMedium!.color!.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        '\$${(index + 1) * 50}',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppTheme.darkTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductOverview() {
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
            const Text(
              'Top Products',
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppTheme.darkTheme.primaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(child: Icon(Icons.cube)),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Product ${index + 1}',
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                                  ),
                                ),
                                Text(
                                  'Category',
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: AppTheme.darkTheme.textTheme.bodyMedium!.color!.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              '\$${(index + 1) * 100}',
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: AppTheme.darkTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.darkTheme.primaryColor,
                    foregroundColor: AppTheme.darkTheme.textTheme.bodyLarge!.color,
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
                    // Navigate to product management screen
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String day;
  final int value;

  ChartData(this.day, this.value);
}