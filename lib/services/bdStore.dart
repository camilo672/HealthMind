import 'dart:io';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phsycho/screens/login/login.dart';

import 'package:phsycho/screens/mainScreen/chat/message.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage.instance;

Future<void> setUser(String name, String email, String password) async {
  await db
      .collection('Usuarios')
      .add({'FulName': name, 'email': email, 'password': password});
}

Future<void> addAppointment(String reason, String description, String title, 
    DateTime time, String name,String url,) async {
  await db.collection('appointment').add({
    'title': title,
    'content': description,
    'reason': reason,
    'time': time,
    'name': name,
    'url':url
  });
}

Stream<List<Map<String, dynamic>>> getMessageStream(
    String usuario1, String usuario2) {
  var query1 = db
      .collection('Mensajes')
      .where('id', isEqualTo: usuario1)
      .where('Destinatario', isEqualTo: usuario2)
      .snapshots();

  var query2 = db
      .collection('Mensajes')
      .where('id', isEqualTo: usuario2)
      .where('Destinatario', isEqualTo: usuario1)
      .snapshots();

  var combinedStream = StreamGroup.merge([query1, query2]);

  return combinedStream.map((snapshot) {
    var allDocs = snapshot.docs;
    List<Map<String, dynamic>> messages =
        []; // Declare the list with the correct type

    allDocs.forEach((doc) {
      Map<String, dynamic> message = {
        "ID": doc["id"],
        "Mensaje": doc['mensaje'],
        "Hora": (doc['hora'] as Timestamp).toDate(),
      };

      if (!messages.any((m) =>
          m['Mensaje'] == message['Mensaje'] && m['Hora'] == message['Hora'])) {
        messages.add(message);
      }
    });

    // Ordenar los mensajes por la hora en orden ascendente
    messages.sort((a, b) => a['Hora'].compareTo(b['Hora']));

    print('Mensajes actualizados: $messages'); // Registro de depuración

    return messages; // Return the list with the correct type
  });
}

class DatabaseService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Map<String, String>> getStudentsByGradeAndCourse(
      String grade, String course) async {
    try {
      Map<String, String> students = {};

      QuerySnapshot snapshot = await db
          .collection('Usuarios-E')
          .where('grade', isEqualTo: grade)
          .where('course', isEqualTo: course)
          .where('id', isNotEqualTo: LoginState.infoUser["documentID"])
          .get();

      for (var doc in snapshot.docs) {
        String id = doc.id; // ID del documento
        var data = doc.data() as Map<String, dynamic>;
        String name = data['name'];
        students[id] = name;
      }

      return students;
    } catch (e) {
      print('Error getting students: $e');
      return {};
    }
  }

  Future<bool> sendMessageDB(
      String message, DateTime hora, String destinatario) async {
    try {
      await db.collection('Mensajes').add({
        "id": LoginState.infoUser["documentID"],
        "hora": hora,
        "mensaje": message,
        "Destinatario": destinatario,
      });
      print('Mensaje enviado: $message'); // Registro de depuración
      return true;
    } catch (e) {
      print('Error sending message: $e');
      return false;
    }
  }

  Stream<List<Map<String, dynamic>>> getMessageStream(
      String receptor, String destinatario) {
    var query1 = db
        .collection('Mensajes')
        .where('id', isEqualTo: receptor)
        .where('Destinatario', isEqualTo: destinatario)
        .snapshots();

    var query2 = db
        .collection('Mensajes')
        .where('id', isEqualTo: destinatario)
        .where('Destinatario', isEqualTo: receptor)
        .snapshots();

    var combinedStream = StreamGroup.merge([query1, query2]);

    return combinedStream.map((snapshot) {
      var allDocs = snapshot.docs;
      var messages = allDocs.map((doc) {
        return {
          "ID": doc["id"],
          "Mensaje": doc['mensaje'],
          "Hora": (doc['hora'] as Timestamp).toDate(),
        };
      }).toList();

      // Ordenar los mensajes por la hora en orden ascendente
      messages.sort((a, b) => a['Hora'].compareTo(b['Hora']));

      print('Mensajes actualizados: $messages'); // Registro de depuración

      return messages;
    });
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}

Future<String?> uploadWebFile(PlatformFile file, String userId) async {
  try {
    final String namefile = file.name;
    final Reference ref = FirebaseStorage.instance.ref().child("images").child(namefile);

    // Obtener el tipo de contenido del archivo
    final String contentType = _getContentType(namefile);

    // Convertir el archivo en un Uint8List para subirlo
    final Uint8List fileData = file.bytes!;

    final UploadTask uploadTask = ref.putData(
      fileData,
      SettableMetadata(
        contentType: contentType,
        customMetadata: {'userId': userId},
      ),
    );

    final TaskSnapshot snapshot = await uploadTask;
    final String url = await snapshot.ref.getDownloadURL();
    print('URL del archivo: $url');

    return url;
  } catch (e) {
    print('Error subiendo el archivo: $e');
    return null;
  }
}


Future getImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? imageFile = await picker.pickImage(source: ImageSource.gallery);
  return imageFile;
}


Future<Map<String, dynamic>> uploadImage(File image, String userId) async {
  try {
    // Obtener el nombre del archivo
    final String namefile = image.path.split("/").last;
    final Reference ref = FirebaseStorage.instance.ref().child("images").child(namefile);

    // Obtener el tipo de contenido del archivo
    final String contentType = _getContentType(namefile);

    // Incluir el ID del usuario en los metadatos
    final UploadTask uploadTask = ref.putFile(
      image,
      SettableMetadata(
        contentType: contentType,
        customMetadata: {'userId': userId},
      ),
    );

    // Esperar a que se complete la subida
    final TaskSnapshot snapshot = await uploadTask;

    // Obtener la URL de descarga
    final String url = await snapshot.ref.getDownloadURL();

    return {
      'url': url,
      'message': 'Imagen subida correctamente',
      'status': true,
    };
  } catch (e) {
    return {
      'url': '',
      'message': 'Error subiendo la imagen: $e',
      'status': false,
    };
  }
}

// Función para obtener el tipo de contenido del archivo basado en su extensión
String _getContentType(String filename) {
  if (filename.endsWith('.png')) {
    return 'image/png';
  } else if (filename.endsWith('.jpg') || filename.endsWith('.jpeg')) {
    return 'image/jpeg';
  } else if (filename.endsWith('.gif')) {
    return 'image/gif';
  }
  // Puedes agregar más tipos de contenido según tus necesidades
  return 'application/octet-stream'; // Tipo predeterminado
}
