import 'package:flutter/material.dart' show BuildContext;
import 'package:mobx_reminders/auth/auth_error.dart';

import 'generic_dialog.dart';

Future<void> showAuthErrorDialog({
  required BuildContext context,
  required AuthError authError,
}) {
  return showGenericDialog<bool>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    optionsBuilder: () => {'OK': true},
  );
}
