class Team {
  final String teamId;
  final List<Member> members;

  Team({required this.teamId, required this.members});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamId: json['teamId'],
      members: List<Member>.from(json['members'].map(
        (memberJson) => Member.fromJson(memberJson),
      )),
    );
  }
}

class Member {
  final String email;

  Member({required this.email});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(email: json['email']);
  }
}
