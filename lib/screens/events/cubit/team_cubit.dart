import 'package:bloc/bloc.dart';
import 'package:casualbear_backoffice/network/models/update_team_request.dart';
import 'package:casualbear_backoffice/repositories/team_repository.dart';
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
}
