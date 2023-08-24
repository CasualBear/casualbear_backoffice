class UpdateTeamRequest {
  int id;
  bool isVerified;
  bool isCheckedIn;

  UpdateTeamRequest({required this.id, required this.isCheckedIn, required this.isVerified});

  factory UpdateTeamRequest.fromJson(Map<String, dynamic> json) {
    return UpdateTeamRequest(id: json['id'], isVerified: json['isVerified'], isCheckedIn: json['isCheckedIn']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'isVerified': isVerified, 'isCheckedIn': isCheckedIn};
  }
}
