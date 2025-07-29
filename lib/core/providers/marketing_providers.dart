import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amazon_clone_admin/core/models/marketing_campaign.dart';

final marketingCampaignsProvider = StateNotifierProvider<CampaignNotifier, AsyncValue<List<MarketingCampaign>>>((ref) {
  return CampaignNotifier();
});

class CampaignNotifier extends StateNotifier<AsyncValue<List<MarketingCampaign>>> {
  CampaignNotifier() : super(const AsyncValue.loading()) {
    fetchCampaigns();
  }

  Future<void> fetchCampaigns() async {
    try {
      state = const AsyncValue.loading();
      await Future.delayed(const Duration(seconds: 1));
      state = AsyncValue.data([
        MarketingCampaign(
          id: '1',
          name: 'Summer Sale',
          status: 'active',
          budget: 10000.00,
          targetAudience: '18-35 year olds',
          startDate: '2023-06-01',
          endDate: '2023-07-15',
          metrics: MarketingCampaignMetrics(
            impressions: 150000,
            clicks: 5000,
            conversionRate: 3.2,
            roi: 12.5,
          ),
        ),
        MarketingCampaign(
          id: '2',
          name: 'Back to School',
          status: 'scheduled',
          budget: 8000.00,
          targetAudience: 'Students and Parents',
          startDate: '2023-08-01',
          endDate: '2023-08-31',
          metrics: MarketingCampaignMetrics(
            impressions: 0,
            clicks: 0,
            conversionRate: 0.0,
            roi: 0.0,
          ),
        ),
        MarketingCampaign(
          id: '3',
          name: 'Holiday Special',
          status: 'completed',
          budget: 15000.00,
          targetAudience: 'Everyone',
          startDate: '2022-12-01',
          endDate: '2022-12-25',
          metrics: MarketingCampaignMetrics(
            impressions: 300000,
            clicks: 12000,
            conversionRate: 5.8,
            roi: 22.3,
          ),
        ),
      ]);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void addCampaign(MarketingCampaign campaign) {
    state = state.whenData((campaigns) => [...campaigns, campaign]);
  }

  void updateCampaign(MarketingCampaign campaign) {
    state = state.whenData((campaigns) => campaigns.map((e) => e.id == campaign.id ? campaign : e).toList());
  }

  void deleteCampaign(String id) {
    state = state.whenData((campaigns) => campaigns.where((campaign) => campaign.id != id).toList());
  }

  void filterBySearch(String query) {
    state = state.whenData((campaigns) {
      if (query.isEmpty) {
        return campaigns;
      }
      return campaigns.where((campaign) =>
      campaign.name.toLowerCase().contains(query.toLowerCase()) ||
          campaign.targetAudience.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void filterByStatus(String? status) {
    state = state.whenData((campaigns) {
      if (status == null) {
        return campaigns;
      }
      return campaigns.where((campaign) => campaign.status == status).toList();
    });
  }

  void filterByDateRange(DateTimeRange dateRange) {
    state = state.whenData((campaigns) {
      return campaigns.where((campaign) {
        final campaignStart = DateTime.parse(campaign.startDate);
        final campaignEnd = DateTime.parse(campaign.endDate);
        return campaignEnd.isAfter(dateRange.start) && campaignStart.isBefore(dateRange.end);
      }).toList();
    });
  }

  void resetFilters() {
    fetchCampaigns();
  }
}

final filteredMarketingCampaignsProvider = StateNotifierProvider<FilteredCampaignsNotifier, AsyncValue<List<MarketingCampaign>>>((ref) {
  final campaigns = ref.watch(marketingCampaignsProvider);
  return FilteredCampaignsNotifier(campaigns);
});

class FilteredCampaignsNotifier extends StateNotifier<AsyncValue<List<MarketingCampaign>>> {
  FilteredCampaignsNotifier(AsyncValue<List<MarketingCampaign>> campaigns) : super(campaigns);

  void updateSearchQuery(String query) {
    state = state.whenData((campaigns) {
      if (query.isEmpty) {
        return campaigns;
      }
      return campaigns.where((campaign) =>
      campaign.name.toLowerCase().contains(query.toLowerCase()) ||
          campaign.targetAudience.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void updateStatusFilter(String? status) {
    state = state.whenData((campaigns) {
      if (status == null) {
        return campaigns;
      }
      return campaigns.where((campaign) => campaign.status == status).toList();
    });
  }

  void resetFilters() {
    state = state.whenData((campaigns) => campaigns);
  }
}
