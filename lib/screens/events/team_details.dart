import 'package:casualbear_backoffice/network/models/update_team_request.dart';
import 'package:casualbear_backoffice/screens/events/cubit/event_cubit.dart';
import 'package:casualbear_backoffice/screens/events/cubit/team_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamDetails extends StatefulWidget {
  final String teamId;
  final bool isCheckedin;
  final bool isVerified;
  const TeamDetails({super.key, required this.teamId, required this.isCheckedin, required this.isVerified});

  @override
  State<TeamDetails> createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails> {
  bool memberVerified = false;
  bool memberCheckedIn = false;

  @override
  void initState() {
    memberVerified = widget.isVerified;
    memberCheckedIn = widget.isCheckedin;
    BlocProvider.of<EventCubit>(context).getUsersByTeam(widget.teamId.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membros da Equipa'),
      ),
      body: BlocConsumer<EventCubit, EventState>(
        listener: (context, state) {},
        buildWhen: (previous, current) =>
            current is GetTeamMemberLoading || current is GetTeamMemberLoaded || current is GetTeamMemberError,
        builder: (context, state) {
          if (state is GetTeamMemberLoading) {
            return const CircularProgressIndicator();
          } else if (state is GetTeamMemberLoaded) {
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Column(
                children: [
                  BlocConsumer<TeamCubit, TeamState>(
                    listenWhen: (previous, current) => current is UpdateTeamFlagsLoaded,
                    buildWhen: (previous, current) =>
                        current is UpdateTeamFlagsLoading ||
                        current is UpdateTeamFlagsError ||
                        current is UpdateTeamFlagsLoaded,
                    listener: (context, teamState) {
                      if (teamState is UpdateTeamFlagsLoaded) {
                        setState(() {});
                      }
                    },
                    builder: (context, teamState) {
                      if (teamState is UpdateTeamFlagsLoading) {
                        return const CircularProgressIndicator();
                      }
                      return Row(
                        children: [
                          Checkbox(
                            value: memberVerified,
                            onChanged: (bool? newValue) {
                              memberVerified = newValue ?? false;
                              List<UpdateTeamRequest> updatedFlags = [];

                              for (var element in state.teamMembers) {
                                updatedFlags.add(UpdateTeamRequest(
                                    id: element.id, isCheckedIn: memberCheckedIn, isVerified: memberVerified));
                              }

                              BlocProvider.of<TeamCubit>(context).updateTeamValidationAndCheckin(updatedFlags);
                            },
                          ),
                          const Text('Verificar Equipa'),
                          const SizedBox(width: 5),
                          Checkbox(
                            value: memberCheckedIn,
                            onChanged: (bool? newValue) {
                              memberCheckedIn = newValue ?? false;
                              List<UpdateTeamRequest> updatedFlags = [];

                              for (var element in state.teamMembers) {
                                updatedFlags.add(UpdateTeamRequest(
                                    id: element.id, isCheckedIn: memberCheckedIn, isVerified: memberVerified));
                              }

                              BlocProvider.of<TeamCubit>(context).updateTeamValidationAndCheckin(updatedFlags);
                            },
                          ),
                          const Text('Efetuar Check-in'),
                        ],
                      );
                    },
                  ),
                  SizedBox(
                    height: 500,
                    child: ListView.builder(
                      itemCount: state.teamMembers.length,
                      itemBuilder: (BuildContext context, int index) {
                        final teamMember = state.teamMembers[index];
                        return Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name: ${teamMember.name}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('Email: ${teamMember.email}'),
                                const SizedBox(height: 8),
                                Text('T-Shirt Size: ${teamMember.tShirtSize}'),
                                const SizedBox(height: 8),
                                Text('Date of Birth: ${teamMember.dateOfBirth}'),
                                const SizedBox(height: 8),
                                Text('CC: ${teamMember.cc}'),
                                const SizedBox(height: 8),
                                Text('Phone: ${teamMember.phone}'),
                                const SizedBox(height: 8),
                                Text('Address: ${teamMember.address}'),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Text("Not possible to load team members");
          }
        },
      ),
    );
  }
}
