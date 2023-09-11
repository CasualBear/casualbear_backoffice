import 'package:casualbear_backoffice/network/models/event.dart';
import 'package:casualbear_backoffice/network/models/question.dart';
import 'package:casualbear_backoffice/network/models/question_request.dart';
import 'package:casualbear_backoffice/screens/events/cubit/event_cubit.dart';
import 'package:casualbear_backoffice/screens/events/widgets/add_question_widget.dart';
import 'package:casualbear_backoffice/screens/events/widgets/question_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionList extends StatefulWidget {
  final List<Question> questionList;
  final Event event;
  const QuestionList({super.key, required this.questionList, required this.event});

  @override
  State<QuestionList> createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  bool isFirstEntrance = true;
  List<Question> filteredQuestions = [];

  final List<String> zones = [
    "All",
    "ZoneA",
    "ZoneAChallenges",
    "ZoneB",
    "ZoneBChallenges",
    "ZoneC",
    "ZoneCChallenges",
    "ZoneD",
    "ZoneDChallenges",
    "ZoneE",
    "ZoneEChallenges",
  ];

  @override
  void initState() {
    if (isFirstEntrance) {
      filteredQuestions = List<Question>.from(widget.questionList);
      isFirstEntrance = false;
    }
    super.initState();
  }

  String selectedZone = "All";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80, // Set the desired height here
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          title: const Text(
            "Questões",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: _buildList());
  }

  _buildList() {
    return filteredQuestions.isNotEmpty
        ? SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                children: [
                  _buildQuestionTitle(),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredQuestions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          QuestionItem(
                            event: widget.event,
                            onDeleteQuestion: (question) {
                              isFirstEntrance = true;
                              BlocProvider.of<EventCubit>(context)
                                  .deleteQuestion(question.id.toString(), widget.event.id.toString());
                            },
                            question: Question(
                              isVisible: filteredQuestions[index].isVisible,
                              id: filteredQuestions[index].id,
                              latitude: filteredQuestions[index].latitude,
                              longitude: filteredQuestions[index].longitude,
                              address: filteredQuestions[index].address,
                              zone: filteredQuestions[index].zone,
                              question: filteredQuestions[index].question,
                              answers: filteredQuestions[index].answers,
                              correctAnswerIndex: filteredQuestions[index].correctAnswerIndex,
                              eventId: widget.event.id,
                              createdAt: '',
                              points: filteredQuestions[index].points,
                              updatedAt: '',
                            ),
                            onEditQuestion: (question) {
                              BlocProvider.of<EventCubit>(context).updateQuestion(question, widget.event.id.toString());
                            },
                          ),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          )
        : const Text(
            'Sem questões criadas para esta zona',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          );
  }

  Widget _buildQuestionTitle() {
    return Row(
      children: [
        const Text(
          'Criar Questão',
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
                event: widget.event,
                onAddQuestion: addQuestion,
              ),
            );
          },
          child: Container(
            color: Colors.black,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButton<String>(
            value: selectedZone,
            items: zones.map((String zone) {
              return DropdownMenuItem<String>(
                value: zone,
                child: Text(zone),
              );
            }).toList(),
            onChanged: (String? newValue) {
              _filterQuestions(newValue!);
              selectedZone = newValue;
            },
          ),
        ),
      ],
    );
  }

  void addQuestion(QuestionRequest question) {
    isFirstEntrance = true;
    BlocProvider.of<EventCubit>(context).addQuestion(question, widget.event.id.toString());
  }

  void _filterQuestions(String zone) {
    filteredQuestions.clear();
    if (zone == "All") {
      setState(() {
        filteredQuestions = List<Question>.from(widget.questionList);
      });
    } else {
      setState(() {
        filteredQuestions = widget.questionList.where((question) {
          return question.zone.toLowerCase().startsWith(zone.toLowerCase());
        }).toList();
      });
    }
  }
}
