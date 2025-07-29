class ChartData {
  final String day;
  final double value;

  ChartData(this.day, this.value);


  Map<String, dynamic> toJson() => {
    'day': day,
    'value': value,
  };

  factory ChartData.fromJson(Map<String, dynamic> json) => ChartData(
    json['day'] as String,
    json['value'] as double,
  );

  ChartData copyWith({
    String? day,
    double? value,
  }) {
    return ChartData(
      day ?? this.day,
      value ?? this.value,
    );
  }

  @override
  String toString() => 'ChartData(day: $day, value: $value)';
}