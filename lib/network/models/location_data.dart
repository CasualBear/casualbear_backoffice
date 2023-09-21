class LocationData {
  final int id;
  final int teamId;
  final double latitude;
  final double longitude;
  final String createdAt;
  final String updatedAt;

  LocationData({
    required this.id,
    required this.teamId,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      id: json['id'] as int,
      teamId: json['teamId'] as int,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }
}