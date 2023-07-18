class Event {
  int id;
  String name;
  String description;
  int selectedColor;
  String rawUrl;
  List<Zone> zones;
  DateTime createdAt;
  DateTime updatedAt;
  List<Question> questions;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.selectedColor,
    required this.rawUrl,
    required this.zones,
    required this.createdAt,
    required this.updatedAt,
    required this.questions,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      selectedColor: json['selectedColor'],
      rawUrl: json['rawUrl'],
      zones: List<Zone>.from(json['zones'].map((zoneData) => Zone.fromJson(zoneData as Map<String, dynamic>))),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      questions: List<Question>.from(json['questions'].map((questionData) => Question.fromJson(questionData))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'selectedColor': selectedColor,
      'rawUrl': rawUrl,
      'zones': zones.map((zone) => zone.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }
}

class Zone {
  String name;
  bool active;

  Zone({
    required this.name,
    required this.active,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      name: json['name'],
      active: json['active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'active': active,
    };
  }
}

class Question {
  int id;
  String question;
  List<String>? answers;
  int correctAnswerIndex;
  String zone;
  String latitude;
  String longitude;
  String address;
  DateTime? createdAt;
  DateTime? updatedAt;
  int eventId;

  Question({
    required this.id,
    required this.question,
    this.answers,
    required this.correctAnswerIndex,
    required this.zone,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.createdAt,
    this.updatedAt,
    required this.eventId,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      answers: json['answers'] != null ? List<String>.from(json['answers'].map((answer) => answer.toString())) : null,
      correctAnswerIndex: json['correctAnswerIndex'],
      zone: json['zone'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      eventId: json['eventId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answers': answers?.map((answer) => answer.toString()).toList(),
      'correctAnswerIndex': correctAnswerIndex,
      'zone': zone,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'eventId': eventId,
    };
  }
}
