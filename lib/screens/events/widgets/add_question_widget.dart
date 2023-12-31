import 'dart:convert';

import 'package:casualbear_backoffice/network/models/answer.dart';
import 'package:casualbear_backoffice/network/models/event.dart';
import 'package:casualbear_backoffice/network/models/question_request.dart';
import 'package:casualbear_backoffice/network/models/zones.dart';
import 'package:casualbear_backoffice/screens/events/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class AddQuestionDialog extends StatefulWidget {
  final Event event;
  final Function(QuestionRequest question) onAddQuestion;

  const AddQuestionDialog({
    Key? key,
    required this.onAddQuestion,
    required this.event,
  }) : super(key: key);

  @override
  AddQuestionDialogState createState() => AddQuestionDialogState();
}

class AddQuestionDialogState extends State<AddQuestionDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _questionController;
  late TextEditingController _pointsController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  late TextEditingController _imageController;
  late LatLong questionCoordinates;
  String? selectedZone;

  bool _isChallenge = false;
  bool _isInvisible = false;
  bool _isFake = false;

  final List<TextEditingController> _answerControllers = [];
  int _correctAnswerIndex = 0;
  final List<String> zones = [
    "ZoneA",
    "ZoneAChallenges",
    "ZoneB",
    "ZoneBChallenges",
    "ZoneC",
    "ZoneCChallenges",
    "ZoneD",
    "ZoneDChallenges"
  ];

  @override
  void initState() {
    super.initState();

    _questionController = TextEditingController();
    _pointsController = TextEditingController();
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();
    _answerControllers.add(TextEditingController());
    _imageController = TextEditingController();

    selectedZone = zones[0];
  }

  @override
  void dispose() {
    _questionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _pointsController.dispose();
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addAnswerField() {
    setState(() {
      _answerControllers.add(TextEditingController());
    });
  }

  void _removeAnswerField(int index) {
    if (_answerControllers.length > 1) {
      setState(() {
        _answerControllers.removeAt(index);
        if (_correctAnswerIndex >= _answerControllers.length) {
          _correctAnswerIndex = _answerControllers.length - 1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Questão'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: !_isFake,
                child: TextFormField(
                  controller: _questionController,
                  decoration: const InputDecoration(
                    labelText: 'Pergunta',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduza uma pergunta';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                enableInteractiveSelection: true,
                controller: _latitudeController,
                decoration: const InputDecoration(
                  labelText: 'Latitude',
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                enableInteractiveSelection: true,
                controller: _longitudeController,
                decoration: const InputDecoration(
                  labelText: 'Longitude',
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _pointsController,
                decoration: const InputDecoration(
                  labelText: 'Pontos',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduza pontos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'Imagem',
                ),
              ),
              Row(
                children: [
                  const Text(
                    'Zona: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: selectedZone,
                      onChanged: (value) {
                        setState(() {
                          selectedZone = value;
                        });
                      },
                      items: zones.map((zone) {
                        return DropdownMenuItem(
                          value: zone,
                          child: Text(zone),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: !(_isFake || _isInvisible),
                child: Row(
                  children: [
                    const Text('É Experiência?'),
                    Switch(
                      value: _isChallenge,
                      onChanged: (value) {
                        setState(() {
                          _isChallenge = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: !(_isChallenge || _isInvisible),
                child: Row(
                  children: [
                    const Text('É Engano?'),
                    Switch(
                      value: _isFake,
                      onChanged: (value) {
                        _questionController.clear();
                        setState(() {
                          _isFake = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: !(_isFake || _isChallenge),
                child: Row(
                  children: [
                    const Text('É Pontos Extra?'),
                    Switch(
                      value: _isInvisible,
                      onChanged: (value) {
                        setState(() {
                          _isInvisible = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: !(_isFake || _isChallenge || _isInvisible),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text('Create answers:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ..._answerControllers.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final controller = entry.value;
                      return Row(
                        children: [
                          Flexible(
                            flex: 4,
                            child: TextFormField(
                              controller: controller,
                              decoration: const InputDecoration(
                                labelText: 'Answer',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an answer';
                                }
                                return null;
                              },
                            ),
                          ),
                          if (_answerControllers.length > 1 && index > 0)
                            IconButton(
                              onPressed: () {
                                _removeAnswerField(index);
                              },
                              icon: const Icon(Icons.remove_circle),
                              color: Colors.red,
                              disabledColor: Colors.grey,
                              constraints: const BoxConstraints(),
                            ),
                          if (index == _answerControllers.length - 1)
                            IconButton(
                              onPressed: () {
                                _addAnswerField();
                              },
                              icon: const Icon(Icons.add_circle),
                              color: Colors.green,
                            ),
                          Radio<int>(
                            value: index,
                            groupValue: _correctAnswerIndex,
                            onChanged: (newValue) {
                              setState(() {
                                _correctAnswerIndex = newValue!;
                              });
                            },
                          ),
                          const Text('Correct Answer'),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              List<Answer> answers = !_isChallenge ? _getAnswers() : [];

              QuestionRequest question = QuestionRequest(
                id: 1, // backend ignores this
                question: _questionController.text.isEmpty ? "" : _questionController.text,
                isVisible: !_isInvisible,
                imageUrl: _imageController.text,
                answers: answers,
                correctAnswerIndex: _correctAnswerIndex,
                zone: selectedZone ?? 'ZoneA',
                latitude: _latitudeController.text.toString(),
                longitude: _longitudeController.text.toString(),
                address: '',
                eventId: widget.event.id, createdAt: '', points: int.parse(_pointsController.text), updatedAt: '',
              );

              widget.onAddQuestion(question);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  List<Answer> _getAnswers() {
    List<Answer> answers = [];
    for (var controller in _answerControllers) {
      final answer = controller.text.trim();
      if (answer.isNotEmpty) {
        answers.add(Answer(answer: answer));
      }
    }
    return answers;
  }

  List<Zones> parseZones(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Zones>((json) => Zones(active: json['active'], name: json['name'])).toList();
  }
}
