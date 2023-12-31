import 'package:casualbear_backoffice/network/models/team.dart';
import 'package:casualbear_backoffice/network/models/zones.dart';
import 'package:casualbear_backoffice/network/services/api_service.dart';
import 'package:casualbear_backoffice/repositories/team_repository.dart';
import 'package:casualbear_backoffice/screens/events/widgets/team_details_widget.dart';
import 'package:flutter/material.dart';

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
  TeamRepository repository = TeamRepository(apiService: ApiService.shared);

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
      body: FutureBuilder(
        future: repository.getTeamDetails(widget.eventId, widget.teamId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Handle errors here, e.g., show an error message.
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (!snapshot.hasData) {
            // Handle the case where there is no data (optional).
            return const Center(child: Text('No data available.'));
          } else {
            team = snapshot.data;
            return TeamDetailsWidget(
              team: team!,
              eventId: widget.eventId,
            );
          }
        },
      ),
    );
  }
}
