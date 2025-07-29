import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:amazon_clone_admin/core/models/chart_data.dart';

class InteractiveChartsScreen extends StatefulWidget {
  const InteractiveChartsScreen({super.key});

  @override
  State<InteractiveChartsScreen> createState() => _InteractiveChartsScreenState();
}

class _InteractiveChartsScreenState extends State<InteractiveChartsScreen>
    with SingleTickerProviderStateMixin {
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
  bool _showGridLines = true;
  bool _showDataLabels = false;

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
          'Interactive Charts',
          style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'grid',
                child: Text('Toggle Grid Lines'),
              ),
              const PopupMenuItem(
                value: 'labels',
                child: Text('Toggle Data Labels'),
              ),
              const PopupMenuItem(
                value: 'refresh',
                child: Text('Refresh Data'),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'grid':
                  setState(() => _showGridLines = !_showGridLines);
                  break;
                case 'labels':
                  setState(() => _showDataLabels = !_showDataLabels);
                  break;
                case 'refresh':
                  _refreshData();
                  break;
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _chartTypeController,
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Theme.of(context).textTheme.bodyMedium!.color,
          tabs: const [
            Tab(text: 'Sales'),
            Tab(text: 'User Growth'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _chartTypeController,
              children: [
                _buildSalesChart(),
                _buildUserGrowthChart(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.file_download),
                  label: const Text('Export Data'),
                  onPressed: () => _exportData(),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  onPressed: () => _refreshData(),
                ),
              ],
            ),
          ),
        ],
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Weekly Sales Performance',
                    style: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Theme.of(context).textTheme.titleLarge!.color,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _showChartOptions(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    majorGridLines: _showGridLines
                        ? const MajorGridLines(width: 0)
                        : const MajorGridLines(width: 1),
                  ),
                  primaryYAxis: NumericAxis(
                    majorGridLines: _showGridLines
                        ? const MajorGridLines(width: 0)
                        : const MajorGridLines(width: 1),
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePanning: true,
                    enableSelectionZooming: true,
                  ),
                  trackballBehavior: TrackballBehavior(
                    enable: true,
                    activationMode: ActivationMode.singleTap,
                    tooltipSettings: InteractiveTooltip(
                      color: Theme.of(context).primaryColor,
                      borderColor: Colors.white,
                      borderWidth: 1,
                    ),
                  ),
                  series: <CartesianSeries>[
                    LineSeries<ChartData, String>(
                      dataSource: salesData,
                      xValueMapper: (ChartData data, _) => data.day,
                      yValueMapper: (ChartData data, _) => data.value,
                      name: 'Sales',
                      color: Theme.of(context).primaryColor,
                      width: 3,
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        borderColor: Colors.white,
                        borderWidth: 2,
                        color: Colors.white,
                        shape: DataMarkerType.circle,
                      ),
                      dataLabelSettings: DataLabelSettings(
                        isVisible: _showDataLabels,
                        color: Colors.white,
                        borderColor: Theme.of(context).primaryColor,
                        borderWidth: 1,
                        labelPosition: ChartDataLabelPosition.outside,
                        textStyle: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                    ),
                  ],
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Monthly User Growth',
                    style: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Theme.of(context).textTheme.titleLarge!.color,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _showChartOptions(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    majorGridLines: _showGridLines
                        ? const MajorGridLines(width: 1)
                        : const MajorGridLines(width: 0),
                  ),
                  primaryYAxis: NumericAxis(
                    majorGridLines: _showGridLines
                        ? const MajorGridLines(width: 1)
                        : const MajorGridLines(width: 0),
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePanning: true,
                    enableSelectionZooming: true,
                  ),
                  trackballBehavior: TrackballBehavior(
                    enable: true,
                    activationMode: ActivationMode.singleTap,
                    tooltipSettings: InteractiveTooltip(
                      color: Theme.of(context).primaryColor,
                      borderColor: Colors.white,
                      borderWidth: 1,
                    ),
                  ),
                  series: <CartesianSeries>[
                    AreaSeries<ChartData, String>(
                      dataSource: userGrowthData,
                      xValueMapper: (ChartData data, _) => data.day,
                      yValueMapper: (ChartData data, _) => data.value,
                      name: 'Users',
                      color: Theme.of(context).primaryColor.withAlpha(80),
                      borderColor: Theme.of(context).primaryColor,
                      borderWidth: 2,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: _showDataLabels,
                        color: Colors.black,
                        labelPosition: ChartDataLabelPosition.outside,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor.withAlpha(60),
                          Theme.of(context).primaryColor.withAlpha(80),
                        ],
                        stops: const [0.2, 1.0],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting data...')),
    );
  }

  void _refreshData() {
    setState(() {
      // Simulate data refresh
      salesData = _generateRandomData(salesData.length, 100, 250);
      userGrowthData = _generateRandomData(userGrowthData.length, 100, 250);
    });
  }

  void _showChartOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chart Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Show Grid Lines'),
              value: _showGridLines,
              onChanged: (value) => setState(() => _showGridLines = value!),
            ),
            CheckboxListTile(
              title: const Text('Show Data Labels'),
              value: _showDataLabels,
              onChanged: (value) => setState(() => _showDataLabels = value!),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  List<ChartData> _generateRandomData(int count, int min, int max) {
    return List.generate(count, (index) {
      final randomValue = (min + (max - min) ~/ 2 + ((max - min) ~/ 2) * (index % 2)).toDouble();
      return ChartData(index < userGrowthData.length ? userGrowthData[index].day : 'Day $index', randomValue);
    });
  }

}