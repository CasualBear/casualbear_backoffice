import 'dart:async';
import 'dart:math';

import 'package:casualbear_backoffice/network/models/team.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TeamMap extends StatelessWidget {
  final List<Team> teams;
  final ValueNotifier<Team?> selectedTeam = ValueNotifier(null);
  final StreamController<Map<Team, LatLng>> lastTeamPosition =
      StreamController<Map<Team, LatLng>>.broadcast();

  TeamMap({super.key, required this.teams});

  @override
  Widget build(BuildContext context) {
    // TODO: remove this future delayed, it's just an example
    Future.delayed(const Duration(seconds: 2), () {
      addTeamPositions();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localização das equipas'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: StreamBuilder<Map<Team, LatLng>>(
                stream: lastTeamPosition.stream,
                builder: (context, snapshot) {
                  return _buildMap(context, lastTeamsPosition: snapshot.data);
                }),
          ),
          Expanded(
            flex: 1,
            child: _buildTeamDetails(context),
          ),
        ],
      ),
    );
  }

  // Function to generate random coordinates in the Lisbon area
  LatLng generateRandomCoordinates() {
    final Random random = Random();
    // Adjust these latitude and longitude values to fit the Lisbon area
    final double latitude =
        38.716670 + (random.nextDouble() - 0.5) / 10; // Example latitude range
    final double longitude =
        -9.133330 + (random.nextDouble() - 0.5) / 10; // Example longitude range
    return LatLng(latitude, longitude);
  }

