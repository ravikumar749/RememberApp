import 'reminder_model.dart';

/// Concentrates all Habit-specific business logic away from the UI and Core Model
extension HabitReminderConfig on ReminderModel {
  
  // Example: Factory-style initializer specifically for Habits
  void convertToHabit({
    required String habitName,
    required String frequencyRule,
    String? motivationalNote,
  }) {
    type = ReminderType.habit;
    title = habitName;
    description = motivationalNote;
    recurrenceRule = frequencyRule; // e.g., "FREQ=DAILY"
    isRecurring = true;
    createdAt = DateTime.now();
  }

  // Easy configuration flags for your UI layer to check
  bool get isHabit => type == ReminderType.habit;
  
  // Future proof: Custom habits metadata helper (e.g. tracking a 21-day streak)
  int get currentStreak {
    if (!isHabit || customMetadata == null) return 0;
    // You can parse customMetadata JSON string here later to return actual streak info
    return 0; 
  }
}