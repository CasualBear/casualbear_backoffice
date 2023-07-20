part of 'event_cubit.dart';

@immutable
abstract class EventState {}

class EventInitial extends EventState {}

// Event Creation
class EventCreationLoading extends EventState {}

class EventCreationLoaded extends EventState {}

class EventCreationError extends EventState {}

// Event Get
class EventGetLoading extends EventState {}

class SingleEventGetLoading extends EventState {}

class EventGetLoaded extends EventState {
  final List<Event> events;

  EventGetLoaded(this.events);
}

// Single Event Creation
class SingleEventGetLoaded extends EventState {
  final Event event;

  SingleEventGetLoaded(this.event);
}

class EventGetError extends EventState {}

// Delete Event Creation

class EventDeleteLoading extends EventState {}

class EventDeleteLoaded extends EventState {}

class EventDeleteError extends EventState {}

// Questions

// Get
class CreateQuestionLoading extends EventState {}

class CreateQuestionLoaded extends EventState {
  CreateQuestionLoaded();
}

class CreateQuestionError extends EventState {}
