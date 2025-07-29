import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:amazon_clone_admin/core/models/marketing_campaign.dart';
import 'package:amazon_clone_admin/core/providers/marketing_providers.dart';

class CreateCampaignScreen extends HookConsumerWidget {
  const CreateCampaignScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = useState(0);
    final nameController = useTextEditingController();
    final budgetController = useTextEditingController();
    final audienceController = useTextEditingController();
    final startDateController = useTextEditingController();
    final endDateController = useTextEditingController();
    final selectedStatus = useState<String>('active');
    final selectedDemographics = useState<List<String>>([]);
    final selectedBehaviors = useState<List<String>>([]);

    void _goToNextStep() {
      if (currentStep.value < 4) {
        currentStep.value += 1;
      }
    }

    void _goToPreviousStep() {
      if (currentStep.value > 0) {
        currentStep.value -= 1;
      }
    }

    void _completeCampaignCreation() {
      final campaign = MarketingCampaign(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        status: selectedStatus.value,
        budget: double.parse(budgetController.text),
        targetAudience: audienceController.text,
        startDate: startDateController.text,
        endDate: endDateController.text,
        metrics: MarketingCampaignMetrics(
          impressions: 0,
          clicks: 0,
          conversionRate: 0.0,
          roi: 0.0,
        ),
      );
      ref.read(marketingCampaignsProvider.notifier).addCampaign(campaign);
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Create Marketing Campaign'),
        actions: [
          if (currentStep.value == 4)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _completeCampaignCreation,
            ),
        ],
      ),
      body: Stepper(
        currentStep: currentStep.value,
        onStepContinue: _goToNextStep,
        onStepCancel: _goToPreviousStep,
        onStepTapped: (step) => currentStep.value = step,
        steps: [
          _buildStep1(nameController),
          _buildStep2(selectedDemographics),
          _buildStep3(selectedBehaviors),
          _buildStep4(budgetController, audienceController),
          _buildStep5(context, startDateController, endDateController, selectedStatus),
        ],
        controlsBuilder: (context, details) {
          return const SizedBox();
        },
      ),
    );
  }

  Step _buildStep1(TextEditingController nameController) {
    return Step(
      title: const Text('Campaign Information'),
      content: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Campaign Name'),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Campaign Description',
              hintText: 'Enter a brief description of your campaign',
            ),
            maxLines: 3,
          ),
        ],
      ),
      isActive: true,
    );
  }

  Step _buildStep2(ValueNotifier<List<String>> selectedDemographics) {
    const demographicOptions = [
      'Age 18-24',
      'Age 25-34',
      'Age 35-44',
      'Age 45-54',
      'Age 55+',
      'Male',
      'Female',
      'Location - Urban',
      'Location - Suburban',
      'Location - Rural',
      'Income Level - Low',
      'Income Level - Medium',
      'Income Level - High',
      'Education - High School',
      'Education - College',
      'Education - Graduate',
    ];

    return Step(
      title: const Text('Target Demographics'),
      content: Column(
        children: [
          const Text('Select the demographics for your target audience:'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: demographicOptions.map((option) {
              final isSelected = selectedDemographics.value.contains(option);
              return FilterChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (value) {
                  if (value) {
                    selectedDemographics.value.add(option);
                  } else {
                    selectedDemographics.value.remove(option);
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
      isActive: true,
    );
  }

  Step _buildStep3(ValueNotifier<List<String>> selectedBehaviors) {
    const behaviorOptions = [
      'Previous Purchasers',
      'Browse Abandoners',
      'Cart Abandoners',
      'Loyal Customers',
      'New Visitors',
      'High Engagers',
      'Low Engagers',
      'Discount Seekers',
      'Mobile Users',
      'Desktop Users',
    ];

    return Step(
      title: const Text('Target Behaviors'),
      content: Column(
        children: [
          const Text('Select the behaviors for your target audience:'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: behaviorOptions.map((option) {
              final isSelected = selectedBehaviors.value.contains(option);
              return FilterChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (value) {
                  if (value) {
                    selectedBehaviors.value.add(option);
                  } else {
                    selectedBehaviors.value.remove(option);
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
      isActive: true,
    );
  }

  Step _buildStep4(TextEditingController budgetController, TextEditingController audienceController) {
    return Step(
      title: const Text('Budget and Audience'),
      content: Column(
        children: [
          TextField(
            controller: budgetController,
            decoration: const InputDecoration(labelText: 'Campaign Budget'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: audienceController,
            decoration: const InputDecoration(labelText: 'Target Audience Size'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(labelText: 'Audience Segmentation'),
            maxLines: 3,
          ),
        ],
      ),
      isActive: true,
    );
  }

  Step _buildStep5(
      BuildContext context,
      TextEditingController startDateController,
      TextEditingController endDateController,
      ValueNotifier<String> selectedStatus,
      ) {
    return Step(
      title: const Text('Schedule and Status'),
      content: Column(
        children: [
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
            decoration: const InputDecoration(labelText: 'Initial Status'),
          ),
        ],
      ),
      isActive: true,
    );
  }
}