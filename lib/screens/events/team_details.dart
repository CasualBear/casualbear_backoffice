import 'dart:convert';

import 'package:casualbear_backoffice/network/models/team.dart';
import 'package:casualbear_backoffice/network/models/update_team_request.dart';
import 'package:casualbear_backoffice/network/models/zones.dart';
import 'package:casualbear_backoffice/screens/events/cubit/team_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamDetails extends StatefulWidget {
  final Team team;
  const TeamDetails({super.key, required this.team});

  @override
  State<TeamDetails> createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails> {
  String memberVerified = '';
  bool memberCheckedIn = false;
  String? isValidated;
  List<Zones> zones = [];

  @override
  void initState() {
    memberVerified = '';
    memberCheckedIn = widget.team.isCheckedIn;
    isValidated = widget.team.isVerified;
    zones = parseZones(widget.team.zones);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          title: Text(
            'Detalhes da Equipa ${widget.team.name}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Gestão de Checkins',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: memberCheckedIn,
                      onChanged: (bool? newValue) {
                        memberCheckedIn = newValue ?? false;
                        setState(() {});
                        List<UpdateTeamRequest> updatedFlags = [
                          UpdateTeamRequest(
                              teamId: widget.team.id, isCheckedIn: memberCheckedIn, isVerified: isValidated!)
                        ];
                        BlocProvider.of<TeamCubit>(context).updateTeamValidationAndCheckin(updatedFlags);
                      },
                    ),
                    const Text('Efetuar Check-in'),
                    const SizedBox(width: 10),
                    const Text('Validação', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    DropdownButton<String>(
                      value: isValidated ?? "Selecionar",
                      onChanged: (newValue) {
                        setState(() {
                          isValidated = newValue;
                        });
                        List<UpdateTeamRequest> updatedFlags = [
                          UpdateTeamRequest(
                              teamId: widget.team.id, isCheckedIn: memberCheckedIn, isVerified: isValidated!)
                        ];
                        BlocProvider.of<TeamCubit>(context).updateTeamValidationAndCheckin(updatedFlags);
                      },
                      items: <String>['Selecionar', 'Validating', 'Approved', 'Denied']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Gestão de Zonas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 350,
                  child: ListView.builder(
                      shrinkWrap: true, // Add this line
                      physics: const NeverScrollableScrollPhysics(), // Add this line
                      itemCount: zones.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: SwitchListTile(
                            tileColor: Colors.white,
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text(zones[index].name), const Divider()],
                            ),
                            value: zones[index].active,
                            onChanged: (bool value) {
                              setState(() {
                                zones[index].active = value;
                              });

                              BlocProvider.of<TeamCubit>(context).updateZonesByTeam(zones, widget.team.id.toString());
                            },
                          ),
                        );
                      }),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Elementos da Equipa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 300),
                  child: SizedBox(
                      height: widget.team.members?.length == 2
                          ? 500
                          : widget.team.members?.length == 3
                              ? 700
                              : widget.team.members?.length == 4
                                  ? 900
                                  : 900,
                      child: ListView.builder(
                        itemCount: widget.team.members?.length,
                        itemBuilder: (BuildContext context, int index) {
                          final teamMember = widget.team.members?[index];
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
                                  Visibility(
                                    visible: teamMember?.isCaptain ?? false,
                                    child: const Text(
                                      'Capitão',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  _builtText('Name', teamMember?.name),
                                  const SizedBox(height: 8),
                                  _builtText('Email', teamMember?.email),
                                  const SizedBox(height: 8),
                                  _builtText('Tamanho T-Shirt', teamMember?.tShirtSize),
                                  const SizedBox(height: 8),
                                  _builtText('Data de Nascimento', teamMember?.dateOfBirth.toString()),
                                  const SizedBox(height: 8),
                                  _builtText('CC', teamMember?.cc),
                                  const SizedBox(height: 8),
                                  _builtText('Telefone', teamMember?.phone),
                                  const SizedBox(height: 8),
                                  _builtText('Morada', teamMember?.address),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          );
                        },
                      )),
                ),
              ],
            ),
          ),
        ));
  }

  List<Zones> parseZones(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Zones>((json) => Zones(active: json['active'], name: json['name'])).toList();
  }

  _builtText(String title, text) {
    return Text.rich(
      TextSpan(
        text: '$title: ',
        style: const TextStyle(fontWeight: FontWeight.bold),
        children: <TextSpan>[
          TextSpan(
            text: text,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
