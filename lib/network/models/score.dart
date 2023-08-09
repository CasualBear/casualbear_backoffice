class Score {
  String teamId;
  double averageTime;
  int correctAnswers;

  Score({required this.teamId, required this.averageTime, required this.correctAnswers});

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      teamId: json['teamId'],
      averageTime: json['averageTime'],
      correctAnswers: json['correctAnswers'],
    );
  }
}
