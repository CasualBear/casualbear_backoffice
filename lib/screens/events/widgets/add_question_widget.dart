// ignore_for_file: library_private_types_in_public_api

import 'package:casualbear_backoffice/screens/events/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class AddQuestionDialog extends StatefulWidget {
  final Function(String, List<String>, int, LatLong, String) onAddQuestion;

  const AddQuestionDialog({
    Key? key,
    required this.onAddQuestion,
  }) : super(key: key);

  @override
  _AddQuestionDialogState createState() => _AddQuestionDialogState();
}

class _AddQuestionDialogState extends State<AddQuestionDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _questionController;
  late TextEditingController _locationController;
  late LatLong questionCoordinates;
  String? selectedZone;

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
            const SizedBox(height: 10),
            const Text('Create answers:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._answerControllers.asMap().entries.map((entry) {
              final int index = entry.key;
              final controller = entry.value;
              final isCorrectAnswer = index == _correctAnswerIndex;
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
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Zone: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedZone,
                  onChanged: (newValue) {
                    setState(() {
                      selectedZone = newValue;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'A',
                      child: Text('Zona A'),
                    ),
                    DropdownMenuItem(
                      value: 'B',
                      child: Text('Zona B'),
                    ),
                    DropdownMenuItem(
                      value: 'C',
                      child: Text('Zona C'),
                    ),
                    DropdownMenuItem(
                      value: 'D',
                      child: Text('Zona D'),
                    ),
                    DropdownMenuItem(
                      value: 'E',
                      child: Text('Zona E'),
                    ),
                    DropdownMenuItem(
                      value: 'F',
                      child: Text('Zona F'),
                    ),
                    DropdownMenuItem(
                      value: 'G',
                      child: Text('Zona G'),
                    ),
                  ],
                ),
              ],
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
              final question = _questionController.text;
              final address = _locationController.text;
              final answers = _answerControllers.map((controller) => controller.text).toList();
              widget.onAddQuestion(question, answers, _correctAnswerIndex, questionCoordinates, address);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
