import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'data/models/reminder_model.dart';
import 'logic/reminder_cubit.dart';
import 'core/services/notification_service.dart'; // <-- Import the service

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize the Notification Engine
  await NotificationService().init();

  // 2. Initialize the Database
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [ReminderModelSchema],
    directory: dir.path,
  );

  runApp(RememberApp(isar: isar));
}

class RememberApp extends StatelessWidget {
  final Isar isar;

  const RememberApp({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReminderCubit(isar)..loadReminders(),
      child: MaterialApp(
        title: 'Remember',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: const HomeScreen(), // <-- Let's extract the screen for cleanliness
      ),
    );
  }
}

// A simple temporary home screen to test our engines
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Remember App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Database Initialized! 🚀',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.notifications_active),
              label: const Text("Test Local Notification"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onPressed: () {
                // Trigger the notification!
                NotificationService().showTestNotification(
                  "Time to Drink Water!", 
                  "Stay hydrated. You got this.",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}