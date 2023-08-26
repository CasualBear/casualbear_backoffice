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
