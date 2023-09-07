import 'package:carousel_slider/carousel_slider.dart';
import 'package:casualbear_backoffice/network/models/event.dart';
import 'package:casualbear_backoffice/network/models/question.dart';
import 'package:casualbear_backoffice/network/models/question_request.dart';
import 'package:casualbear_backoffice/network/models/team.dart';
import 'package:casualbear_backoffice/network/services/api_service.dart';
import 'package:casualbear_backoffice/repositories/event_repository.dart';
import 'package:casualbear_backoffice/screens/events/cubit/event_cubit.dart';
import 'package:casualbear_backoffice/screens/events/team_details.dart';
import 'package:casualbear_backoffice/screens/events/team_scores.dart';
import 'package:casualbear_backoffice/screens/events/widgets/add_question_widget.dart';
import 'package:casualbear_backoffice/screens/events/widgets/question_item.dart';
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
  final CarouselController _carouselController = CarouselController();
  final CarouselController _questionsCarouselController = CarouselController();
  TextEditingController searchController = TextEditingController();
  List<Team> allTeams = []; // Store all teams
  List<Team> filteredTeams = []; // Store filtered teams

  List<Question> allQuestions = []; // Store all teams
  List<Question> filteredQuestions = []; // Store filtered teams

  bool isFirstEntrance = true;
  bool gameStarted = false;

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

  String selectedZone = "All";

  @override
  void initState() {
    BlocProvider.of<EventCubit>(context).getEvent("1");
    super.initState();
  }

  void addQuestion(QuestionRequest question) {
    isFirstEntrance = true;
    BlocProvider.of<EventCubit>(context).addQuestion(question, eventId);
  }

  void _filterTeams(String query) {
    filteredTeams.clear();
    if (query.isEmpty) {
      setState(() {
        filteredTeams = List<Team>.from(allTeams);
      });
    } else {
      setState(() {
        filteredTeams = allTeams.where((team) {
          return team.name.toLowerCase().startsWith(query.toLowerCase());
        }).toList();
      });
    }
  }

  void _filterQuestions(String zone) {
    filteredQuestions.clear();
    if (zone == "All") {
      setState(() {
        filteredQuestions = List<Question>.from(allQuestions);
      });
    } else {
      setState(() {
        filteredQuestions = allQuestions.where((question) {
          return question.zone.toLowerCase().startsWith(zone.toLowerCase());
        }).toList();
      });
    }
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
              allTeams = state.event.teams ?? [];
              allQuestions = state.event.questions;
              filteredTeams = List<Team>.from(allTeams);
              filteredQuestions = List<Question>.from(allQuestions);
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Text(
                            gameStarted ? 'Game Started' : 'Game Stoped',
                            style: TextStyle(color: gameStarted ? Colors.green : Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: IconButton(
                            icon: const Icon(
                              Icons.play_arrow,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              _showAlertDialog(
                                context,
                                "COMEÇAR",
                                "Tem a certeza que quer começar o evento?",

                                () {
                                  setState(() {
                                    gameStarted = true;
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
                          child: IconButton(
                            icon: const Icon(
                              Icons.stop,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              _showAlertDialog(
                                context,
                                "TERMINAR",
                                "Tem a certeza que quer terminar o evento, isto terá implicações nos resultados e irá fazer reset a todos os dados?",
                                () {
                                  setState(() {
                                    gameStarted = false;
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
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Procurar Equipas (Nome)',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          // Call filter function with updated input
                          _filterTeams(value);
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Equipas dentro do Evento',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    state.event.teams?.isNotEmpty ?? false
                        ? CarouselSlider.builder(
                            carouselController: _carouselController,
                            itemCount: filteredTeams.length,
                            itemBuilder: (BuildContext context, int index, int realIndex) {
                              if (filteredTeams.isNotEmpty) {
                                return _buildTeamItem(filteredTeams[index]);
                              } else {
                                return const Text("Sem equipas inscritas");
                              }
                            },
                            options: CarouselOptions(
                              padEnds: false,
                              height: 200,
                              aspectRatio: 2.0, // Adjust aspectRatio to your preference
                              viewportFraction: 0.2, // Adjust viewportFraction to your preference
                              enableInfiniteScroll: false, // Disable infinite scroll
                              autoPlay: false, // Disable auto-play
                              initialPage: 0, // Set the initial page to 0 (start on the left)
                            ),
                          )
                        : const Text("Sem equipas inscritas"),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            _carouselController.previousPage();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () {
                            _carouselController.nextPage();
                          },
                        ),
                      ],
                    ),
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
                                  builder: (BuildContext context) => TeamScores(eventId: int.parse(eventId)),
                                ),
                              );
                            },
                            child: const Text('Ver Classificação', style: TextStyle(color: Colors.black)),
                          ),
                        ),
                        const SizedBox(width: 8), // Add some spacing between the buttons
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle Ver Localização em tempo real button tap
                            },
                            child: const Text('Ver Localização em tempo real', style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 10),
                    _buildQuestionTitle(),
                    const SizedBox(height: 16),
                    filteredQuestions.isNotEmpty
                        ? Column(
                            children: [
                              CarouselSlider.builder(
                                carouselController: _questionsCarouselController,
                                itemCount: filteredQuestions.length,
                                itemBuilder: (BuildContext context, int index, int realIndex) {
                                  return Column(
                                    children: [
                                      QuestionItem(
                                        event: event!,
                                        onDeleteQuestion: (question) {
                                          isFirstEntrance = true;
                                          BlocProvider.of<EventCubit>(context)
                                              .deleteQuestion(question.id.toString(), eventId);
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
                                          eventId: state.event.id,
                                          createdAt: '',
                                          points: filteredQuestions[index].points,
                                          updatedAt: '',
                                        ),
                                        onEditQuestion: (question) {
                                          BlocProvider.of<EventCubit>(context).updateQuestion(question, eventId);
                                        },
                                      ),
                                    ],
                                  );
                                },
                                options: CarouselOptions(
                                  padEnds: false,
                                  height: 600,
                                  aspectRatio: 2.0, // Adjust aspectRatio to your preference
                                  viewportFraction: 0.3, // Adjust viewportFraction to your preference
                                  enableInfiniteScroll: false, // Disable infinite scroll
                                  autoPlay: false, // Disable auto-play
                                  initialPage: 0, // Set the initial page to 0 (start on the left)
                                ),
                              )
                            ],
                          )
                        : const Text(
                            'Sem questões criadas para esta zona',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                          ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            _questionsCarouselController.previousPage();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () {
                            _questionsCarouselController.nextPage();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
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

  _buildTeamItem(Team team) {
    return GestureDetector(
      onTap: () async {
        isFirstEntrance = true;
        await Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => TeamDetails(
              team: team,
            ),
          ),
        );

        // ignore: use_build_context_synchronously
        BlocProvider.of<EventCubit>(context).getEvent(eventId);
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
                Row(
                  children: [
                    const Text('Criação:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Text(team.createdAt.toIso8601String(), style: const TextStyle(fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text('Estado:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Text(team.isVerified.isEmpty ? 'Equipa não verificada ⛔️' : team.isVerified,
                        style: TextStyle(
                            color: team.isVerified != "Approved" ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text('Check-in:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Text(!team.isCheckedIn ? 'N/A' : 'Checked-in ✅',
                        style: TextStyle(
                            color: !team.isCheckedIn ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text('Pontos actuais:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Text(team.totalPoints.toString()),
                  ],
                ),
                const SizedBox(height: 5),
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
                event: event!,
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
