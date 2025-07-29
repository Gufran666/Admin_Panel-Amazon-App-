import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:amazon_clone_admin/presentation/theme/theme.dart';
import 'package:amazon_clone_admin/core/models/marketing_campaign.dart';
import 'package:amazon_clone_admin/core/providers/marketing_providers.dart';
import 'package:intl/intl.dart';

import '../../core/models/user.dart';

class CampaignDashboardScreen extends HookConsumerWidget {
  const CampaignDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaigns = ref.watch(marketingCampaignsProvider);
    final selectedStatusFilter = useState<String?>(null);
    final searchTerm = useTextEditingController();
    final selectedDateRange = useState<DateRange?>(null);

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
            'Marketing Campaigns',
            style: TextStyle(
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.create),
              color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateCampaignScreen(),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
              onPressed: () => ref.read(marketingCampaignsProvider.notifier).fetchCampaigns(),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Campaign Overview',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFilterSection(
                  context,
                  searchTerm,
                  selectedStatusFilter,
                  selectedDateRange,
                  ref,
                ),
                const SizedBox(height: 24),
                campaigns.when(
                  data: (campaigns) {
                    if (campaigns.isEmpty) {
                      return const Center(
                        child: Text('No campaigns found'),
                      );
                    }
                    return _buildCampaignGrid(campaigns);
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateCampaignScreen(),
            ),
          ),
          label: const Text('Create Campaign'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildFilterSection(
      BuildContext context,
      TextEditingController searchTerm,
      ValueNotifier<String?> selectedStatusFilter,
      ValueNotifier<DateRange?> selectedDateRange,
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
                    controller: searchTerm,
                    decoration: InputDecoration(
                      labelText: 'Search campaigns',
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
                    onChanged: (value) => ref.read(marketingCampaignsProvider.notifier).filterBySearch(value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: selectedStatusFilter.value,
                    onChanged: (value) {
                      selectedStatusFilter.value = value;
                      ref.read(marketingCampaignsProvider.notifier).filterByStatus(value);
                    },
                    items: const [
                      DropdownMenuItem(
                        value: null,
                        child: Text('All Statuses'),
                      ),
                      DropdownMenuItem(
                        value: 'active',
                        child: Text('Active'),
                      ),
                      DropdownMenuItem(
                        value: 'scheduled',
                        child: Text('Scheduled'),
                      ),
                      DropdownMenuItem(
                        value: 'completed',
                        child: Text('Completed'),
                      ),
                      DropdownMenuItem(
                        value: 'paused',
                        child: Text('Paused'),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Status',
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
                  child: TextButton.icon(
                    icon: const Icon(Icons.date_range),
                    label: const Text('Select Date Range'),
                    onPressed: () async {
                      final range = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        initialDateRange: selectedDateRange.value == null
                            ? null
                            : DateTimeRange(
                          start: selectedDateRange.value!.start,
                          end: selectedDateRange.value!.end,
                        ),
                      );
                      if (range != null) {
                        selectedDateRange.value = DateRange(
                          range.start,
                          range.end,
                        );
                        ref.read(marketingCampaignsProvider.notifier).filterByDateRange(range);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                TextButton.icon(
                  icon: const Icon(Icons.filter_alt),
                  label: const Text('Reset Filters'),
                  onPressed: () {
                    searchTerm.text = '';
                    selectedStatusFilter.value = null;
                    selectedDateRange.value = null;
                    ref.read(marketingCampaignsProvider.notifier).resetFilters();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignGrid(List<MarketingCampaign> campaigns) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: campaigns.length,
      itemBuilder: (context, index) {
        final campaign = campaigns[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: _buildStatusIndicator(campaign.status),
            title: Text(
              campaign.name,
              style: const TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              '${campaign.targetAudience} • ${campaign.startDate} - ${campaign.endDate}',
              style: const TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            trailing: Text(
              '\$${campaign.budget.toStringAsFixed(2)}',
              style: const TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            onTap: () => _showCampaignDetails(context, campaign),
          ),
        );
      },
    );
  }

  Widget _buildStatusIndicator(String status) {
    IconData icon;
    Color color;

    switch (status) {
      case 'active':
        icon = Icons.play_circle;
        color = Colors.green;
        break;
      case 'scheduled':
        icon = Icons.access_time;
        color = Colors.orange;
        break;
      case 'completed':
        icon = Icons.check_circle;
        color = Colors.blue;
        break;
      case 'paused':
        icon = Icons.pause_circle;
        color = Colors.yellow;
        break;
      default:
        icon = Icons.help;
        color = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: color,
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  void _showCampaignDetails(BuildContext context, MarketingCampaign campaign) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(campaign.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Status: ${campaign.status}'),
              Text('Budget: \${campaign.budget.toStringAsFixed(2)}'),
              Text('Target Audience: ${campaign.targetAudience}'),
              Text('Start Date: ${campaign.startDate}'),
              Text('End Date: ${campaign.endDate}'),
              const Divider(),
              const Text('Performance Metrics'),
              const SizedBox(height: 8),
              Text('Impressions: ${campaign.metrics?.impressions ?? 'N/A'}'),
              Text('Clicks: ${campaign.metrics?.clicks ?? 'N/A'}'),
              Text('Conversion Rate: ${campaign.metrics?.conversionRate?.toStringAsFixed(2)}%'),
              Text('ROI: ${campaign.metrics?.roi?.toStringAsFixed(2)}%'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showEditCampaignDialog(context, campaign),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _showDeleteCampaignDialog(context, campaign),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _showMoreOptionsDialog(context, campaign),
                  ),
                ],
              )
            ],
          ),
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

  void _showEditCampaignDialog(BuildContext context, MarketingCampaign campaign) {
    // Implementation for editing campaign
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit campaign functionality coming soon!')),
    );
  }

  void _showDeleteCampaignDialog(BuildContext context, MarketingCampaign campaign) {
    // Implementation for deleting campaign
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete ${campaign.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implementation for deleting campaign
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showMoreOptionsDialog(BuildContext context, MarketingCampaign campaign) {
    // Implementation for more options
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('More options coming soon!')),
    );
  }
}

class CreateCampaignScreen extends HookConsumerWidget {
  const CreateCampaignScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final budgetController = useTextEditingController();
    final audienceController = useTextEditingController();
    final startDateController = useTextEditingController();
    final endDateController = useTextEditingController();
    final selectedStatus = useState<String>('active');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Campaign'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Campaign Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: budgetController,
              decoration: const InputDecoration(labelText: 'Budget'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: audienceController,
              decoration: const InputDecoration(labelText: 'Target Audience'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: startDateController,
              decoration: const InputDecoration(labelText: 'Start Date'),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  startDateController.text = DateFormat.yMd().format(date);
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: endDateController,
              decoration: const InputDecoration(labelText: 'End Date'),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 7)),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  endDateController.text = DateFormat.yMd().format(date);
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedStatus.value,
              onChanged: (value) => selectedStatus.value = value!,
              items: const [
                DropdownMenuItem(
                  value: 'active',
                  child: Text('Active'),
                ),
                DropdownMenuItem(
                  value: 'scheduled',
                  child: Text('Scheduled'),
                ),
                DropdownMenuItem(
                  value: 'paused',
                  child: Text('Paused'),
                ),
              ],
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final campaign = MarketingCampaign(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  status: selectedStatus.value,
                  budget: double.parse(budgetController.text),
                  targetAudience: audienceController.text,
                  startDate: startDateController.text,
                  endDate: endDateController.text,
                );
                ref.read(marketingCampaignsProvider.notifier).addCampaign(campaign);
                Navigator.pop(context);
              },
              child: const Text('Create Campaign'),
            ),
          ],
        ),
      ),
    );
  }
}