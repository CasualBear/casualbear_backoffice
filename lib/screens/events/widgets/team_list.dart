import 'package:casualbear_backoffice/screens/events/cubit/team_cubit.dart';
import 'package:casualbear_backoffice/screens/events/team_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import '../../../network/models/team.dart';

class TeamList extends StatefulWidget {
  final String eventId;
  const TeamList({super.key, required this.eventId});

  @override
  State<TeamList> createState() => _TeamListState();
}

class _TeamListState extends State<TeamList> {
  TextEditingController searchController = TextEditingController();
  bool isFirstEntrance = true;
  List<Team> filteredTeams = [];
  List<Team> allTeams = [];

  @override
  void initState() {
    if (isFirstEntrance) {
      BlocProvider.of<TeamCubit>(context).getTeams(widget.eventId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80, // Set the desired height here
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          "Equipas do Evento Discovery",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<TeamCubit, TeamState>(
        buildWhen: (previous, current) =>
            current is GetTeamsLoading || current is GetTeamsLoaded || current is GetTeamError,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetTeamsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetTeamsLoaded) {
            if (isFirstEntrance) {
              filteredTeams = List<Team>.from(state.teams as Iterable);
              allTeams = List<Team>.from(state.teams as Iterable);
              isFirstEntrance = false;
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'Procurar Equipas (Nome)',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        // Call filter function with updated input
                        _filterTeams(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'Equipas dentro do Evento',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      ElevatedButton(
                          onPressed: () {
                            exportToExcel(state.teams ?? []);
                          },
                          child: const Text("Exportar para Excel")),
                    ],
                  ),
                  const SizedBox(height: 8),
                  state.teams!.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredTeams.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (filteredTeams.isNotEmpty) {
                              return _buildTeamItem(filteredTeams[index]);
                            } else {
                              return const Text("Sem equipas inscritas");
                            }
                          },
                        )
                      : const Text("Sem equipas inscritas"),
                  const SizedBox(height: 10),
                ]),
              ),
            );
          } else {
            return const Text("Teams not found");
          }
        },
      ),
    );
  }

  void _filterTeams(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTeams = List<Team>.from(allTeams);
      } else {
        filteredTeams = allTeams.where((team) {
          return _teamMatchesQuery(team, query);
        }).toList();
      }
    });
  }

  bool _teamMatchesQuery(Team team, String query) {
    // Check if the team name matches the query
    if (team.name.toLowerCase().contains(query.toLowerCase())) {
      return true;
    }

    // Check if any member attributes match the query
    for (final member in team.members ?? []) {
      final searchableString =
          '${member.address},${member.email},${member.nosCard},${member.postalCode},${member.createdAt},${member.phone}';
      if (searchableString.toLowerCase().contains(query.toLowerCase())) {
        return true;
      }
    }

    return false;
  }

  _buildTeamItem(Team team) {
    return GestureDetector(
      onTap: () async {
        isFirstEntrance = true;
        await Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => TeamDetails(
              teamId: team.id.toString(),
              eventId: widget.eventId.toString(),
            ),
          ),
        );

        // ignore: use_build_context_synchronously
        BlocProvider.of<TeamCubit>(context).getTeams(widget.eventId);
      },
      child: Card(
        color: Colors.grey[200],
        child: ListTile(
          title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Nome da equipa: ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Text(team.name),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text('Criação:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Text(team.createdAt.toIso8601String(), style: const TextStyle(fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text('Team ID:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Text(team.id.toString(), style: const TextStyle(fontSize: 13)),
                  ],
                ),
                Row(
                  children: [
                    const Text('Estado:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Text(team.isVerified.isEmpty ? 'Equipa não verificada ⛔️' : team.isVerified,
                        style: TextStyle(
                            color: team.isVerified != "Approved" ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text('Check-in:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Text(!team.isCheckedIn ? 'N/A' : 'Checked-in ✅',
                        style: TextStyle(
                            color: !team.isCheckedIn ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text('Pontos actuais:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Text(team.totalPoints.toString()),
                  ],
                ),
                const SizedBox(height: 5),
              ]),
          trailing: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }

  void exportToExcel(List<Team> teams) {
    final csvData = StringBuffer();

    // Add headers
    csvData.writeln('TeamId,Nome, Verificacao, Check-in, Email, DataCriação');

    // Add data rows
    for (final team in teams) {
      csvData.writeln(
          '${team.id},${team.name},${team.isVerified},${team.isCheckedIn},${team.totalPoints},${team.createdAt}');
    }

    final blob = html.Blob([Uint8List.fromList(csvData.toString().codeUnits)]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'webbrowser'
      ..download = 'teams.csv'; // Specify the file name with a .csv extension
    anchor.click();

    html.Url.revokeObjectUrl(url);
  }
}
