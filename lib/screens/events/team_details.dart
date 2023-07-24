import 'package:casualbear_backoffice/screens/events/cubit/event_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamDetails extends StatefulWidget {
  final String teamId;
  const TeamDetails({super.key, required this.teamId});

  @override
  State<TeamDetails> createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails> {
  @override
  void initState() {
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
            return ListView.builder(
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
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Text("Not possible to load team members");
          }
        },
      ),
    );
  }
}
