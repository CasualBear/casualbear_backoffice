import 'dart:convert';

import 'package:casualbear_backoffice/network/models/event.dart';
import 'package:casualbear_backoffice/screens/events/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class QuestionItem extends StatefulWidget {
  final Question question;
  final Event event;
  final Function(Question) onEditQuestion;
  final Function(Question) onDeleteQuestion;

  const QuestionItem({
    Key? key,
    required this.question,
    required this.event,
    required this.onEditQuestion,
    required this.onDeleteQuestion,
  }) : super(key: key);

  @override
  _QuestionItemState createState() => _QuestionItemState();
}

class _QuestionItemState extends State<QuestionItem> {
  late TextEditingController _questionController;
  late List<TextEditingController> _answerControllers;
  late int _correctAnswerIndex;
  final _formKey = GlobalKey<FormState>();
  late LatLong questionCoordinates;
  String? selectedZone;
  late TextEditingController _locationController;

  @override
  void initState() {
    _questionController = TextEditingController(text: widget.question.question);
    _locationController = TextEditingController();
    _answerControllers = List.generate(
      widget.question.answers?.length ?? 0,
      (index) => TextEditingController(text: widget.question.answers?[index] ?? ''),
    );
    _correctAnswerIndex = widget.question.correctAnswerIndex;
    super.initState();
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _editAnswers(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Question'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Question:'),
                    TextFormField(
                      controller: _questionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a question';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Location:'),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                      ),
                      onTap: () {
                        Navigator.push<String?>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapScreen(
                              onAddressPicked: (latitude, longitude, address) {
                                questionCoordinates = LatLong(latitude, longitude);
                                setState(() {
                                  _locationController.text = address;
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    const Text('Zone:'),
                    DropdownButtonFormField<String>(
                      value: widget.question.zone,
                      onChanged: (value) {
                        setState(() {
                          widget.question.zone = value!;
                        });
                      },
                      items: widget.event.zones.map((zone) {
                        return DropdownMenuItem<String>(
                          value: zone.name,
                          child: Text(zone.name + (zone.active ? ' (Unlocked)' : ' (Locked)')),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Answers:'),
                    Column(
                      children: List.generate(_answerControllers.length, (index) {
                        final controller = _answerControllers[index];
                        final isCorrectAnswer = index == widget.question.correctAnswerIndex;
                        String answer = controller.text;
                        List<String> parts = answer.split(",");
                        String secondHalf = "";
                        if (parts.length >= 2) {
                          secondHalf = parts[1].trim().replaceAll("answer:", "").replaceAll("}", "").trim();
                        }
                        final initialValue = secondHalf.isNotEmpty ? secondHalf : 'No answer provided';
                        controller.text = initialValue; // Set the initial value using the controller
                        return TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            labelText: 'Answer ${index + 1}',
                          ),
                          onChanged: (value) {
                            controller.text = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an answer';
                            }
                            return null;
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    const Text('Correct Answer:'),
                    DropdownButton<int>(
                      value: _correctAnswerIndex,
                      items: List.generate(
                        _answerControllers.length,
                        (index) => DropdownMenuItem<int>(
                          value: index,
                          child: Text('Answer ${index + 1}'),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _correctAnswerIndex = value ?? 0;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final editedQuestion = Question(
                  id: widget.question.id,
                  question: _questionController.text,
                  answers: _answerControllers.map((controller) => controller.text).toList(),
                  correctAnswerIndex: _correctAnswerIndex,
                  zone: widget.question.zone,
                  latitude: widget.question.latitude.toString(),
                  longitude: widget.question.longitude.toString(),
                  address: widget.question.address,
                  createdAt: widget.question.createdAt,
                  updatedAt: widget.question.updatedAt,
                  eventId: widget.question.eventId,
                );
                widget.onEditQuestion(editedQuestion);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        child: ListTile(
          title: Text(widget.question.question),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Latitude: ${widget.question.latitude}'),
              Text('Longitude: ${widget.question.longitude}'),
              Text('Zone: ${widget.question.zone}'),
              Text('Address: ${widget.question.address}'),
              Text('Correct Answer Index: ${widget.question.correctAnswerIndex}'),
              const SizedBox(height: 16),
              const Text('Answers:'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.question.answers?.asMap().entries.map((entry) {
                      final index = entry.key;
                      final answer = entry.value;
                      final isCorrectAnswer = index == widget.question.correctAnswerIndex;
                      List<String> parts = answer.split(",");
                      String secondHalf = "";
                      if (parts.length >= 2) {
                        secondHalf = parts[1].trim().replaceAll("answer:", "").replaceAll("}", "").trim();
                      }

                      final answerText = secondHalf ?? 'No answer provided';
                      return Text(
                        'Answer ${index + 1}: $answerText',
                        style: TextStyle(
                          fontWeight: isCorrectAnswer ? FontWeight.bold : FontWeight.normal,
                          color: isCorrectAnswer ? Colors.green : null,
                        ),
                      );
                    }).toList() ??
                    [],
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editAnswers(context),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  widget.onDeleteQuestion(widget.question);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
