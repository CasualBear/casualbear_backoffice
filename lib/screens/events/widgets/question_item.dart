import 'package:flutter/material.dart';

class QuestionItem extends StatelessWidget {
  final String question;
  final List<String> answers;
  final int correctAnswerIndex;
  final String latitude;
  final String longitude;
  final String address;

  const QuestionItem({
    required this.question,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.answers,
    required this.correctAnswerIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: SelectableText(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Answers:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            ...answers.map((answer) => Text(answer)),
            const SizedBox(height: 10),
            Text(
              'Correct Answer: ${answers[correctAnswerIndex]}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Latitude: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SelectableText(latitude),
            const Text(
              'Longitude: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SelectableText(longitude),
            Text(
              'Address: $address',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
