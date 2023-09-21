import 'package:casualbear_backoffice/network/models/team.dart';
import 'package:casualbear_backoffice/network/models/user.dart';
import 'package:casualbear_backoffice/screens/events/live_location/cubit/live_location_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchWidget extends StatefulWidget {
  final List<Team> teams;

  const SearchWidget({super.key, required this.teams});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Team> _searchResults = [];

  void _search() {
    String query = _searchController.text.toLowerCase();
    List<Team> results = [];

    if (query.isNotEmpty) {
      for (Team team in widget.teams) {
        if (team.searchableText.toLowerCase().contains(query)) {
          results.add(team);
        }
      }
    }

    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
        title: const Text('Pesquisa de equipas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _search(),
              decoration: const InputDecoration(
                hintText: 'Pesquisar...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                // String of members in the team
                String members = '';
               final List<User> membersList = _searchResults[index].members ?? [];
                for (User member in membersList) {
                  members += '${member.name}, ';
                }

                return ListTile(
                  title: Text(_searchResults[index].name),
                  subtitle: Text(members),
                  onTap: () {
                    // Handle item selection here
                    BlocProvider.of<LiveLocationCubit>(context)
                        .selectTeam(_searchResults[index].id);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Atenção: a pesquisa é feita com base nas equipas visiveis no mapa.', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
