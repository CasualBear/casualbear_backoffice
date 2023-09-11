import 'package:casualbear_backoffice/screens/events/cubit/event_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamScores extends StatefulWidget {
  final int eventId;
  const TeamScores({Key? key, required this.eventId}) : super(key: key);

  @override
  State<TeamScores> createState() => _TeamScoresState();
}

class _TeamScoresState extends State<TeamScores> {
  List<Map<String, dynamic>>? scoresData = [];

  @override
  void initState() {
    BlocProvider.of<EventCubit>(context).getScores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classificação das Equipas'),
      ),
      body: BlocConsumer<EventCubit, EventState>(
        buildWhen: (previous, current) =>
            current is GetScoresError || current is GetScoresLoading || current is GetScoresLoaded,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetScoresLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetScoresLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DataTable(
                      columnSpacing: 16.0,
                      headingRowHeight: 48.0,
                      // ignore: deprecated_member_use
                      dataRowHeight: 56.0,
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Nome Equipa',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Pontos',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Tempo médio de resposta',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows: state.scores.map((data) {
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Text(
                                data.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataCell(
                              Text(
                                data.totalPoints.toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataCell(
                              Text(
                                data.timeSpent.toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Text('Error while loading scores');
          }
        },
      ),
    );
  }
}
