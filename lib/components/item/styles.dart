import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phsycho/components/sidebarx.dart';
import 'theme.dart';
import 'color.dart';

//Texto
String title = "HealthMind";

//Estilos de texto
TextStyle titleLogin = TextStyle(
  fontSize: 40.0,
  fontWeight: FontWeight.w900,
  color: lightColorScheme.primary,
);
TextStyle sidebarTxt = TextStyle(color: Colors.white.withOpacity(0.7));
TextStyle selectedSidebarTxt = TextStyle(color: Colors.white.withOpacity(0.7));
TextStyle hoverSidebarTxt = TextStyle(color: Colors.white.withOpacity(0.7));

//Estilos para "BoxDecoration"
BoxDecoration itemDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  border: Border.all(color: canvasColor),
);
BoxDecoration selectedItemDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  border: Border.all(
    color: actionColor.withOpacity(0.37),
  ),
  gradient: const LinearGradient(
    colors: [accentCanvasColor, canvasColor],
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.28),
      blurRadius: 30,
    )
  ],
);
BoxDecoration boxLogin = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      spreadRadius: 10,
      blurRadius: 10,
      offset: const Offset(0, 3), // Cambia la posición de la sombra
    ),
  ],
);

//Estilos para "InputDecoration"
InputDecoration inputdecoration(String text, String htext) {
  return InputDecoration(
    hintText: htext,

    hintStyle: const TextStyle(
      color: Colors.black26,
    ),
    // --- Sombra interior ---
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none, // Sin borde exterior
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none, // Sin borde exterior
    ),
    filled: true,
    fillColor: const Color.fromARGB(255, 255, 255, 255), // Color de fondo del input
     contentPadding: EdgeInsets.symmetric(horizontal: 12),
     
    // --- Fin de la sombra interior ---
  );
}

//button
ButtonStyle button = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(
    side: BorderSide.none,
    borderRadius: BorderRadius.circular(10),
  ),
);
final BoxDecoration decorationButtonLogin = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      spreadRadius: -5,
      blurRadius: 10,
      offset: Offset(5, -5),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      spreadRadius: -5,
      blurRadius:10,
      offset: Offset(-5, 5),
    ),
  ],
);
TextStyle styleTextLoginLabel = GoogleFonts.inter(
  textStyle: TextStyle(
    color: Color.fromARGB(255, 54, 54, 54),
    fontSize: 15,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.none,
    decorationStyle: TextDecorationStyle.solid, // Esto es opcional
  ),
);TextStyle styleTextLoginLabel2 = GoogleFonts.inter(
  textStyle: TextStyle(
    color: Color.fromARGB(255, 182, 181, 181),
    fontSize: 15,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.none,
    decorationStyle: TextDecorationStyle.solid, // Esto es opcional
  ),
);
final BoxDecoration decorationButtonLoginSH = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  
);