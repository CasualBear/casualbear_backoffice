/*import 'package:casualbear_backoffice/network/models/event.dart';
import 'package:casualbear_backoffice/screens/events/cubit/event_cubit.dart';
import 'package:casualbear_backoffice/screens/events/event_details.dart';
import 'package:casualbear_backoffice/widgets/create_event_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class EventList extends StatefulWidget {
  const EventList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  void initState() {
    BlocProvider.of<EventCubit>(context).getEvents();
    super.initState();
  }

  void addOrEditItemToList(Event? event) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CreateEventDialog(
            event: event,
            onSaveCompleted: () {
              Navigator.pop(context);
              BlocProvider.of<EventCubit>(context).getEvents();
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Eventos",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  decoration: TextDecoration.underline)),
          BlocConsumer<EventCubit, EventState>(
            buildWhen: (previous, current) =>
                current is EventGetLoading || current is EventGetLoaded || current is EventGetError,
            listenWhen: (previous, current) => current is EventGetError || current is EventGetLoaded,
            listener: (context, state) {
              if (state is EventGetError) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Error while getting the events, try again!"),
                ));
              } else if (state is EventGetLoaded) {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => EventDetailsScreen(event: state.events[0]),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Container();
            },
          )
        ],
      ),
    );
  }

  Widget _buildListItem(Event event) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                const Text(
                  'Nome Evento: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  event.name,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 10),
                const Text(
                  'Descrição: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  event.description,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 10),
                const Text(
                  'Data Criação: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  event.createdAt.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => EventDetailsScreen(event: event),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Text(
                      'Ver Detalhes',
                      style: TextStyle(
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(width: 5),
                    Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor, size: 20)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

int getColor(int color) {
  int result = (0xff << 24) | color;
  return result;
}
*/