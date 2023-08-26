import 'package:json_annotation/json_annotation.dart';

part 'update_team_request.g.dart';

@JsonSerializable()
class UpdateTeamRequest {
  int teamId;
  String isVerified;
  bool isCheckedIn;

  UpdateTeamRequest({required this.teamId, required this.isCheckedIn, required this.isVerified});

  factory UpdateTeamRequest.fromJson(Map<String, dynamic> json) => _$UpdateTeamRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateTeamRequestToJson(this);
}
