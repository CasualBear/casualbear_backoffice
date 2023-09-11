part of 'team_cubit.dart';

@immutable
sealed class TeamState {}

final class TeamInitial extends TeamState {}

class UpdateTeamFlagsLoading extends TeamState {}

class UpdateTeamFlagsLoaded extends TeamState {
  UpdateTeamFlagsLoaded();
}

class UpdateTeamFlagsError extends TeamState {}

class UpdateTeamZonesLoading extends TeamState {}

class UpdateTeamZonesLoaded extends TeamState {
  UpdateTeamZonesLoaded();
}

class UpdateTeamZonesError extends TeamState {}

//  Get All the teams

class GetTeamsLoading extends TeamState {}

class GetTeamsLoaded extends TeamState {
  final List<Team>? teams;

  GetTeamsLoaded({this.teams});
}

class GetTeamsError extends TeamState {}

/// Update a memmber inside the team
class UpdateTeamMemberLoading extends TeamState {}

class UpdateTeamMemberLoaded extends TeamState {}

class UpdateTeamMemberError extends TeamState {}

/// Get Single Team
class GetTeamLoading extends TeamState {}

class GetTeamLoaded extends TeamState {
  final Team? team;

  GetTeamLoaded({this.team});
}

class GetTeamError extends TeamState {}
