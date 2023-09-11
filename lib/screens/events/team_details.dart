import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:casualbear_backoffice/network/models/team.dart';
import 'package:casualbear_backoffice/network/models/update_team_request.dart';
import 'package:casualbear_backoffice/network/models/zones.dart';
import 'package:casualbear_backoffice/screens/events/cubit/team_cubit.dart';
import 'package:casualbear_backoffice/screens/events/widgets/team_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamDetails extends StatefulWidget {
  final String eventId;
  final String teamId;
  const TeamDetails({super.key, required this.eventId, required this.teamId});

  @override
  State<TeamDetails> createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails> {
  String memberVerified = '';
  bool memberCheckedIn = false;
  String? isValidated;
  List<Zones> zones = [];
  Team? team;

  @override
  void initState() {
    BlocProvider.of<TeamCubit>(context).getTeamDetails(widget.eventId, widget.teamId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          title: const Text(
            'Detalhes da Equipa',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        body: BlocConsumer<TeamCubit, TeamState>(
          buildWhen: (previous, current) =>
              current is GetTeamLoaded || current is GetTeamError || current is GetTeamLoading,
          listener: (context, state) {},
          builder: (context, state) {
            if (state is GetTeamLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetTeamLoaded) {
              team = state.team;
              memberVerified = '';
              memberCheckedIn = team!.isCheckedIn;
              isValidated = team!.isVerified;
              zones = parseZones(team!.zones);
              return Padding(
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
                                    teamId: team!.id, isCheckedIn: memberCheckedIn, isVerified: isValidated!)
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
                                    teamId: team!.id, isCheckedIn: memberCheckedIn, isVerified: isValidated!)
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
                      Column(
                        children: [
                          for (int index = 0; index < zones.length; index++)
                            Card(
                              child: SwitchListTile(
                                tileColor: Colors.white,
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(zones[index].name),
                                    const Divider(),
                                  ],
                                ),
                                value: zones[index].active,
                                onChanged: (bool value) {
                                  setState(() {
                                    zones[index].active = value;
                                  });

                                  BlocProvider.of<TeamCubit>(context).updateZonesByTeam(zones, team!.id.toString());
                                },
                              ),
                            ),
                        ],
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
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
                        child: Column(
                          children: [
                            CarouselSlider.builder(
                              itemCount: team!.members?.length,
                              itemBuilder: (BuildContext context, int index, int realIndex) {
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
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            InkWell(
                                                onTap: () async {
                                                  await Navigator.push<void>(
                                                    context,
                                                    MaterialPageRoute<void>(
                                                      builder: (BuildContext context) =>
                                                          TeamEdit(user: team!.members![index]),
                                                    ),
                                                  );
                                                  // ignore: use_build_context_synchronously
                                                  BlocProvider.of<TeamCubit>(context)
                                                      .getTeamDetails(widget.eventId, widget.teamId);
                                                },
                                                child: const Text('Editar')),
                                          ],
                                        ),
                                        Visibility(
                                          visible: team!.members?[index].isCaptain ?? false,
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
                                        _builtText('Name', team!.members?[index].name),
                                        const SizedBox(height: 8),
                                        _builtText('Email', team!.members?[index].email),
                                        const SizedBox(height: 8),
                                        _builtText('Cartão NOS', team!.members?[index].nosCard ?? "N/A"),
                                        const SizedBox(height: 8),
                                        _builtText('Tamanho T-Shirt', team!.members?[index].tShirtSize),
                                        const SizedBox(height: 8),
                                        _builtText('Data de Nascimento', team!.members?[index].dateOfBirth.toString()),
                                        const SizedBox(height: 8),
                                        _builtText('CC', team!.members?[index].cc),
                                        const SizedBox(height: 8),
                                        _builtText('Telefone', team!.members?[index].phone),
                                        const SizedBox(height: 8),
                                        _builtText('Código postal', team!.members?[index].postalCode),
                                        const SizedBox(height: 8),
                                        _builtText('Morada', team!.members?[index].address),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                padEnds: false,
                                height: 400,
                                aspectRatio: 2.0, // Adjust aspectRatio to your preference
                                viewportFraction: 0.2, // Adjust viewportFraction to your preference
                                enableInfiniteScroll: false, // Disable infinite scroll
                                autoPlay: false, // Disable auto-play
                                initialPage: 0, // Set the initial page to 0 (start on the left)
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Text("Não foi possivel carregar os detalhes da equipa");
            }
          },
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
