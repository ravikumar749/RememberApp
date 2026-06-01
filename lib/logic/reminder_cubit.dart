import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import '../data/models/reminder_model.dart';
import 'reminder_state.dart';

class ReminderCubit extends Cubit<ReminderState> {
  final Isar isar;

  ReminderCubit(this.isar) : super(ReminderInitial());

  // READ: Fetch all reminders from the local database
  Future<void> loadReminders() async {
    try {
      emit(ReminderLoading());
      // Find all reminders and sort them by creation date
      final reminders = await isar.reminderModels
          .where()
          .sortByCreatedAtDesc()
          .findAll();
      
      emit(RemindersLoaded(reminders));
    } catch (e) {
      emit(ReminderError("Failed to load reminders: ${e.toString()}"));
    }
  }

  // CREATE / UPDATE: Add a new reminder or update an existing one
  Future<void> saveReminder(ReminderModel reminder) async {
    try {
      await isar.writeTxn(() async {
        await isar.reminderModels.put(reminder); // put() inserts or updates
      });
      // Refresh the list after saving
      await loadReminders();
    } catch (e) {
      emit(ReminderError("Failed to save reminder: ${e.toString()}"));
    }
  }

  // DELETE: Remove a reminder by ID
  Future<void> deleteReminder(int id) async {
    try {
      await isar.writeTxn(() async {
        await isar.reminderModels.delete(id);
      });
      // Refresh the list after deletion
      await loadReminders();
    } catch (e) {
      emit(ReminderError("Failed to delete reminder: ${e.toString()}"));
    }
  }
}