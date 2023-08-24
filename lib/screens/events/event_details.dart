import 'package:casualbear_backoffice/network/models/event.dart';
import 'package:casualbear_backoffice/screens/events/cubit/event_cubit.dart';
import 'package:casualbear_backoffice/screens/events/cubit/team_cubit.dart';
import 'package:casualbear_backoffice/screens/events/team_details.dart';
import 'package:casualbear_backoffice/screens/events/team_scores.dart';
import 'package:casualbear_backoffice/screens/events/widgets/add_question_widget.dart';
import 'package:casualbear_backoffice/screens/events/widgets/question_item.dart';
import 'package:casualbear_backoffice/widgets/event_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  void initState() {
    BlocProvider.of<EventCubit>(context).getEvent(widget.event.id.toString());
    super.initState();
  }

  void addQuestion(Question question) {
    BlocProvider.of<EventCubit>(context).addQuestion(question, widget.event.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(getColor(widget.event.selectedColor)),
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
                state.event.teams!.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.event.teams?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildTeamItem(state.event.teams?[index] ?? '', index);
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
                        child: const Text('Ver Classificação em tempo real'),
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
                const Text(
                  'Gestão de Zonas - ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: state.event.zones
                      .map((zone) => Card(
                            child: ListTile(
                              title: Text(zone.name),
                              trailing: Switch(
                                value: zone.active,
                                onChanged: (value) {
                                  setState(() {
                                    zone.active = value;
                                  });

                                  BlocProvider.of<EventCubit>(context)
                                      .updateZoneStates(widget.event.id.toString(), zone.name, zone.active);
                                },
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 10),
                _buildQuestionTitle(),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.event.questions.length,
                  itemBuilder: (context, index) {
                    final question = state.event.questions[index];
                    final answers = question.answers ?? [];
                    final correctAnswerIndex =
                        question.correctAnswerIndex < answers.length ? question.correctAnswerIndex : 0;

                    Question questionDTO = Question(
                      id: question.id,
                      latitude: question.latitude,
                      longitude: question.longitude,
                      address: question.address,
                      zone: question.zone,
                      question: question.question,
                      answers: answers,
                      correctAnswerIndex: correctAnswerIndex,
                      eventId: state.event.id,
                    );

                    return Column(
                      children: [
                        QuestionItem(
                          event: state.event,
                          onDeleteQuestion: (question) {
                            BlocProvider.of<EventCubit>(context)
                                .deleteQuestion(question.id.toString(), widget.event.id.toString());
                          },
                          question: questionDTO,
                          onEditQuestion: (question) {
                            BlocProvider.of<EventCubit>(context).updateQuestion(question, widget.event.id.toString());
                          },
                        ),
                      ],
                    );
                  },
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

  _buildTeamItem(String name, int index) {
    BlocProvider.of<EventCubit>(context).getUsersByTeam(name);

    return BlocConsumer<EventCubit, EventState>(
      buildWhen: (previous, current) =>
          current is GetTeamMemberLoading || current is GetTeamMemberLoaded || current is GetTeamMemberError,
      listener: (context, membersState) {},
      builder: (context, membersState) {
        if (membersState is GetTeamMemberLoading) {
          return const CircularProgressIndicator();
        } else if (membersState is GetTeamMemberLoaded) {
          return GestureDetector(
            onTap: () async {
              await Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => TeamDetails(
                    teamId: name,
                    isCheckedin: membersState.teamMembers[index].isCheckedIn,
                    isVerified: membersState.teamMembers[index].isVerified,
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
                          const Text('Nome da equipa: ',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 5),
                          Text(name),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(!membersState.teamMembers[index].isVerified ? 'Not Verified ⛔️' : 'Verified ✅'),
                      const SizedBox(height: 5),
                      Text(!membersState.teamMembers[index].isCheckedIn ? 'Check-in não efetuado ⛔️' : 'Checked-in ✅')
                    ]),
                trailing: const Icon(Icons.arrow_forward),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildQuestionTitle() {
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
