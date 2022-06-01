import 'package:flutter_test/flutter_test.dart';
import 'package:mobx_reminders/state/app_state.dart';

import 'mocks/mock_auth_service.dart';
import 'mocks/mock_image_upload_service.dart';
import 'mocks/mock_reminders_service.dart';

void main() {
  late AppState appState;

  setUp(() {
    appState = AppState(
      authService: MockAuthService(),
      remindersService: MockRemindersService(),
      imageUploadService: MockImageUploadService(),
    );
  });

  test('Initial state', () {
    expect(appState.currentScreen, AppScreen.login);
    appState.authError.expectNull();
    appState.isLoading.expectFalse();
    appState.reminders.isEmpty.expectTrue();
  });

  test('Going to screens', () {
    appState.goTo(AppScreen.register);
    expect(appState.currentScreen, AppScreen.register);
    appState.goTo(AppScreen.login);
    expect(appState.currentScreen, AppScreen.login);
    appState.goTo(AppScreen.reminders);
    expect(appState.currentScreen, AppScreen.reminders);
  });

  test('Initializing the app state', () async {
    await appState.initialize();
    expect(appState.currentScreen, AppScreen.reminders);
    expect(appState.reminders.length, mockReminders.length);
    expect(appState.reminders.contains(mockReminder1), true);
    expect(appState.reminders.contains(mockReminder2), true);
  });

  test('Modifying reminders', () async {
    await appState.initialize();
    await appState.modifyReminder(
      reminderId: mockReminder1Id,
      isDone: false,
    );
    await appState.modifyReminder(
      reminderId: mockReminder2Id,
      isDone: true,
    );
    final reminder1 = appState.reminders.firstWhere(
      (reminder) => reminder.id == mockReminder1Id,
    );
    final reminder2 = appState.reminders.firstWhere(
      (reminder) => reminder.id == mockReminder2Id,
    );
    expect(reminder1.isDone, false);
    expect(reminder2.isDone, true);
  });

  test('Creating reminders', () async {
    await appState.initialize();
    const text = 'text';
    final didCreate = await appState.createReminder(text);
    expect(didCreate, true);
    expect(appState.reminders.length, mockReminders.length + 1);
    final testReminder = appState.reminders.firstWhere(
      (element) => element.id == mockReminderId,
    );
    expect(testReminder.text, text);
    expect(testReminder.isDone, false);
  });

  test('Deleting reminders', () async {
    await appState.initialize();
    final count = appState.reminders.length;
    final reminder = appState.reminders.first;
    final deleted = await appState.delete(reminder);
    expect(deleted, true);
    expect(appState.reminders.length, count - 1);
  });

  test('Deleting account', () async {
    await appState.initialize();
    final couldDeleteAccount = await appState.deleteAccount();
    expect(couldDeleteAccount, true);
    expect(appState.reminders.isEmpty, true);
    expect(appState.currentScreen, AppScreen.login);
  });

  test('Logging out', () async {
    await appState.initialize();
    await appState.logOut();
    expect(appState.reminders.isEmpty, true);
    expect(appState.currentScreen, AppScreen.login);
  });

  test('Uploading image for reminder', () async {
    await appState.initialize();
    final reminder = appState.reminders.firstWhere(
      (element) => element.id == mockReminder1Id,
    );
    reminder.hasImage.expectFalse();
    reminder.imageData.expectNull();

    // fake upload image for this reminder
    final couldUploadImage = await appState.upload(
      filePath: 'dummy_path',
      forReminderId: reminder.id,
    );

    couldUploadImage.expectTrue();
    reminder.hasImage.expectTrue();
    reminder.imageData.expectNull();

    final imageData = await appState.getReminderImage(reminderId: reminder.id);
    imageData.expectNotNull();
    imageData!.isEqualTo(mockReminder1ImageData).expectTrue();
  });
}

extension Expectations on Object? {
  void expectNull() => expect(this, isNull);
  void expectNotNull() => expect(this, isNotNull);
}

extension BoolExpectations on bool {
  void expectTrue() => expect(this, true);
  void expectFalse() => expect(this, false);
}

extension Comparison<E> on List<E> {
  bool isEqualTo(List<E> other) {
    if (identical(this, other)) {
      return true;
    }
    if (length != other.length) {
      return false;
    }
    for (var i = 0; i < length; i++) {
      if (this[i] != other[i]) {
        return false;
      }
    }
    return true;
  }
}
