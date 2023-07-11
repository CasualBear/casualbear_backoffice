import 'package:casualbear_backoffice/network/models/coordinates.dart';

class Question {
  final String question;
  final List<String> answers;
  final int correctAnswerIndex;
  Coordinates coordinates;

  Question({
    required this.question,
    required this.answers,
    required this.coordinates,
    required this.correctAnswerIndex,
  });
}
