import 'package:casualbear_backoffice/local_storage.dart';
import 'package:casualbear_backoffice/network/models/team.dart';
import 'package:casualbear_backoffice/network/models/user.dart';
import 'package:casualbear_backoffice/network/services/api_service.dart';
import 'package:casualbear_backoffice/repositories/authentication_repository.dart';
import 'package:casualbear_backoffice/repositories/event_repository.dart';
import 'package:casualbear_backoffice/repositories/question_repository.dart';
import 'package:casualbear_backoffice/repositories/team_repository.dart';
import 'package:casualbear_backoffice/screens/authentication/cubit/authentication_cubit.dart';
import 'package:casualbear_backoffice/screens/events/cubit/event_cubit.dart';
import 'package:casualbear_backoffice/screens/events/cubit/team_cubit.dart';
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
      ],
      child: MaterialApp(
          debugShowMaterialGrid: false,
          title: 'Flutter Demo',
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

// TODO: Delete dummy data
List<Team> dummyTeams = [
  Team(
    id: 1,
    totalPoints: 500,
    timeSpent: 120,
    isCheckedIn: true,
    isVerified: "Verified",
    name: "Team A",
    members: dummyUsers,
    isCheckedOverall: true,
    zones: "Zone 1, Zone 2",
    createdAt: DateTime(2023, 9, 10),
    updatedAt: DateTime(2023, 9, 10),
    eventId: 100,
  ),
  Team(
    id: 2,
    totalPoints: 450,
    timeSpent: 100,
    isCheckedIn: true,
    isVerified: "Verified",
    name: "Team B",
    members: dummyUsers,
    isCheckedOverall: true,
    zones: "Zone 3, Zone 4",
    createdAt: DateTime(2023, 9, 11),
    updatedAt: DateTime(2023, 9, 11),
    eventId: 100,
  ),
  Team(
    id: 3,
    totalPoints: 600,
    timeSpent: 150,
    isCheckedIn: true,
    isVerified: "Verified",
    name: "Team C",
    members: dummyUsers,
    isCheckedOverall: true,
    zones: "Zone 5, Zone 6",
    createdAt: DateTime(2023, 9, 12),
    updatedAt: DateTime(2023, 9, 12),
    eventId: 100,
  ),
  Team(
    id: 4,
    totalPoints: 350,
    timeSpent: 90,
    isCheckedIn: true,
    isVerified: "Verified",
    name: "Team D",
    members: dummyUsers,
    isCheckedOverall: true,
    zones: "Zone 7, Zone 8",
    createdAt: DateTime(2023, 9, 13),
    updatedAt: DateTime(2023, 9, 13),
    eventId: 100,
  ),
  Team(
    id: 5,
    totalPoints: 700,
    timeSpent: 180,
    isCheckedIn: true,
    isVerified: "Verified",
    name: "Team E",
    members: dummyUsers,
    isCheckedOverall: true,
    zones: "Zone 9, Zone 10",
    createdAt: DateTime(2023, 9, 14),
    updatedAt: DateTime(2023, 9, 14),
    eventId: 100,
  ),
];

List<User> dummyUsers = [
  User(
    id: 1,
    name: "User 1",
    email: "user1@example.com",
    postalCode: "12345",
    role: "Role 1",
    password: "password1",
    dateOfBirth: DateTime(1990, 1, 1),
    cc: "1234567890",
    phone: "123-456-7890",
    address: "123 Main St",
    nosCard: "NOS123",
    tShirtSize: "Medium",
    isCheckedPrivacyData: true,
    isCheckedTermsConditions: true,
    isCaptain: true,
    teamId: "Team 1",
    createdAt: DateTime(2023, 9, 10),
    updatedAt: DateTime(2023, 9, 10),
  ),
  User(
    id: 2,
    name: "User 2",
    email: "user2@example.com",
    postalCode: "23456",
    role: "Role 2",
    password: "password2",
    dateOfBirth: DateTime(1991, 2, 2),
    cc: "2345678901",
    phone: "234-567-8901",
    address: "234 Main St",
    nosCard: "NOS234",
    tShirtSize: "Large",
    isCheckedPrivacyData: true,
    isCheckedTermsConditions: true,
    isCaptain: false,
    teamId: "Team 2",
    createdAt: DateTime(2023, 9, 11),
    updatedAt: DateTime(2023, 9, 11),
  ),
  User(
    id: 3,
    name: "User 3",
    email: "user3@example.com",
    postalCode: "34567",
    role: "Role 3",
    password: "password3",
    dateOfBirth: DateTime(1992, 3, 3),
    cc: "3456789012",
    phone: "345-678-9012",
    address: "345 Main St",
    nosCard: "NOS345",
    tShirtSize: "Small",
    isCheckedPrivacyData: true,
    isCheckedTermsConditions: true,
    isCaptain: false,
    teamId: "Team 3",
    createdAt: DateTime(2023, 9, 12),
    updatedAt: DateTime(2023, 9, 12),
  ),
  User(
    id: 4,
    name: "User 4",
    email: "user4@example.com",
    postalCode: "45678",
    role: "Role 4",
    password: "password4",
    dateOfBirth: DateTime(1993, 4, 4),
    cc: "4567890123",
    phone: "456-789-0123",
    address: "456 Main St",
    nosCard: "NOS456",
    tShirtSize: "XL",
    isCheckedPrivacyData: true,
    isCheckedTermsConditions: true,
    isCaptain: false,
    teamId: "Team 4",
    createdAt: DateTime(2023, 9, 13),
    updatedAt: DateTime(2023, 9, 13),
  ),
];



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
