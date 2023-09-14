import 'package:casualbear_backoffice/network/models/event.dart';
import 'package:casualbear_backoffice/network/services/api_service.dart';
import 'package:casualbear_backoffice/repositories/event_repository.dart';
import 'package:casualbear_backoffice/screens/events/cubit/event_cubit.dart';
import 'package:casualbear_backoffice/screens/events/team_scores.dart';
import 'package:casualbear_backoffice/screens/events/widgets/question_list.dart';
import 'package:casualbear_backoffice/screens/events/widgets/team_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({Key? key}) : super(key: key);

  @override
  EventDetailsScreenState createState() => EventDetailsScreenState();
}

class EventDetailsScreenState extends State<EventDetailsScreen> {
  String eventId = "1";
  Event? event;
  bool isFirstEntrance = true;
  String gameStarted = 'Pre Game';

  @override
  void initState() {
    BlocProvider.of<EventCubit>(context).getEvent("1");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80, // Set the desired height here
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          "Wbdday Event",
          style: TextStyle(
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
            event = state.event;

            if (isFirstEntrance) {
              gameStarted = state.event.hasStarted;
              isFirstEntrance = false;
            }

            return Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Gerir Jogo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Text(
                            gameStarted.toUpperCase(),
                            style: TextStyle(
                                color: gameStarted == "game_started"
                                    ? Colors.green
                                    : gameStarted == 'game_ended'
                                        ? Colors.red
                                        : Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: ElevatedButton(
                            child: const Text('Reset Jogo'),
                            onPressed: () {
                              _showAlertDialog(
                                context,
                                "Reset",
                                "Tem a certeza que quer fazer reser ao evento?",

                                () {
                                  setState(() {
                                    gameStarted = 'pre_game';
                                    EventRepository eventRepository = EventRepository(ApiService.shared);
                                    eventRepository.resetEvent();
                                  });
                                }, // Provide the start event callback
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: ElevatedButton(
                            child: const Text(
                              'Começar Jogo',
                              style: TextStyle(color: Colors.green),
                            ),
                            onPressed: () {
                              _showAlertDialog(
                                context,
                                "COMEÇAR",
                                "Tem a certeza que quer começar o evento?",

                                () {
                                  setState(() {
                                    gameStarted = 'game_started';
                                    EventRepository eventRepository = EventRepository(ApiService.shared);
                                    eventRepository.startEvent();
                                  });
                                }, // Provide the start event callback
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 24),
                          child: ElevatedButton(
                            child: const Text(
                              'Terminar Jogo',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              _showAlertDialog(
                                context,
                                "TERMINAR",
                                "Tem a certeza que quer terminar o evento, isto terá implicações nos resultados e irá fazer reset a todos os dados?",
                                () {
                                  setState(() {
                                    gameStarted = 'game_ended';
                                    EventRepository eventRepository = EventRepository(ApiService.shared);
                                    eventRepository.endEvent();
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Opções',
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
                                  builder: (BuildContext context) => TeamScores(eventId: int.parse(eventId)),
                                ),
                              );
                            },
                            child: Text('Ver Classificação'.toUpperCase(), style: const TextStyle(color: Colors.black)),
                          ),
                        ),
                        const SizedBox(width: 8), // Add some spacing between the buttons
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle Ver Localização em tempo real button tap
                            },
                            child: Text('Ver Localização de Equipas'.toUpperCase(),
                                style: const TextStyle(color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push<void>(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) => TeamList(eventId: state.event.id.toString()),
                                  ),
                                );
                              },
                              child: Text('Ver Equipas'.toUpperCase(), style: const TextStyle(color: Colors.black))),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push<void>(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) => QuestionList(event: state.event),
                                  ),
                                );
                              },
                              child: Text('Ver Questões'.toUpperCase(), style: const TextStyle(color: Colors.black))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          } else {
            return const Text("Impossible to load event details");
          }
        },
      ),
    );
  }

  void _showAlertDialog(BuildContext context, String title, String message, Function() onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Confirmar"),
              onPressed: () {
                onConfirm(); // Execute the provided callback
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
