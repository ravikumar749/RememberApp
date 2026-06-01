import 'package:isar/isar.dart';

part 'reminder_model.g.dart';

enum ReminderType {
  time,
  location,
  habit,
  medicine
}

@collection
class ReminderModel {
  Id id = Isar.autoIncrement; // Isar automatic primary key

  @Enumerated(EnumType.name)
  late ReminderType type;

  late String title;
  String? description;
  
  // Time-based config fields
  DateTime? triggerTime;
  bool isRecurring = false;
  String? recurrenceRule; // Stores RRULE string (e.g., "FREQ=DAILY")

  // Location-based config fields
  double? latitude;
  double? longitude;
  int? radiusMeters;
  String? locationName;

  // Habit/Medicine specific metadata (Kept extensible via JSON string)
  String? customMetadata; 

  late DateTime createdAt;
  bool isCompleted = false;
}