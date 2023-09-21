class TeamLocation {
  final int teamId;
  final double latitude;
  final double longitude;

  TeamLocation({
    required this.teamId,
    required this.latitude,
    required this.longitude,
  });

  factory TeamLocation.fromJson(Map<String, dynamic> json) {
    try {
      return TeamLocation(
        teamId: json['teamId'] as int,
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double,
      );
    } catch (e) {
      print('Team Location ERROR: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'teamId': teamId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
