import 'package:casualbear_backoffice/local_storage.dart';
import 'package:casualbear_backoffice/network/services/api_service.dart';
import 'package:casualbear_backoffice/repositories/authentication_repository.dart';
import 'package:casualbear_backoffice/repositories/event_repository.dart';
import 'package:casualbear_backoffice/repositories/question_repository.dart';
import 'package:casualbear_backoffice/repositories/team_repository.dart';
import 'package:casualbear_backoffice/screens/authentication/cubit/authentication_cubit.dart';
import 'package:casualbear_backoffice/screens/events/cubit/event_cubit.dart';
import 'package:casualbear_backoffice/screens/events/cubit/team_cubit.dart';
import 'package:casualbear_backoffice/screens/events/live_location/cubit/live_location_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/authentication/login_screen.dart';
import 'screens/events/event_details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EventCubit>(
          create: (context) =>
              EventCubit(EventRepository(ApiService.shared), QuestionRepository(apiService: ApiService.shared)),
        ),
        BlocProvider<AuthenticationCubit>(
          create: (context) => AuthenticationCubit(AuthenticationRepository(ApiService.shared)),
        ),
        BlocProvider<TeamCubit>(
          create: (context) => TeamCubit(TeamRepository(apiService: ApiService.shared)),
        ),
        BlocProvider<LiveLocationCubit>(
          create: (context) => LiveLocationCubit(),
        ),
      ],
      child: MaterialApp(
          debugShowMaterialGrid: false,
          title: 'WBD\'Day Backoffice',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xff13335d),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home:
          getToken() != null ? const MainScreen() : const LoginPage()),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.white, body: EventDetailsScreen());
  }
}
