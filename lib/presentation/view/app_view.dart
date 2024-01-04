import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:hw_dashboard_client/presentation/l10n/l10n.dart';

import 'package:hw_dashboard_client/presentation/view/app_configs/routes.dart';

import 'package:hw_dashboard_client/presentation/view/app_configs/theme.dart';

import 'package:hw_dashboard_client/presentation/view/app_dialogs/session_expired_dialog.dart';

import 'package:hw_dashboard_domain/hw_dashboard_domain.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    PlatformDispatcher.instance.onError = (exception, stackTrace) {
      if (exception is AppException) {
        if (exception.type == ExceptionType.authorization) {
          showSessionExpiredDialog(rootNavigatorKey.currentContext!);

          return true;
        } else {
          // showSomeErrorDialog(rootNavigatorKey.currentContext!, exception.toString());

          return false;
        }
      } else {
        showSomeErrorDialog(rootNavigatorKey.currentContext!, exception.toString());
      }

      return false;
    };

    return const MainView();
  }
}

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        // ignore: use_named_constants
        textScaler: const TextScaler.linear(1),
      ),
      child: MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
        title: 'HW Dashboard',
        routerConfig: router,
        theme: theme,
      ),
    );
  }
}
