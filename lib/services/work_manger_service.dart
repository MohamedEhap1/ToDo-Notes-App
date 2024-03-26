import 'package:notes_app/services/local_notification_service.dart';
import 'package:workmanager/workmanager.dart';

class WorkManagerService {
  void registerMyTask() async {
    await Workmanager().registerPeriodicTask(
      'id 1',
      'show simple Notification',
      frequency: const Duration(
        minutes: 37, //minimum 15 minute and ignore else
      ),
    );
  }

  Future<void> init() async {
    await Workmanager().initialize(
        actionTask, // The top level function, aka callbackDispatcher
        isInDebugMode:
            true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    registerMyTask();
  }
}

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+

void actionTask() {
  Workmanager().executeTask((taskName, inputData) {
    LocalNotification.showDailyScheduledNotification();
    return Future.value(true);
  });
}
