import 'package:flutter/material.dart';

class TeamItem extends StatelessWidget {
  final String name;
  final int id;

  const TeamItem({
    super.key,
    required this.name,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add your logic to handle team card tap
      },
      child: Card(
        color: Colors.grey[200],
        child: ListTile(
          title: Text(name),
          subtitle: Text('ID: $id'),
        ),
      ),
    );
  }
}
