import 'package:mobx_reminders/provider/reminders_provider.dart';
import 'package:mobx_reminders/state/reminder.dart';

import '../utils.dart';

final mockReminder1DateTime = DateTime(2000, 1, 2, 3, 4, 5, 6, 7);
const mockReminder1Id = '1';
const mockReminder1Text = 'text1';
const mockReminder1IsDone = true;
final mockReminder1 = Reminder(
  creationDate: mockReminder1DateTime,
  id: mockReminder1Id,
  text: mockReminder1Text,
  isDone: mockReminder1IsDone,
);

final mockReminder2DateTime = DateTime(2000, 1, 2, 3, 4, 5, 6, 7);
const mockReminder2Id = '2';
const mockReminder2Text = 'text2';
const mockReminder2IsDone = false;
final mockReminder2 = Reminder(
  creationDate: mockReminder2DateTime,
  id: mockReminder2Id,
  text: mockReminder2Text,
  isDone: mockReminder2IsDone,
);

const mockReminderId = 'mockReminderId';

final Iterable<Reminder> mockReminders = [mockReminder1, mockReminder2];

class MockRemindersProvider implements RemindersProvider {
  @override
  Future<ReminderId> createReminder({
    required String userId,
    required String text,
    required DateTime creationDate,
  }) =>
      Future.delayed(oneSecond, () => mockReminderId.toFuture(oneSecond));

  @override
  Future<void> deleteAllDocuments({required String userId}) =>
      Future.delayed(oneSecond);

  @override
  Future<void> deleteReminderWithId(
    ReminderId id, {
    required String userId,
  }) =>
      Future.delayed(oneSecond);

  @override
  Future<Iterable<Reminder>> loadReminders({required String userId}) =>
      Future.delayed(oneSecond, () => mockReminders.toFuture(oneSecond));

  @override
  Future<void> modify({
    required ReminderId reminderId,
    required bool isDone,
    required String userId,
  }) =>
      Future.delayed(oneSecond);
}
