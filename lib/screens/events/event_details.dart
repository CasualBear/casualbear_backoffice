// ignore_for_file: library_private_types_in_public_api

import 'package:casualbear_backoffice/network/models/coordinates.dart';
import 'package:casualbear_backoffice/network/models/event.dart';
import 'package:casualbear_backoffice/network/models/question.dart';
import 'package:casualbear_backoffice/network/models/zones.dart';
import 'package:casualbear_backoffice/screens/events/widgets/add_question_widget.dart';
import 'package:casualbear_backoffice/screens/events/widgets/event_info.dart';
import 'package:casualbear_backoffice/screens/events/widgets/question_item.dart';
import 'package:casualbear_backoffice/screens/events/widgets/team_item.dart';
import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;
  const EventDetailsScreen({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final List<Question> questions = [];
  late final List<Zone> zones;

  @override
  void initState() {
    zones = [
      Zone(name: "${widget.event.name} Zone A", isLocked: false),
      Zone(name: "${widget.event.name} Zone B", isLocked: false),
      Zone(name: "${widget.event.name} Zone C", isLocked: false),
      Zone(name: "${widget.event.name} Zone D", isLocked: false),
      Zone(name: "${widget.event.name} Zone E", isLocked: false),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(widget.event.selectedColor),
        title: Text(widget.event.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          EventInfoItem(title: 'Event Name', value: widget.event.name),
          const SizedBox(height: 8),
          EventInfoItem(title: 'Event Description', value: widget.event.description),
          const SizedBox(height: 8),
          EventInfoItem(
            title: 'Event Icon',
            value: Image.network(
              widget.event.rawUrl!,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Equipas dentro do Evento',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const TeamItem(
            name: 'Team A',
            id: 1,
          ),
          const TeamItem(
            name: 'Team B',
            id: 2,
          ),
          const SizedBox(height: 16),
          const Text(
            'Gestão de Zonas - ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: zones.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(zones[index].name),
                      trailing: Switch(
                        value: zones[index].isLocked,
                        onChanged: (value) {
                          setState(() {
                            zones[index].isLocked = value;
                          });
                        },
                      ),
                    ),
                  );
                }),
          ),
          const SizedBox(height: 10),
          _buildQuestionTitle(),
          const SizedBox(height: 16),
          const SizedBox(height: 8),
          ...questions.map((question) => QuestionItem(
                latitude: question.coordinates.latitude,
                longitude: question.coordinates.longitude,
                address: question.coordinates.address,
                question: question.question,
                answers: question.answers,
                correctAnswerIndex: question.correctAnswerIndex,
              )),
        ],
      ),
    );
  }

  void addQuestion(String question, List<String> answers, int correctAnswerIndex, LatLong coordinates, String address) {
    setState(() {
      questions.add(Question(
        coordinates: Coordinates(
          address: address,
          latitude: coordinates.latitude.toString(),
          longitude: coordinates.longitude.toString(),
        ),
        question: question,
        answers: answers,
        correctAnswerIndex: correctAnswerIndex,
      ));
    });
  }

  _buildQuestionTitle() {
    return Row(
      children: [
        const Text(
          'Create Questions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => AddQuestionDialog(
                onAddQuestion: addQuestion,
                zones: zones,
              ),
            );
          },
          child: Container(
            color: Colors.green,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
        )
      ],
    );
  }
}
