class Team {
  final String teamId;

  Team({required this.teamId});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamId: json['teamId'],
    );
  }
}

class TeamMember {
  final int id;
  final String name;
  final String dateOfBirth;
  final String cc;
  final String phone;
  final String address;
  final String email;
  final String nosCard;
  final String tShirtSize;
  final String teamId;
  final String createdAt;
  final String updatedAt;
  final int eventId;

  TeamMember({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.cc,
    required this.phone,
    required this.address,
    required this.email,
    required this.nosCard,
    required this.tShirtSize,
    required this.teamId,
    required this.createdAt,
    required this.updatedAt,
    required this.eventId,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'],
      name: json['name'],
      dateOfBirth: json['dateOfBirth'],
      cc: json['cc'],
      phone: json['phone'],
      address: json['address'],
      email: json['email'],
      nosCard: json['nosCard'],
      tShirtSize: json['tShirtSize'],
      teamId: json['teamId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      eventId: json['event_id'],
    );
  }
}
