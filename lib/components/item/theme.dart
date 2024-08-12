import 'package:flutter/material.dart';
import 'package:phsycho/components/sidebarx.dart';
import 'styles.dart';
import 'color.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF416FDF),
  onPrimary: Color(0xFFFFFFFF),
  secondary: Color(0xFF6EAEE7),
  onSecondary: Color(0xFFFFFFFF),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  background: Color(0xFFFCFDF6),
  onBackground: Color(0xFF1A1C18),
  shadow: Color(0xFF000000),
  outlineVariant: Color(0xFFC2C8BC),
  surface: Color(0xFFF9FAF3),
  onSurface: Color(0xFF1A1C18),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF416FDF),
  onPrimary: Color(0xFFFFFFFF),
  secondary: Color(0xFF6EAEE7),
  onSecondary: Color(0xFFFFFFFF),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  background: Color(0xFFFCFDF6),
  onBackground: Color(0xFF1A1C18),
  shadow: Color(0xFF000000),
  outlineVariant: Color(0xFFC2C8BC),
  surface: Color(0xFFF9FAF3),
  onSurface: Color(0xFF1A1C18),
);

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        lightColorScheme.primary, // Slightly darker shade for the button
      ),
      foregroundColor:
          MaterialStateProperty.all<Color>(Colors.white), // text color
      elevation: MaterialStateProperty.all<double>(5.0), // shadow
      padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Adjust as needed
        ),
      ),
    ),
  ),
);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
);

//Temas de iconos
IconThemeData iconTheme = IconThemeData(
  color: Colors.white.withOpacity(0.7),
  size: 20,
);
IconThemeData selectedIconTheme = IconThemeData(
  color: Colors.white,
  size: 20,
);

//Temas
ThemeData mainTheme = ThemeData(
  primaryColor: primaryColor,
  canvasColor: canvasColor,
  scaffoldBackgroundColor: scaffoldBackgroundColor,
  textTheme: const TextTheme(
    headlineSmall: TextStyle(
      color: Colors.white,
      fontSize: 46,
      fontWeight: FontWeight.w800,
    ),
  ),
);

//Temas para el sidebar
SidebarXTheme sidebarTheme = SidebarXTheme(
  margin: const EdgeInsets.all(10),
  decoration: BoxDecoration(
    color: canvasColor,
    borderRadius: BorderRadius.circular(20),
  ),
  hoverColor: scaffoldBackgroundColor,
  textStyle: sidebarTxt,
  selectedTextStyle: selectedSidebarTxt,
  hoverTextStyle: hoverSidebarTxt,
  itemTextPadding: const EdgeInsets.only(left: 30),
  selectedItemTextPadding: const EdgeInsets.only(left: 30),
  itemDecoration: itemDecoration,
  selectedItemDecoration: selectedItemDecoration,
  iconTheme: iconTheme,
  selectedIconTheme: selectedIconTheme,
);
SidebarXTheme extendedSidebarTheme = SidebarXTheme(
  width: 200,
  decoration: BoxDecoration(
    color: canvasColor,
  ),
);
