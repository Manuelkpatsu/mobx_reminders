import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_reminders/dialogs/show_auth_error_dialog.dart';
import 'package:mobx_reminders/loading/loading_screen.dart';
import 'package:mobx_reminders/state/app_state.dart';
import 'package:provider/provider.dart';

import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/reminders_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(
    Provider<AppState>(
      create: (_) => AppState()..initialize(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReactionBuilder(
        builder: (context) {
          return autorun(
            (_) {
              // handle loading screen
              final isLoading = context.read<AppState>().isLoading;
              if (isLoading) {
                LoadingScreen.instance().show(
                  context: context,
                  text: 'Loading...',
                );
              } else {
                LoadingScreen.instance().hide();
              }

              // handle auth error
              final authError = context.read<AppState>().authError;
              if (authError != null) {
                showAuthErrorDialog(context: context, authError: authError);
              }
            },
          );
        },
        child: Observer(
          builder: (context) {
            switch (context.read<AppState>().currentScreen) {
              case AppScreen.login:
                return const LoginView();
              case AppScreen.register:
                return const RegisterView();
              case AppScreen.reminders:
                return const RemindersView();
            }
          },
        ),
      ),
    );
  }
}
