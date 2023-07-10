import 'package:casualbear_backoffice/network/models/event.dart';
import 'package:flutter/material.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;
  const EventDetailsScreen({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final List<Question> questions = [];

  void addQuestion(String question, List<String> answers, int correctAnswerIndex) {
    setState(() {
      questions.add(Question(
        question: question,
        answers: answers,
        correctAnswerIndex: correctAnswerIndex,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(widget.event.selectedColor),
        title: const Text('Event Details'),
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
              width: 100,
              height: 100,
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
          const TeamCard(
            name: 'Team A',
            id: 1,
          ),
          TeamCard(
            name: 'Team B',
            id: 2,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Create Questions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AddQuestionDialog(
                      onAddQuestion: addQuestion,
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...questions.map((question) => QuestionItem(
                question: question.question,
                answers: question.answers,
                correctAnswerIndex: question.correctAnswerIndex,
              )),
        ],
      ),
    );
  }
}

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

class TeamCard extends StatelessWidget {
  final String name;
  final int id;

  const TeamCard({
    required this.name,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add your logic to handle team card tap
      },
      child: Card(
        color: Colors.grey[200],
        child: ListTile(
          title: Text(name),
          subtitle: Text('ID: $id'),
        ),
      ),
    );
  }
}

class QuestionItem extends StatelessWidget {
  final String question;
  final List<String> answers;
  final int correctAnswerIndex;

  const QuestionItem({
    required this.question,
    required this.answers,
    required this.correctAnswerIndex,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(question),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Answers:'),
          ...answers.map((answer) => Text(answer)),
          Text('Correct Answer Index: $correctAnswerIndex'),
        ],
      ),
    );
  }
}

class Question {
  final String question;
  final List<String> answers;
  final int correctAnswerIndex;

  Question({
    required this.question,
    required this.answers,
    required this.correctAnswerIndex,
  });
}

class AddQuestionDialog extends StatefulWidget {
  final Function(String, List<String>, int) onAddQuestion;

  const AddQuestionDialog({
    required this.onAddQuestion,
  });

  @override
  _AddQuestionDialogState createState() => _AddQuestionDialogState();
}

class _AddQuestionDialogState extends State<AddQuestionDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _questionController;
  List<TextEditingController> _answerControllers = [];
  int _correctAnswerIndex = 0;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController();
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
            Text('Answers:'),
            const SizedBox(height: 8),
            ..._answerControllers.asMap().entries.map((entry) {
              final int index = entry.key;
              final controller = entry.value;
              final isCorrectAnswer = index == _correctAnswerIndex;
              return Row(
                children: [
                  Flexible(
                    flex: 4, // Adjust the flex value as needed to control the width
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
                      icon: Icon(Icons.remove_circle),
                      color: Colors.red,
                      disabledColor: Colors.grey,
                      constraints: BoxConstraints(),
                    ),
                  if (index == _answerControllers.length - 1)
                    IconButton(
                      onPressed: () {
                        _addAnswerField();
                      },
                      icon: Icon(Icons.add_circle),
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
                  Text('Correct Answer'),
                ],
              );
            }),
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
              final answers = _answerControllers.map((controller) => controller.text).toList();
              widget.onAddQuestion(question, answers, _correctAnswerIndex);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
