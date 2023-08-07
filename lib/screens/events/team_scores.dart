import 'package:flutter/material.dart';

class TeamScores extends StatelessWidget {
  final List<Map<String, dynamic>> scoresData;

  const TeamScores({Key? key, required this.scoresData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatisticas das Equipas'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DataTable(
                columnSpacing: 16.0,
                headingRowHeight: 48.0,
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
                rows: scoresData.map((data) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Text(
                          data['teamId'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataCell(
                        Text(
                          data['currentScore'].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataCell(
                        Text(
                          data['avgTimeOfAnswer'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
