import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phsycho/screens/pruebas/pruebaimg.dart';
import 'package:phsycho/screens/pruebas/pruebas.dart';
import '../../components/sidebarx.dart';
import 'chat/chat.dart';
import 'principal/notice.dart';
import 'appointment/appointment.dart';
import 'settings/settings.dart';

class Sesions extends StatelessWidget {
  const Sesions({
    Key? key,
    required this.controller,
    required this.titleNotifier,
  }) : super(key: key);

  final SidebarXController controller;
  final ValueNotifier<String> titleNotifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final pageTitle = getTitleByIndex(controller.selectedIndex);
        titleNotifier.value = pageTitle;
        switch (controller.selectedIndex) {
          case 0:
            return NoticesScreen();
          case 1:
            return AppointmentsPage();
          case 2:
            return ChatsScreen();
          case 3:
            return SettingsScreen();
          case 4:
             return FetchData();
          case 5:
             return HomePage();
          default:
          
            return Text(
              pageTitle,
              style: theme.textTheme.headlineSmall,
            );
        }
      },
    );
  }
}

String getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'Home';
    case 1:
      return 'Cita';
    case 2:
      return 'Conversación';
    case 3:
      return 'Configuración';
    default:
      return 'Not found page';
  }
}