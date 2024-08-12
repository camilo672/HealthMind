import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phsycho/components/item/button.dart';
import 'package:phsycho/components/item/color.dart';
import 'package:phsycho/components/item/styles.dart';
import 'package:phsycho/services/authService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phsycho/services/bdStore.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static const String routename = "login";

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  TextEditingController passwordController = TextEditingController();
  TextEditingController idController = TextEditingController();
  static Map<String, dynamic> infoUser = {};
  bool _isLoading = false;

  late AnimationController _controller;
  late Animation<int> _characterCount;
  String _text = ' HealthMind';

  void singIng() async {
    if (_formKey.currentState!.saveAndValidate()) {
      final formState = _formKey.currentState!;

      // Mostrar indicador de carga
      setState(() {
        _isLoading = true;
      });

      try {
        infoUser = await checkIfUserExists(
          idController.text,
          formState.value['institucion'],
          passwordController.text,
        );

        // Ocultar indicador de carga
        setState(() {
          _isLoading = false;
        });

        if (infoUser['exists']) {
          Navigator.pushNamed(context, 'await');
        } else {
          // Mostrar mensaje de error específico si existe
          showSnackBar(context, infoUser['error'] ?? 'Error desconocido');
        }
      } catch (e) {
        // Ocultar indicador de carga
        setState(() {
          _isLoading = false;
        });
        showSnackBar(
            context, 'Error de conexión. Por favor, inténtalo de nuevo.');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _characterCount = StepTween(
      begin: 0,
      end: _text.length,
    ).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 70,
            left: 26,
            child: Container(
              width: 14,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF0D47A1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 1.5,
                    offset: Offset(4, 8),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 70,
            left: 39,
            child: Container(
              width: 62,
              height: 14,
              decoration: const BoxDecoration(
                color: Color(0xFF0D47A1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 1.5,
                    offset: Offset(4, 5),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 90,
            left: 50,
            child: SizedBox(
              width: 350,
              height: 350,
              child: AnimatedBuilder(
                animation: _characterCount,
                builder: (context, child) {
                  String visibleText =
                      _text.substring(0, _characterCount.value);
                  return Text(
                    visibleText,
                    style: const TextStyle(
                      fontFamily: 'Times news Romans',
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(2, 6),
                          blurRadius: 2,
                          color: Color.fromARGB(77, 134, 134, 134),
                        ),
                        Shadow(
                          color: Color.fromARGB(37, 131, 130, 130),
                          offset: Offset(2, 12),
                          blurRadius: 8,
                        ),
                      ],
                      color: Colors.black,
                      fontSize: 50,
                      letterSpacing: -2.2,
                      height: 1.2,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 190,
            left: 0,
            right: 0,
            bottom: 0,
            child: Material(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            constraints: const BoxConstraints(
                              maxHeight: 476,
                              maxWidth: 320,
                            ),
                            decoration: boxLogin,
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FormBuilder(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Instituciones Afiliadas",
                                        style: styleTextLoginLabel,
                                        textAlign: TextAlign.left,
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        decoration: decorationButtonLogin,
                                        child: FormBuilderDropdown<String>(
                                          dropdownColor: primaryColor,
                                          name: 'institucion',
                                          decoration: inputdecoration(
                                            "Institucion",
                                            "Institucion",
                                          ),
                                          initialValue: '1',
                                          onChanged: (value) {
                                            // ... tu lógica al cambiar el valor ...
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              setState(() {});
                                              return "Por Favor selecciona la Institucion a la que Perteneces ";
                                            } else {
                                              setState(() {});
                                            }
                                            return null;
                                          },
                                          items: [
                                            DropdownMenuItem(
                                              value: '1',
                                              child: Text(
                                                'Dolores Maria Ucros',
                                                style: styleTextLoginLabel2,
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: '2',
                                              child: Text(
                                                'Itida',
                                                style: styleTextLoginLabel2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 25),
                                      Text(
                                        "Usuarios",
                                        style: styleTextLoginLabel,
                                        textAlign: TextAlign.left,
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        decoration: decorationButtonLogin,
                                        child: FormBuilderTextField(
                                          name: 'userId',
                                          controller: idController,
                                          decoration: inputdecoration(
                                            "ID Usuario",
                                            "Identificacion",
                                          ),
                                          onSubmitted: (value) {
                                            singIng();
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              setState(() {});
                                              return "Por favor digita tu ID de Usuario ";
                                            } else {
                                              setState(() {});
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 25),
                                      Text(
                                        "Contraseña",
                                        style: styleTextLoginLabel,
                                        textAlign: TextAlign.left,
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        decoration: decorationButtonLogin,
                                        child: FormBuilderTextField(
                                          name: 'password',
                                          obscureText: true,
                                          controller: passwordController,
                                          decoration: inputdecoration(
                                            "Contraseña",
                                            "Contraseña",
                                          ),
                                          onSubmitted: (value) {
                                            singIng();
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              setState(() {});
                                              return "Por favor digita tu contraseña";
                                            } else {
                                              setState(() {});
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 40),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 40,
                                        child: Button(
                                          onPressed: () async {
                                            singIng();
                                          },
                                          text: "Iniciar sesión",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
