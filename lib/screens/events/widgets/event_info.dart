import 'package:flutter/material.dart';

class EventInfoItem extends StatelessWidget {
  final String title;
  final dynamic value;

  const EventInfoItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        value is Widget ? value : Text(value.toString()),
      ],
    );
  }
}
