import 'dart:async';
import 'dart:convert';

import 'package:casualbear_backoffice/local_storage.dart';
import 'package:casualbear_backoffice/network/models/team.dart';
import 'package:casualbear_backoffice/network/models/team_location.dart';
import 'package:casualbear_backoffice/network/services/api_service.dart';
import 'package:casualbear_backoffice/network/socket_manager.dart';
import 'package:casualbear_backoffice/repositories/team_repository.dart';
import 'package:casualbear_backoffice/screens/events/live_location/models/live_location_team.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

part 'live_location_state.dart';

class LiveLocationCubit extends Cubit<LiveLocationState> {
  final TeamRepository _teamRepository =
      TeamRepository(apiService: ApiService.shared);
  final SocketManager socketManager = SocketManager();
  final Map<int, Team> teams = {};
  final Map<int, List<LatLng>> teamLocations = {};
  late StreamSubscription _subscription;
  int? selectedTeamId;

  LiveLocationCubit() : super(LiveLocationLoading()) {
    _getTeams();

    // Emitting every 10 seconds a list of teams and their current location
    _subscription =
        Stream.periodic(const Duration(seconds: 10), (count) => count).listen(
      (_) => emitLoaded(),
    );

    socketManager.dataStream.listen((dataPacket) {
      final EventType eventType = dataPacket.eventType;
      final dynamic data = dataPacket.data;

      switch (eventType) {
        case EventType.location:
          try {
            final Map<String, dynamic> jsonMap = json.decode(data);
            final TeamLocation teamLocation = TeamLocation.fromJson(jsonMap);
            final LatLng latLng =
                LatLng(teamLocation.latitude, teamLocation.longitude);

            teamLocations.update(
              teamLocation.teamId,
              (value) => [...value, latLng],
              ifAbsent: () => [latLng],
            );
          } catch (e) {
            emit(LiveLocationError(e.toString()));
          }
          break;
        case EventType.gameStarted:
          Map<String, dynamic> jsonMap = json.decode(data);
          final timeMilliseconds = jsonMap['eventInitHour'];
          final DateTime startTime =
              DateTime.fromMillisecondsSinceEpoch(timeMilliseconds);
          emit(LiveLocationStartTime(startTime));
        default:
          break;
      }
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  /// Selects a team to show on the map
  Future<void> selectTeam(int teamId) async {
    try {
      emit(LiveLocationLoadingSelectedTeam());
      final List<LatLng> locations =
          await _teamRepository.getTeamLocations(teamId);
      final Team team =
          await _teamRepository.getTeamDetails('1', teamId.toString());
      selectedTeamId = teamId;
      teams[teamId] = team;
      teamLocations[teamId] = locations;

      emitLoaded();
    } catch (e) {
      emit(LiveLocationError(e.toString()));
    }
  }

  /// Deselects the currently selected team
  Future<void> deselectTeam() async {
    try {
      emit(LiveLocationLoadingSelectedTeam());
      selectedTeamId = null;

      emit(LiveLocationLoaded(
        _getLiveLocationTeams(),
        selectedTeam: null,
        selectedTeamLocations: [],
      ));
    } catch (e) {
      emit(LiveLocationError(e.toString()));
    }
  }

  /// Creates LiveLocationTeam objects from the teams and locations
  List<LiveLocationTeam> _getLiveLocationTeams() {
    try {
      final liveLocationTeams = teams.values
          .map((team) => LiveLocationTeam(
                team: team,
                location: teamLocations[team.id]?.last,
              ))
          .toList();
      return liveLocationTeams;
    } catch (e) {
      return [];
    }
  }

  /// Gets the teams for the current event
  Future<void> _getTeams() async {
    emit(LiveLocationLoading());
    try {
      // Warning: Hardcoded to event 1 for now
      final List<Team> teams = await _teamRepository.getTeams('1');
      for (Team team in teams) {
        this.teams[team.id] = team;
      }
      emitLoaded();
    } catch (e) {
      emit(LiveLocationError(e.toString()));
    }
  }

  Future<void> getStartTime() async {
    final int? teamId = getTeamId();
    // Get team details to update the start time (model doesn't have the eventInitHour)
    await _teamRepository.getTeamDetails('1', teamId.toString());
    final startTime = getGameStartTime();
    if (startTime != null) {
      emit(LiveLocationStartTime(startTime));
    }
  }

  void emitLoaded() => emit(LiveLocationLoaded(
        _getLiveLocationTeams(),
        selectedTeam: teams[selectedTeamId],
        selectedTeamLocations: teamLocations[selectedTeamId] ?? [],
      ));
}
