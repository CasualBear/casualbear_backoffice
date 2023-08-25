import 'package:casualbear_backoffice/network/models/answer.dart';
import 'package:casualbear_backoffice/network/models/event.dart';
import 'package:casualbear_backoffice/network/models/question.dart';
import 'package:casualbear_backoffice/screens/events/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class AddQuestionDialog extends StatefulWidget {
  final Event event;
  final Function(Question question) onAddQuestion;

  const AddQuestionDialog({
    Key? key,
    required this.onAddQuestion,
    required this.event,
  }) : super(key: key);

  @override
  _AddQuestionDialogState createState() => _AddQuestionDialogState();
}

class _AddQuestionDialogState extends State<AddQuestionDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _questionController;
  late TextEditingController _locationController;
  late LatLong questionCoordinates;
//  Zone? selectedZone;

  bool _isChallenge = false;

  final List<TextEditingController> _answerControllers = [];
  int _correctAnswerIndex = 0;

  @override
  void initState() {
    super.initState();

    _questionController = TextEditingController();
    _locationController = TextEditingController();
    _answerControllers.add(TextEditingController());
  }

  @override
  void dispose() {
    _questionController.dispose();
    _locationController.dispose();
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
      title: const Text('Add Question'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: 'Question',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a question';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
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
                        _locationController.text = address;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
              readOnly: true,
            ),
            const Row(
              children: [
                Text(
                  'Zone: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                /*  Expanded(
                  child: DropdownButtonFormField(
                    value: selectedZone,
                    onChanged: (value) {
                      setState(() {
                        selectedZone = value;
                      });
                    },
                    items: widget.event.zones.map((zone) {
                      return DropdownMenuItem(
                        value: zone,
                        child: Text(zone.name + (zone.active ? ' (Unlocked)' : ' (Locked)')),
                      );
                    }).toList(),
                  ),
                )*/
              ],
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Is Challenge?'),
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
            Visibility(
              visible: !_isChallenge,
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
              List<Answer> answers = [];

              Question question = Question(
                id: 1, // backend ignores this
                question: _questionController.text,
                answers: answers,
                correctAnswerIndex: _correctAnswerIndex,
                zone: 'ZoneA',
                latitude: questionCoordinates.latitude.toString(),
                longitude: questionCoordinates.longitude.toString(),
                address: _locationController.text,
                eventId: widget.event.id, createdAt: '', points: 0, updatedAt: '',
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
}
