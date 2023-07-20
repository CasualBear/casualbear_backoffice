import 'package:bloc/bloc.dart';
import 'package:casualbear_backoffice/network/models/event.dart';
import 'package:casualbear_backoffice/network/models/team.dart';
import 'package:casualbear_backoffice/repositories/event_repository.dart';
import 'package:flutter/material.dart';
part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final EventRepository repository;
  EventCubit(this.repository) : super(EventInitial());

  // Event

  void createEvent(List<int> selectedFile, String name, String description, String color) async {
    emit(EventCreationLoading());
    try {
      await repository.createEvent(selectedFile, name, description, color);
      emit(EventCreationLoaded());
    } catch (e) {
      emit(EventCreationError());
    }
  }

  void updateEvent(List<int> selectedFile, String name, String description, String color, String eventId) async {
    emit(EventCreationLoading());
    try {
      await repository.updateEvent(selectedFile, name, description, color, eventId);
      emit(EventCreationLoaded());
    } catch (e) {
      emit(EventCreationError());
    }
  }

  void getEvents() async {
    emit(EventGetLoading());
    try {
      List<Event> response = await repository.getEvents();
      emit(EventGetLoaded(response));
    } catch (e) {
      emit(EventGetError());
    }
  }

  void getEvent(String id) async {
    emit(SingleEventGetLoading());
    try {
      Event response = await repository.getEvent(id);
      emit(SingleEventGetLoaded(response));
    } catch (e) {
      emit(EventGetError());
    }
  }

  void deleteEvent(String eventId) async {
    emit(EventDeleteLoading());
    try {
      await repository.deleteEvent(eventId);
      emit(EventDeleteLoaded());
    } catch (e) {
      emit(EventDeleteError());
    }
  }

  // Question

  void addQuestion(Question question, String eventId) async {
    emit(CreateQuestionLoading());
    try {
      await repository.addQuestion(question, eventId);
      Event response = await repository.getEvent(eventId);
      emit(SingleEventGetLoaded(response));
    } catch (e) {
      emit(CreateQuestionError());
    }
  }

  void updateQuestion(Question question, String eventId) async {
    emit(CreateQuestionLoading());
    try {
      await repository.updateQuestion(question, eventId);
      Event response = await repository.getEvent(eventId);
      emit(SingleEventGetLoaded(response));
    } catch (e) {
      emit(CreateQuestionError());
    }
  }

  void deleteQuestion(String questionId, String eventId) async {
    emit(CreateQuestionLoading());
    try {
      await repository.deleteQuestion(questionId);
      Event response = await repository.getEvent(eventId);
      emit(SingleEventGetLoaded(response));
    } catch (e) {
      emit(CreateQuestionError());
    }
  }

  // Zones

  void updateZoneStates(String eventId, String zoneNameToUpdate, bool status) async {
    emit(CreateQuestionLoading());
    try {
      await repository.updateZoneState(eventId, zoneNameToUpdate, status);
      Event response = await repository.getEvent(eventId);
      emit(SingleEventGetLoaded(response));
    } catch (e) {
      emit(CreateQuestionError());
    }
  }

  // Team
  void getUsersByTeam(String teamId) async {
    emit(GetTeamMemberLoading());
    try {
      List<TeamMember> response = await repository.getUsersByTeam(teamId);
      emit(GetTeamMemberLoaded(teamMembers: response));
    } catch (e) {
      emit(GetTeamMemberError());
    }
  }
}
