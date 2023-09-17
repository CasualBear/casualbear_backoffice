import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:casualbear_backoffice/network/models/team.dart';
import 'package:casualbear_backoffice/network/models/update_team_request.dart';
import 'package:casualbear_backoffice/network/models/user.dart';
import 'package:casualbear_backoffice/network/models/zones.dart';
import 'package:casualbear_backoffice/screens/events/cubit/team_cubit.dart';
import 'package:casualbear_backoffice/screens/events/widgets/team_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamDetailsWidget extends StatefulWidget {
  final Team team;
  final String eventId;

  const TeamDetailsWidget({super.key, required this.team, required this.eventId});

  @override
  TeamDetailsWidgetState createState() => TeamDetailsWidgetState();
}

class TeamDetailsWidgetState extends State<TeamDetailsWidget> {
  bool isCheckedIn = false;
  String? isValidated;
  List<Zones> zones = [];

  @override
  void initState() {
    isCheckedIn = widget.team.isCheckedIn;
    isValidated = widget.team.isVerified;
    zones = parseZones(widget.team.zones);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  value: isCheckedIn,
                  onChanged: (bool? newValue) {
                    setState(() {
                      isCheckedIn = newValue ?? false;
                    });
                  },
                ),
                const Text('Efetuar Check-in'),
                const SizedBox(width: 10),
                const Text('Validação', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                const SizedBox(width: 5),
                DropdownButton<String>(
                  value: isValidated ?? "Selecionar",
                  onChanged: (String? newValue) {
                    setState(() {
                      isValidated = newValue;
                    });
                  },
                  items: <String>['Selecionar', 'Validating', 'Approved', 'Denied']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                    onPressed: () {
                      List<UpdateTeamRequest> updatedFlags = [
                        UpdateTeamRequest(
                          teamId: widget.team.id,
                          isCheckedIn: isCheckedIn,
                          isVerified: isValidated!,
                        ),
                      ];
                      BlocProvider.of<TeamCubit>(context).updateTeamValidationAndCheckin(updatedFlags);

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Dados salvos, por favor confirme na lista da equipa"),
                      ));
                    },
                    child: const Text("Submteter Informação"))
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

                        BlocProvider.of<TeamCubit>(context).updateZonesByTeam(zones, widget.team.id.toString());
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'Elementos da Equipa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(width: 5),
                Visibility(
                  visible: (widget.team.members?.length)! < 4,
                  child: GestureDetector(
                    child: const Icon(Icons.add),
                    onTap: () async {
                      await Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => TeamEdit(
                            user: User(
                                id: 0,
                                name: '',
                                email: '',
                                role: null,
                                password: '',
                                dateOfBirth: DateTime(2000, 1, 1),
                                cc: '',
                                phone: '',
                                address: '',
                                nosCard: '',
                                tShirtSize: '',
                                isCheckedPrivacyData: false,
                                isCheckedTermsConditions: false,
                                isCaptain: false,
                                teamId: '',
                                createdAt: DateTime(2000, 1, 1),
                                updatedAt: DateTime(2000, 1, 1),
                                postalCode: ''),
                            teamId: widget.team.id,
                            isEdit: false,
                          ),
                        ),
                      );
                      // ignore: use_build_context_synchronously
                      BlocProvider.of<TeamCubit>(context).getTeamDetails(widget.eventId, widget.team.id.toString());
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
              child: Column(
                children: [
                  CarouselSlider.builder(
                    itemCount: widget.team.members?.length,
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
                                            builder: (BuildContext context) => TeamEdit(
                                                isEdit: true,
                                                user: widget.team.members![index],
                                                teamId: widget.team.id),
                                          ),
                                        );
                                        // ignore: use_build_context_synchronously
                                        BlocProvider.of<TeamCubit>(context)
                                            .getTeamDetails(widget.eventId, widget.team.id.toString());
                                      },
                                      child: const Text('Editar')),
                                ],
                              ),
                              Visibility(
                                visible: widget.team.members?[index].isCaptain ?? false,
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
                              _builtText('Name', widget.team.members?[index].name),
                              const SizedBox(height: 8),
                              _builtText('Email', widget.team.members?[index].email),
                              const SizedBox(height: 8),
                              _builtText('Cartão NOS', widget.team.members?[index].nosCard ?? "N/A"),
                              const SizedBox(height: 8),
                              _builtText('Tamanho T-Shirt', widget.team.members?[index].tShirtSize),
                              const SizedBox(height: 8),
                              _builtText('Data de Nascimento', widget.team.members?[index].dateOfBirth.toString()),
                              const SizedBox(height: 8),
                              _builtText('CC', widget.team.members?[index].cc),
                              const SizedBox(height: 8),
                              _builtText('Telefone', widget.team.members?[index].phone),
                              const SizedBox(height: 8),
                              _builtText('Código postal', widget.team.members?[index].postalCode),
                              const SizedBox(height: 8),
                              _builtText('Morada', widget.team.members?[index].address),
                              const SizedBox(height: 40),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        BlocProvider.of<TeamCubit>(context).deleteTeamMember(
                                            widget.team.id.toString(), widget.team.members![index].id.toString());
                                      },
                                      child: const Icon(Icons.delete, color: Colors.red))
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      padEnds: false,
                      height: 500,
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

  List<Zones> parseZones(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Zones>((json) => Zones(active: json['active'], name: json['name'])).toList();
  }
}
