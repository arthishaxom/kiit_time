part of 'timetable_cubit.dart';

@immutable
sealed class TimetableState {}

final class TimetableInitial extends TimetableState {}

class TimetableLoading extends TimetableState {}

class TimetableLoaded extends TimetableState {}

class TimetableError extends TimetableState {
  final String message;

  TimetableError(this.message);
}
