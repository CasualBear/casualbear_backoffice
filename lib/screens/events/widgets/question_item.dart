import 'package:casualbear_backoffice/network/models/event.dart';
import 'package:casualbear_backoffice/network/models/question.dart';
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

  late LatLong questionCoordinates;
  String? selectedZone;

  @override
  void initState() {
    _questionController = TextEditingController(text: widget.question.question);
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        child: ListTile(
          title: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style.copyWith(
                    fontSize: DefaultTextStyle.of(context).style.fontSize! + 3,
                  ),
              children: [
                const TextSpan(
                  text: 'Question: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: widget.question.question,
                ),
              ],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: DefaultTextStyle.of(context).style.fontSize! + 3,
                      ),
                  children: [
                    const TextSpan(text: 'Latitude: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: widget.question.latitude),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: DefaultTextStyle.of(context).style.fontSize! + 3,
                      ),
                  children: [
                    const TextSpan(text: 'Longitude: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: widget.question.longitude),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: DefaultTextStyle.of(context).style.fontSize! + 3,
                      ),
                  children: [
                    const TextSpan(text: 'Zone: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: widget.question.zone),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: DefaultTextStyle.of(context).style.fontSize! + 3,
                      ),
                  children: [
                    const TextSpan(text: 'Address: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: widget.question.address),
                  ],
                ),
              ),
              widget.question.answers.isNotEmpty
                  ? Text(
                      'Correct Answer Index: ${widget.question.correctAnswerIndex}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: DefaultTextStyle.of(context).style.fontSize! + 3,
                      ),
                    )
                  : Container(),
              const SizedBox(height: 16),
              widget.question.answers.isEmpty
                  ? const Text(
                      'This is a challenge question',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
                    )
                  : const Text('Answers:'),
              // TODO create list of answers here from question
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
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
