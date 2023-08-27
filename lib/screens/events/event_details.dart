import 'package:casualbear_backoffice/network/models/event.dart';
import 'package:casualbear_backoffice/network/models/question.dart';
import 'package:casualbear_backoffice/network/models/question_request.dart';
import 'package:casualbear_backoffice/network/models/team.dart';
import 'package:casualbear_backoffice/screens/events/cubit/event_cubit.dart';
import 'package:casualbear_backoffice/screens/events/team_details.dart';
import 'package:casualbear_backoffice/screens/events/team_scores.dart';
import 'package:casualbear_backoffice/screens/events/widgets/add_question_widget.dart';
import 'package:casualbear_backoffice/screens/events/widgets/question_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({Key? key, required this.event}) : super(key: key);

  @override
  EventDetailsScreenState createState() => EventDetailsScreenState();
}

class EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  void initState() {
    BlocProvider.of<EventCubit>(context).getEvent(widget.event.id.toString());
    super.initState();
  }

  void addQuestion(QuestionRequest question) {
    BlocProvider.of<EventCubit>(context).addQuestion(question, widget.event.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(
          widget.event.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<EventCubit, EventState>(
        buildWhen: (previous, current) =>
            current is SingleEventGetLoading || current is SingleEventGetLoaded || current is EventGetError,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is SingleEventGetLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SingleEventGetLoaded) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Equipas dentro do Evento',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                state.event.teams?.isNotEmpty ?? false
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.event.teams!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildTeamItem(state.event.teams![index]);
                        },
                      )
                    : const Text("Sem equipas inscritas"),
                const SizedBox(height: 16),
                const Text(
                  'Informação em tempo real',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => TeamScores(eventId: widget.event.id),
                            ),
                          );
                        },
                        child: const Text('Ver Classificação'),
                      ),
                    ),
                    const SizedBox(width: 8), // Add some spacing between the buttons
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle Ver Localização em tempo real button tap
                        },
                        child: const Text('Ver Localização em tempo real'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 10),
                _buildQuestionTitle(),
                const SizedBox(height: 16),
                state.event.questions.isNotEmpty
                    ? Column(
                        children: [
                          for (int index = 0; index < (state.event.questions.length); index++)
                            Column(
                              children: [
                                QuestionItem(
                                  event: state.event,
                                  onDeleteQuestion: (question) {
                                    BlocProvider.of<EventCubit>(context)
                                        .deleteQuestion(question.id.toString(), widget.event.id.toString());
                                  },
                                  question: Question(
                                    id: state.event.questions[index].id,
                                    latitude: state.event.questions[index].latitude,
                                    longitude: state.event.questions[index].longitude,
                                    address: state.event.questions[index].address,
                                    zone: state.event.questions[index].zone,
                                    question: state.event.questions[index].question,
                                    answers: state.event.questions[index].answers,
                                    correctAnswerIndex: state.event.questions[index].correctAnswerIndex,
                                    eventId: state.event.id,
                                    createdAt: '',
                                    points: 0,
                                    updatedAt: '',
                                  ),
                                  onEditQuestion: (question) {
                                    BlocProvider.of<EventCubit>(context)
                                        .updateQuestion(question, widget.event.id.toString());
                                  },
                                ),
                              ],
                            ),
                        ],
                      )
                    : const Text(
                        'Sem questões criadas',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                      )
              ],
            );
          } else {
            return const Text("Impossible to load event details");
          }
        },
      ),
    );
  }

  _buildTeamItem(Team team) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => TeamDetails(
              team: team,
            ),
          ),
        );

        // ignore: use_build_context_synchronously
        BlocProvider.of<EventCubit>(context).getEvent(widget.event.id.toString());
      },
      child: Card(
        color: Colors.grey[200],
        child: ListTile(
          title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Nome da equipa: ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Text(team.name),
                  ],
                ),
                const SizedBox(height: 5),
                Text(team.isVerified.isEmpty ? 'Equipa não verificada ⛔️' : 'Estado: ${team.isVerified}'),
                const SizedBox(height: 5),
                Text(!team.isCheckedIn ? 'Check-in não efetuado ⛔️' : 'Checked-in ✅')
              ]),
          trailing: const Icon(Icons.arrow_forward),
        ),
      ),
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
            color: Colors.green,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
