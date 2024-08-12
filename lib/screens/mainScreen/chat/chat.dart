import 'dart:async';

import 'package:flutter/material.dart';
import 'package:phsycho/screens/login/login.dart';

import 'package:phsycho/services/bdStore.dart';
import 'message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final List<String> _grades = ['6', '7', '8', '9', '10', '11'];
  final Map<String, List<String>> _courses = {
    '6': ['1', '2', '3', '4'],
    '7': ['1', '2', '3', '4'],
    '8': ['1', '2', '3', '4'],
    '9': ['1', '2', '3'],
    '10': ['1', '2', '3'],
    '11': ['1', '2', '3'],
  };

  String? _selectedGrade;
  String? _selectedCourse;
  List<Map<String, String>> _selectedStudents = [];
  String _selectedStudentName = '';
  String _selectedStudentId = '';
  Map<String, List<Map<String, dynamic>>> _studentConversations = {};
  StreamSubscription<List<Map<String, dynamic>>>? _messageSubscription;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController;
  }

  Future<void> _sendMessage() async {
    final String mensaje = _controller.text.trim();
    if (mensaje.isNotEmpty) {
      DateTime ahora = DateTime.now();

      bool esDuplicado = _studentConversations[_selectedStudentId]?.any((m) =>
              m['Mensaje'] == mensaje &&
              ahora.difference(m['Hora']).inSeconds < 5) ??
          false;

      if (!esDuplicado) {
        setState(() {
          if (_studentConversations[_selectedStudentId] == null) {
            _studentConversations[_selectedStudentId] = [];
          }
         
          _controller.clear(); // Limpiar el campo de texto
        });

        bool success = await _databaseService.sendMessageDB(
            mensaje, ahora, _selectedStudentId);
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al enviar el mensaje')),
          );
        }

        // Actualizar mensajes después de enviar
        _updateMessages();
      } else {
        print('Mensaje duplicado ignorado.');
      }
    }
  }

  void _updateMessages() {
    if (_selectedStudentId.isNotEmpty) {
      _messageSubscription?.cancel(); // Cancelar cualquier suscripción anterior

      _messageSubscription = _databaseService
          .getMessageStream(
            LoginState.infoUser["documentID"],
            _selectedStudentId,
          )
          .listen((nuevosMensajes) {
            setState(() {
              // Inicializar la conversación si no existe
              if (_studentConversations[_selectedStudentId] == null) {
                _studentConversations[_selectedStudentId] = [];
              }

              // Agregar solo los mensajes que no están ya en la conversación
              for (var mensaje in nuevosMensajes) {
                bool esDuplicado = _studentConversations[_selectedStudentId]!.any((m) =>
                    m['ID'] == mensaje['ID'] &&
                    m['Hora'].isAtSameMomentAs(mensaje['Hora']));
                if (!esDuplicado) {
                  _studentConversations[_selectedStudentId]!.add(mensaje);
                }
              }

              // Ordenar los mensajes por la hora en orden ascendente
              _studentConversations[_selectedStudentId]!.sort((a, b) => a['Hora'].compareTo(b['Hora']));
            });
          });
    }
  }

  Future<void> _updateCourse(String? course) async {
    if (course == null || _selectedGrade == null) return;

    setState(() {
      _selectedCourse = course;
      _selectedStudents = [];
    });

    try {
      Map<String, String> students = await _databaseService
          .getStudentsByGradeAndCourse(_selectedGrade!, course);
      setState(() {
        _selectedStudents = students.entries
            .map((entry) => {'id': entry.key, 'name': entry.value})
            .toList();
        if (_selectedStudents.isNotEmpty) {
          _selectedStudentId = _selectedStudents.first['id']!;
          _selectedStudentName = _selectedStudents.first['name']!;
          _updateMessages();
        }
      });
    } catch (e) {
      // Mostrar un Snackbar o diálogo con un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener estudiantes: $e')),
      );
    }
  }

  void _updateGrade(String? grade) {
    setState(() {
      _selectedGrade = grade;
      _selectedCourse = null;
      _selectedStudents = [];
      _selectedStudentName = '';
      _selectedStudentId = '';
      if (grade != null) {
        _updateCourse(_courses[grade]?.first);
      }
    });
  }

  void _selectStudent(Map<String, String> student) {
    setState(() {
      _selectedStudentId = student['id']!;
      _selectedStudentName = student['name']!;
      _updateMessages();
    });
  }

  @override
  void dispose() {
    // Cancelar suscripción cuando el widget se elimine
    _messageSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 166,
            color: Colors.blue[100],
            child: Column(
              children: [
                DropdownButton<String>(
                  value: _selectedGrade,
                  hint: Text('Selecciona el grado'),
                  items: _grades.map((grade) {
                    return DropdownMenuItem<String>(
                      value: grade,
                      child: Text(grade),
                    );
                  }).toList(),
                  onChanged: _updateGrade,
                ),
                if (_selectedGrade != null)
                  DropdownButton<String>(
                    value: _selectedCourse,
                    hint: Text('Selecciona el curso'),
                    items: _courses[_selectedGrade]!.map((course) {
                      return DropdownMenuItem<String>(
                        value: course,
                        child: Text(course),
                      );
                    }).toList(),
                    onChanged: _updateCourse,
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _selectedStudents.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_selectedStudents[index]['name']!),
                        onTap: () => _selectStudent(_selectedStudents[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: Text(_selectedStudentName),
                  backgroundColor: Colors.blue,
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(8.0),
                    itemCount:
                        _studentConversations[_selectedStudentId]?.length ?? 0,
                    itemBuilder: (context, index) {
                      final messageData =
                          _studentConversations[_selectedStudentId]![index];
                      return MessageWidget(
                        isSent: LoginState.infoUser["documentID"] ==
                            messageData["ID"],
                        message: messageData["Mensaje"],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Escribe un mensaje...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
