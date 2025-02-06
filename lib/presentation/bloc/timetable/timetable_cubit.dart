import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiittime/repo/class_repo.dart';

part 'timetable_state.dart';

class TimetableCubit extends Cubit<TimetableState> {
  final TimetableRepository repository;

  TimetableCubit(this.repository) : super(TimetableInitial());

  void loadTimetable(String roll) async {
    try {
      emit(TimetableLoading());
      await repository.fetchAndStoreTimetable(roll);
      emit(TimetableLoaded());
    } catch (e) {
      emit(TimetableError(e.toString()));
    }
  }

  void loadLocalTimetable() async {
    try {
      emit(TimetableLoading());
      emit(TimetableLoaded());
    } catch (e) {
      emit(TimetableError(e.toString()));
    }
  }

  void scheduleClasses() async {
    try {
      await repository.scheduleAllClassNotifications();
    } catch (e) {
      emit(TimetableError(e.toString()));
    }
  }
}
