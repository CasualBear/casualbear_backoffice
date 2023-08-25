class UpdateTeamRequest {
  int userId;
  bool isVerified;
  bool isCheckedIn;

  UpdateTeamRequest({required this.userId, required this.isCheckedIn, required this.isVerified});

  factory UpdateTeamRequest.fromJson(Map<String, dynamic> json) {
    return UpdateTeamRequest(userId: json['userId'], isVerified: json['isVerified'], isCheckedIn: json['isCheckedIn']);
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'isVerified': isVerified, 'isCheckedIn': isCheckedIn};
  }
}
