import 'package:flutter/material.dart';
import 'package:phsycho/components/item/color.dart';
import '../../components/sidebarx.dart';
import "../../components/item/styles.dart";
import "../../components/item/theme.dart";
import 'chat/chat.dart';
import 'principal/notice.dart';
import 'appointment/appointment.dart';
import 'settings/settings.dart';
import 'sesions.dart';

class Mainpage extends StatelessWidget {
  Mainpage({Key? key}) : super(key: key);

  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();
  static const routename = "MainPage";
  // Usar ValueNotifier para mantener el título actual
  final ValueNotifier<String> _titleNotifier = ValueNotifier<String>(getTitleByIndex(0));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: mainTheme,
      home: Builder(
        builder: (context) {
          final isSmallScreen = MediaQuery.of(context).size.width < 600;
          return Scaffold(
            key: _key,
            appBar: isSmallScreen
                ? AppBar(
                    backgroundColor: canvasColor,
                    title: ValueListenableBuilder<String>(
                      valueListenable: _titleNotifier,
                      builder: (context, title, child) {
                        return Text(title);
                      },
                    ),
                    leading: IconButton(
                      onPressed: () {
                        _key.currentState?.openDrawer();
                      },
                      icon: const Icon(Icons.menu),
                    ),
                  )
                : null,
            drawer: BuildSidebarX(
              controller: _controller,
              titleNotifier: _titleNotifier,
            ),
            body: Row(
              children: [
                if (!isSmallScreen)
                  BuildSidebarX(
                    controller: _controller,
                    titleNotifier: _titleNotifier,
                  ),
                Expanded(
                  child: Center(
                    child: Sesions(
                      controller: _controller,
                      titleNotifier: _titleNotifier,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BuildSidebarX extends StatelessWidget {
  const BuildSidebarX({
    Key? key,
    required SidebarXController controller,
    required this.titleNotifier,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;
  final ValueNotifier<String> titleNotifier;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: sidebarTheme,
      extendedTheme: extendedSidebarTheme,
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset('../assets/images/avatar.png'),
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.home,
          label: 'Inicio',
          onTap: () {
            debugPrint('Home');
            titleNotifier.value = getTitleByIndex(0);
          },
        ),
        SidebarXItem(
          icon: Icons.calendar_month,
          label: 'Cita',
          onTap: () {
            titleNotifier.value = getTitleByIndex(1);
          },
        ),
        SidebarXItem(
          icon: Icons.chat,
          label: 'Conversación',
          onTap: () {
            titleNotifier.value = getTitleByIndex(2);
          },
        ),
        SidebarXItem(
          icon: Icons.settings,
          label: 'Configuración',
          onTap: () {
            titleNotifier.value = getTitleByIndex(3);
          },
        ),
        SidebarXItem(
          icon: Icons.settings,
          label: 'Pruebas',
          onTap: () {
            titleNotifier.value = getTitleByIndex(4);
          },
        ),
        SidebarXItem(
          icon: Icons.image,
          label: "Imagenes",
          onTap: () {
            titleNotifier.value=getTitleByIndex(5);
          },
        )
      ],
    );
  }
}



