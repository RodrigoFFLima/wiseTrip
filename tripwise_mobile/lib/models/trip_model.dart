class TripModel {
  final double distance;
  final double fuelCost;
  final double tollCost;
  final double totalCost;

  TripModel({
    required this.distance,
    required this.fuelCost,
    required this.tollCost,
    required this.totalCost,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      distance: (json['distance'] as num).toDouble(),
      fuelCost: (json['fuelCost'] as num).toDouble(),
      tollCost: (json['tollCost'] as num).toDouble(),
      totalCost: (json['totalCost'] as num).toDouble(),
    );
  }
}
