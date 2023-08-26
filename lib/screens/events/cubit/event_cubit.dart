import 'package:bloc/bloc.dart';
import 'package:casualbear_backoffice/network/models/event.dart';
import 'package:casualbear_backoffice/network/models/question.dart';
import 'package:casualbear_backoffice/network/models/team.dart';
import 'package:casualbear_backoffice/repositories/event_repository.dart';
import 'package:casualbear_backoffice/repositories/question_repository.dart';
import 'package:flutter/material.dart';
part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final EventRepository repository;
  final QuestionRepository questionRepository;
  EventCubit(this.repository, this.questionRepository) : super(EventInitial());

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

  void getScores() async {
    emit(GetScoresLoading());
    try {
      List<Team> scores = await repository.getScores();
      emit(GetScoresLoaded(scores: scores));
    } catch (e) {
      emit(GetScoresError());
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
      await questionRepository.addQuestion(question, eventId);
      Event response = await repository.getEvent(eventId);
      emit(SingleEventGetLoaded(response));
    } catch (e) {
      emit(CreateQuestionError());
    }
  }

  void updateQuestion(Question question, String eventId) async {
    emit(CreateQuestionLoading());
    try {
      await questionRepository.updateQuestion(question, eventId);
      Event response = await repository.getEvent(eventId);
      emit(SingleEventGetLoaded(response));
    } catch (e) {
      emit(CreateQuestionError());
    }
  }

  void deleteQuestion(String questionId, String eventId) async {
    emit(CreateQuestionLoading());
    try {
      await questionRepository.deleteQuestion(questionId);
      Event response = await repository.getEvent(eventId);
      emit(SingleEventGetLoaded(response));
    } catch (e) {
      emit(CreateQuestionError());
    }
  }
}
