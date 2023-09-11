// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:casualbear_backoffice/network/models/team.dart';
import 'package:casualbear_backoffice/network/models/update_team_request.dart';
import 'package:casualbear_backoffice/network/models/user.dart';
import 'package:casualbear_backoffice/network/models/zones.dart';
import 'package:casualbear_backoffice/repositories/team_repository.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'team_state.dart';

class TeamCubit extends Cubit<TeamState> {
  final TeamRepository repository;

  TeamCubit(this.repository) : super(TeamInitial());

  void updateTeamValidationAndCheckin(List<UpdateTeamRequest> updateTeamRequest) async {
    emit(UpdateTeamFlagsLoading());
    try {
      await repository.updateTeam(updateTeamRequest);
      emit(UpdateTeamFlagsLoaded());
    } catch (e) {
      emit(UpdateTeamFlagsError());
    }
  }

  void updateZonesByTeam(List<Zones> zones, String teamId) async {
    emit(UpdateTeamZonesLoading());
    try {
      await repository.updateTeamZones(zones, teamId);
      emit(UpdateTeamZonesLoaded());
    } catch (e) {
      emit(UpdateTeamZonesError());
    }
  }

  void getTeams(String eventId) async {
    emit(GetTeamsLoading());
    try {
      List<Team> response = await repository.getTeams(eventId);
      emit(GetTeamsLoaded(teams: response));
    } catch (e) {
      emit(GetTeamsError());
    }
  }

  void getTeamDetails(String eventId, String teamId) async {
    emit(GetTeamLoading());
    try {
      Team response = await repository.getTeamDetails(eventId, teamId);
      emit(GetTeamLoaded(team: response));
    } catch (e) {
      emit(GetTeamError());
    }
  }

  void updateTeamMember(User user) async {
    emit(UpdateTeamMemberLoading());
    try {
      await repository.updateTeamMember(user);
      emit(UpdateTeamMemberLoaded());
    } catch (e) {
      emit(UpdateTeamMemberError());
    }
  }
}
