import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:amazon_clone_admin/presentation/theme/theme.dart';

class InteractiveChartsScreen extends StatefulWidget {
  const InteractiveChartsScreen({super.key});

  @override
  State<InteractiveChartsScreen> createState() => _InteractiveChartsScreenState();
}

class _InteractiveChartsScreenState extends State<InteractiveChartsScreen> with SingleTickerProviderStateMixin {
  late TabController _chartTypeController;
  List<ChartData> salesData = [
    ChartData('Mon', 120),
    ChartData('Tue', 150),
    ChartData('Wed', 180),
    ChartData('Thu', 160),
    ChartData('Fri', 200),
    ChartData('Sat', 220),
    ChartData('Sun', 190),
  ];
  List<ChartData> userGrowthData = [
    ChartData('Jan', 120),
    ChartData('Feb', 150),
    ChartData('Mar', 180),
    ChartData('Apr', 160),
    ChartData('May', 200),
    ChartData('Jun', 220),
    ChartData('Jul', 190),
  ];

  @override
  void initState() {
    super.initState();
    _chartTypeController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _chartTypeController.dispose();
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
            icon: const Icon(Icons.arrow_back),
            color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Interactive Charts',
            style: TextStyle(
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
            ),
          ),
          bottom: TabBar(
            controller: _chartTypeController,
            indicatorColor: AppTheme.darkTheme.primaryColor,
            labelColor: AppTheme.darkTheme.primaryColor,
            unselectedLabelColor: AppTheme.darkTheme.textTheme.bodyMedium!.color,
            tabs: const [
              Tab(text: 'Sales'),
              Tab(text: 'User Growth'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _chartTypeController,
          children: [
            _buildSalesChart(),
            _buildUserGrowthChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesChart() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(),
            tooltipBehavior: TooltipBehavior(enable: true),
            zoomPanBehavior: ZoomPanBehavior(enablePanning: true, enableSelectionZooming: true),
            trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              tooltipSettings: InteractiveTooltip(
                color: AppTheme.darkTheme.primaryColor,
                borderColor: Colors.white,
                borderWidth: 1,
              ),
            ),
            series: <ChartSeries>[
              LineSeries<ChartData, String>(
                dataSource: salesData,
                xValueMapper: (ChartData data, _) => data.day,
                yValueMapper: (ChartData data, _) => data.value,
                name: 'Sales',
                color: AppTheme.darkTheme.primaryColor,
                width: 3,
                markerSettings: MarkerSettings(
                  isVisible: true,
                  borderColor: Colors.white,
                  borderWidth: 2,
                ),
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.cyan],
                  stops: [0.2, 0.8],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserGrowthChart() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(),
            tooltipBehavior: TooltipBehavior(enable: true),
            zoomPanBehavior: ZoomPanBehavior(enablePanning: true, enableSelectionZooming: true),
            trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              tooltipSettings: InteractiveTooltip(
                color: AppTheme.darkTheme.primaryColor,
                borderColor: Colors.white,
                borderWidth: 1,
              ),
            ),
            series: <ChartSeries>[
              AreaSeries<ChartData, String>(
                dataSource: userGrowthData,
                xValueMapper: (ChartData data, _) => data.day,
                yValueMapper: (ChartData data, _) => data.value,
                name: 'Users',
                color: AppTheme.darkTheme.primaryColor.withOpacity(0.5),
                borderColor: AppTheme.darkTheme.primaryColor,
                borderWidth: 2,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.darkTheme.primaryColor.withOpacity(0.2),
                    AppTheme.darkTheme.primaryColor,
                  ],
                  stops: const [0.2, 1.0],
                ),
              ),
            ],
          ),
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