// Add team positions to the stream
  void addTeamPositions() {
    final Map<Team, LatLng> teamPositions = {};
    for (final team in teams) {
      final LatLng randomCoordinates = generateRandomCoordinates();
      teamPositions[team] = randomCoordinates;
    }
    lastTeamPosition.add(teamPositions);
  }

  Future<List<LatLng>> getTeamPositions(Team team) async {
    // TODO: implement getTeamPositions
    await Future.delayed(const Duration(seconds: 1));
    // Dummy list of LatLng
    return const [
      LatLng(38.707121, -9.135305), // Start position
      LatLng(38.707075, -9.135415),
      LatLng(38.706993, -9.135595),
      LatLng(38.706919, -9.135758),
      LatLng(38.706844, -9.135918),
      LatLng(38.706783, -9.136036),
      LatLng(38.706697, -9.136217),
      LatLng(38.706620, -9.136375),
      LatLng(38.706566, -9.136484),
      LatLng(38.706482, -9.136664),
      LatLng(38.706405, -9.136821),
      LatLng(38.706335, -9.136963),
      LatLng(38.706263, -9.137107),
      LatLng(38.706189, -9.137252),
      LatLng(38.706129, -9.137369),
      LatLng(38.706057, -9.137514),
      LatLng(38.705980, -9.137670),
      LatLng(38.705906, -9.137815),
      LatLng(38.705843, -9.137926),
      LatLng(38.705763, -9.138076),
      LatLng(38.705681, -9.138237),
      LatLng(38.705598, -9.138401),
      LatLng(38.705529, -9.138542),
      LatLng(38.705455, -9.138689),
      LatLng(38.705373, -9.138850),
      LatLng(38.705290, -9.139012),
      LatLng(38.705218, -9.139150),
      LatLng(38.705135, -9.139312),
      LatLng(38.705065, -9.139449),
      LatLng(38.704984, -9.139609),
      LatLng(38.704908, -9.139754),
      LatLng(38.704830, -9.139900),
      LatLng(38.704762, -9.140034),
      LatLng(38.704687, -9.140179),
      LatLng(38.704617, -9.140317),
      LatLng(38.704539, -9.140464),
      LatLng(38.704463, -9.140610),
      LatLng(38.704392, -9.140750),
      LatLng(38.704318, -9.140894),
      LatLng(38.704243, -9.141039),
      LatLng(38.704166, -9.141184),
      LatLng(38.704090, -9.141330),
      LatLng(38.704017, -9.141468),
      LatLng(38.703943, -9.141609),
      LatLng(38.703869, -9.141750),
      LatLng(38.703797, -9.141886),
      LatLng(38.703722, -9.142028),
      LatLng(38.703649, -9.142165),
      LatLng(38.703572, -9.142306),
      LatLng(38.703496, -9.142447),
      LatLng(38.703421, -9.142588),
      LatLng(38.703347, -9.142730),
      LatLng(38.703274, -9.142870),
      LatLng(38.703197, -9.143009),
      LatLng(38.703121, -9.143150),
      LatLng(38.703046, -9.143290),
      LatLng(38.702971, -9.143430),
      LatLng(38.702895, -9.143571),
      LatLng(38.702822, -9.143711),
      LatLng(38.702746, -9.143851),
      LatLng(38.702671, -9.143991),
      LatLng(38.702595, -9.144131),
      LatLng(38.702520, -9.144272),
      LatLng(38.702443, -9.144412),
      LatLng(38.702369, -9.144552),
      LatLng(38.702296, -9.144693),
      LatLng(38.702220, -9.144833),
      LatLng(38.702145, -9.144973),
    ];
  }

  /// Builds the team details.
  Widget _buildTeamDetails(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedTeam,
      builder: (context, team, child) {
        if (team == null) {
          return Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Seleciona uma equipa',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 40),
                Text(
                  'Terá acesso aos detalhes da equipa e o último percurso que efectuaram no mapa.',
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ],
            ),
          );
        }

        return Column(
          children: [
            const Spacer(),
            Text(
              team.name,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Pontos: ${team.totalPoints}',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 20),
            ...(team.members ?? [])
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text('${e.name} - ${e.email}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: e.isCaptain ? Colors.blue : Colors.grey)),
                  ),
                )
                .toList(),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(40),
              child: TextButton(
                  onPressed: () {
                    selectedTeam.value = null;
                  },
                  child: const Text('Limpar selecção')),
            ),
          ],
        );
      },
    );
  }

  /// Builds the map with the teams.
  Widget _buildMap(BuildContext context,
      {Map<Team, LatLng>? lastTeamsPosition}) {
    // Event HQ
    const LatLng latLng = LatLng(38.707962, -9.138409);

    return FlutterMap(
      options: MapOptions(
        keepAlive: true,
        center: latLng,
        maxZoom: 18,
        zoom: 14,
      ),
      nonRotatedChildren: const [
        Positioned(top: 20, left: 20, child: _CountdownWidget()),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'pt.wbdday.backoffice',
        ),
        ValueListenableBuilder(
            valueListenable: selectedTeam,
            builder: (context, value, child) {
              if (value == null) {
                return const SizedBox();
              }
              return FutureBuilder(
                  future: getTeamPositions(selectedTeam.value!),
                  builder: (context, snapshot) {
                    print('Building polyline');
                    if (snapshot.hasData == false) {
                      return const SizedBox();
                    }

                    return PolylineLayer(
                      polylines: [
                        Polyline(
                          points: snapshot.data as List<LatLng>,
                          strokeWidth: 5,
                          color: Colors.blueAccent,
                        ),
                      ],
                    );
                  });
            }),
        ValueListenableBuilder(
            valueListenable: selectedTeam,
            builder: (context, value, child) {
              return MarkerLayer(
                rotate: true,
                markers: teams.map((team) {
                  final teamPosition = lastTeamsPosition?[team];
                  return _buildMarkerForTeam(team,
                      position: teamPosition ?? latLng);
                }).toList(),
              );
            }),
      ],
    );
  }

  /// Builds a marker from a question.
  Marker _buildMarkerForTeam(Team team, {required LatLng position}) {
    return Marker(
        width: 60,
        point: position,
        builder: (context) {
          return GestureDetector(
            onTap: () async {
              print('Team selected! ${team.name}');
              // Show trail and open team details
              selectedTeam.value = team;
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: selectedTeam.value == team
                    ? Colors.blueAccent
                    : Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                team.name,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
          );
        });
  }
}

class _CountdownWidget extends StatelessWidget {
  const _CountdownWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '00:00:00',
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }
}
