class MarketingCampaign {
  final String id;
  final String name;
  final String status;
  final double budget;
  final String targetAudience;
  final String startDate;
  final String endDate;
  final MarketingCampaignMetrics? metrics;

  MarketingCampaign({
    required this.id,
    required this.name,
    required this.status,
    required this.budget,
    required this.targetAudience,
    required this.startDate,
    required this.endDate,
    this.metrics,
  });

  MarketingCampaign copyWith({
    String? name,
    String? status,
    double? budget,
    String? targetAudience,
    String? startDate,
    String? endDate,
    MarketingCampaignMetrics? metrics,
  }) {
    return MarketingCampaign(
      id: id,
      name: name ?? this.name,
      status: status ?? this.status,
      budget: budget ?? this.budget,
      targetAudience: targetAudience ?? this.targetAudience,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      metrics: metrics ?? this.metrics,
    );
  }
}

class MarketingCampaignMetrics {
  final int impressions;
  final int clicks;
  final double conversionRate;
  final double roi;

  MarketingCampaignMetrics({
    required this.impressions,
    required this.clicks,
    required this.conversionRate,
    required this.roi,
  });
}