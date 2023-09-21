part of 'live_location_cubit.dart';

abstract class LiveLocationState {}

class LiveLocationLoading extends LiveLocationState {}

class LiveLocationLoadingSelectedTeam extends LiveLocationState {}

class LiveLocationStartTime extends LiveLocationState {
  final DateTime startTime;

  LiveLocationStartTime(this.startTime);
}

class LiveLocationLoaded extends LiveLocationState {
  final List<LiveLocationTeam> teams;
  final Team? selectedTeam;
  final List<LatLng> selectedTeamLocations;

  LiveLocationLoaded(
    this.teams, {
    this.selectedTeam,
    this.selectedTeamLocations = const [],
  });
}

class LiveLocationError extends LiveLocationState {
  final String error;

  LiveLocationError(this.error);
}
