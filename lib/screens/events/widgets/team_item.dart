import 'package:casualbear_backoffice/screens/events/team_details.dart';
import 'package:flutter/material.dart';

class TeamItem extends StatelessWidget {
  final String name;

  const TeamItem({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => TeamDetails(teamId: name),
          ),
        );
      },
      child: Card(
        color: Colors.grey[200],
        child: ListTile(
          title: Text(name),
          trailing: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
