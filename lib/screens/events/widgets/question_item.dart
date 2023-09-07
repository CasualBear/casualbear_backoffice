import 'package:casualbear_backoffice/network/models/answer.dart';
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
  QuestionItemState createState() => QuestionItemState();
}

class QuestionItemState extends State<QuestionItem> {
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
                  text: 'Questão: ',
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
                    const TextSpan(
                        text: 'Pontos: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    TextSpan(text: widget.question.points.toString()),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: DefaultTextStyle.of(context).style.fontSize! + 3,
                      ),
                  children: [
                    const TextSpan(text: 'Id: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    TextSpan(text: widget.question.id.toString()),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: DefaultTextStyle.of(context).style.fontSize! + 3,
                      ),
                  children: [
                    const TextSpan(
                        text: 'É Visivel? : ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                    TextSpan(text: widget.question.isVisible ? "Não" : 'Sim'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: DefaultTextStyle.of(context).style.fontSize! + 3,
                      ),
                  children: [
                    const TextSpan(text: 'Zona: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
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
                    const TextSpan(text: 'Endereço: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: widget.question.address),
                  ],
                ),
              ),
              widget.question.answers?.isNotEmpty ?? false
                  ? Text(
                      'Resposta Correcta: ${widget.question.correctAnswerIndex}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: DefaultTextStyle.of(context).style.fontSize! + 3,
                      ),
                    )
                  : Container(),
              const SizedBox(height: 16),
              widget.question.question.isEmpty
                  ? const Text(
                      'Isto é uma pergunta falsa',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
                    )
                  : widget.question.answers?.isEmpty ?? false
                      ? const Text(
                          'Isto é um desafio',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
                        )
                      : const Text(
                          'Respostas (Correcta a verde)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
              Visibility(
                visible: widget.question.answers?.isNotEmpty ?? false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(widget.question.answers?.length ?? 0, (index) {
                    Answer? answer = widget.question.answers?[index];
                    return ListTile(
                      title: Text(
                        'Resposta $index:${answer?.answer}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: widget.question.correctAnswerIndex == index ? Colors.green : Colors.black,
                        ),
                      ),
                    );
                  }),
                ),
              )
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
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
