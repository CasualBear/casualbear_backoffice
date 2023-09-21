import 'package:casualbear_backoffice/network/models/team.dart';
import 'package:casualbear_backoffice/screens/events/live_location/cubit/live_location_cubit.dart';
import 'package:casualbear_backoffice/screens/events/widgets/countdown_widget.dart';
import 'package:casualbear_backoffice/screens/events/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LiveLocationScreen extends StatelessWidget {
  // Event HQ
  static const LatLng latLng = LatLng(38.707962, -9.138409);

  const LiveLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LiveLocationCubit>(context).getStartTime();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localização das equipas'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: _buildMap(context),
          ),
          Expanded(
            flex: 1,
            child: _buildTeamDetails(context),
          ),
        ],
      ),
    );
  }

  /// Builds the team details.
  Widget _buildTeamDetails(BuildContext context) {
    return BlocConsumer<LiveLocationCubit, LiveLocationState>(
      listenWhen: (previous, current) => current is LiveLocationError,
      listener: (context, state) {
        if (state is LiveLocationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      buildWhen: (previous, current) =>
          current is LiveLocationLoaded ||
          current is LiveLocationLoadingSelectedTeam,
      builder: (context, state) {
        if (state is LiveLocationLoaded) {
          if (state.selectedTeam == null) {
            return Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Seleciona uma equipa',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Terá acesso aos detalhes da equipa e o último percurso que efectuaram no mapa.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  Text(
                    'Pode escolher uma equipa clicando no indicador de equipa no mapa.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.touch_app_rounded, size: 50),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  Text(
                    'Ou pode pesquisar por equipa clickando no botão de pesquisa abaixo.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.3,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.1,
                            ),
                            child: SearchWidget(
                              teams: state.teams
                                  .where((e) => e.location != null)
                                  .map((e) => e.team)
                                  .toList(),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.search, size: 50),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Atenção: Só estarão presentes no mapa equipas que tenham enviado, pelo menos, uma localização desde que este mapa tenha sido aberto.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                const Spacer(),
                Text(
                  state.selectedTeam?.name ?? '',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  'Pontos: ${state.selectedTeam?.totalPoints ?? '-'}',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 20),
                ...(state.selectedTeam?.members ?? [])
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text('${e.name} - ${e.email}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: e.isCaptain
                                        ? Colors.blue
                                        : Colors.grey)),
                      ),
                    )
                    .toList(),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: TextButton(
                      onPressed: () {
                        BlocProvider.of<LiveLocationCubit>(context)
                            .deselectTeam();
                      },
                      child: const Text('Limpar selecção')),
                ),
              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  /// Builds the map with the teams.
  Widget _buildMap(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        keepAlive: true,
        center: latLng,
        maxZoom: 18,
        zoom: 14,
      ),
      nonRotatedChildren: [
        Positioned(
            top: 20,
            left: 20,
            child: BlocBuilder<LiveLocationCubit, LiveLocationState>(
              buildWhen: (previous, current) =>
                  current is LiveLocationStartTime,
              builder: (context, state) {
                if (state is LiveLocationStartTime) {
                  return CountdownTimer(
                    startTime: state.startTime,
                  );
                }
                return const SizedBox();
              },
            )),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'pt.wbdday.backoffice',
        ),
        _buildPolyline(),
        _buildMarkerLayer(),
      ],
    );
  }

  Widget _buildPolyline() {
    return BlocBuilder<LiveLocationCubit, LiveLocationState>(
        builder: (context, state) {
      if (state is LiveLocationLoaded && state.selectedTeam != null) {
        return PolylineLayer(
          polylines: [
            Polyline(
              points: state.selectedTeamLocations,
              strokeWidth: 5,
              color: Colors.blueAccent,
            ),
          ],
        );
      }

      return const SizedBox();
    });
  }

  Widget _buildMarkerLayer() {
    return BlocBuilder<LiveLocationCubit, LiveLocationState>(
        builder: (context, state) {
      if (state is LiveLocationLoaded) {
        final teamsWithLocation =
            state.teams.where((e) => e.location != null).toList();
        return MarkerLayer(
          rotate: true,
          markers: teamsWithLocation.map((team) {
            return _buildMarkerForTeam(team.team,
                position: team.location ?? latLng,
                isSelected: team.team.id.toString() ==
                    state.selectedTeam?.id.toString());
          }).toList(),
        );
      }

      return const SizedBox();
    });
  }

  /// Builds a marker from a question.
  Marker _buildMarkerForTeam(
    Team team, {
    required LatLng position,
    bool isSelected = false,
  }) {
    return Marker(
        width: 60,
        point: position,
        builder: (context) {
          return GestureDetector(
            onTap: () async {
              print('Team selected! ${team.name}');
              // Show trail and open team details
              BlocProvider.of<LiveLocationCubit>(context).selectTeam(team.id);
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blueAccent : Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  team.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ),
          );
        });
  }
}
