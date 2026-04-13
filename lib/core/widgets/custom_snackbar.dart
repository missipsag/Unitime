import 'package:flutter/material.dart';
import 'package:unitime/core/utils/command.dart';

void customErrorSnackBar(BuildContext context, Command command, String? errorMessage) {

    ThemeData theme = Theme.of(context);

    if (command.completed) {
      if (command.error != null ||
         errorMessage != null) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
             errorMessage ??
                  "Something went wrong. Please try again later.",
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.onError,
              ),
            ),
            elevation: 2,
            action: SnackBarAction(
              label: "Got it",
              textColor: theme.colorScheme.onError,

              onPressed: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
              },
            ),
            backgroundColor: theme.colorScheme.error,
          ),
        );
        command.clear();
      }
    }
  }
