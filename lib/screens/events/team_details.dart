import 'package:casualbear_backoffice/network/models/team.dart';
import 'package:casualbear_backoffice/network/models/update_team_request.dart';
import 'package:casualbear_backoffice/screens/events/cubit/team_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/event_cubit.dart';

class TeamDetails extends StatefulWidget {
  final Team team;
  const TeamDetails({super.key, required this.team});

  @override
  State<TeamDetails> createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails> {
  String memberVerified = '';
  bool memberCheckedIn = false;

  @override
  void initState() {
    memberVerified = '';
    memberCheckedIn = widget.team.isCheckedIn;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Membros da Equipa'),
        ),
        body: Column(
          children: [
            const Text(
              'Gestão de Zonas - ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            //TODO transformar string em json array
            /*Column(
              children: widget.team.zones
                  .map((zone) => Card(
                        child: ListTile(
                          title: Text(zone.name),
                          trailing: Switch(
                            value: zone.active,
                            onChanged: (value) {
                              setState(() {
                                zone.active = value;
                              });

                              /*BlocProvider.of<EventCubit>(context)
                                  .updateZoneStates(widget.team.id, zone.name, zone.active);*/
                            },
                          ),
                        ),
                      ))
                  .toList(),
            ),*/
            Row(
              children: [
                Checkbox(
                  value: memberCheckedIn,
                  onChanged: (bool? newValue) {
                    memberCheckedIn = newValue ?? false;
                    List<UpdateTeamRequest> updatedFlags = [];

                    for (var element in widget.team.members) {
                      updatedFlags.add(
                          UpdateTeamRequest(userId: element.id, isCheckedIn: memberCheckedIn, isVerified: 'Approved'));
                    }

                    BlocProvider.of<TeamCubit>(context).updateTeamValidationAndCheckin(updatedFlags);
                  },
                ),
                const Text('Efetuar Check-in'),
              ],
            ),
            SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: widget.team.members.length,
                itemBuilder: (BuildContext context, int index) {
                  final teamMember = widget.team.members[index];
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
        ));
  }
}
