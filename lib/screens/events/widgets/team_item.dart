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
        // Add your logic to handle team card tap
        // Navigate to the team details screen
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
