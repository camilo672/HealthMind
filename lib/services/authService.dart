import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthService {
  // Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
Future<Map<String, dynamic>> checkIfUserExists(String id, String codigoInstitucional, String password) async {
  try {
    print('Iniciando verificación de usuario con ID: $id, Código Institucional: $codigoInstitucional y Password: $password');

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('Usuarios-E')
        .where('id', isEqualTo: id)
        .where('codigoInstitucional', isEqualTo: codigoInstitucional)
        .where('password', isEqualTo: password)
        .get();

    print('Consulta realizada con ${querySnapshot.docs.length} resultados');

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot idUsuario = querySnapshot.docs.first;
      print('Usuario encontrado: ${idUsuario.id}');
      return {
        "exists": true,
        "documentID": idUsuario.id,
        "name": idUsuario.get("name"),
        "age": idUsuario.get("age"),
        "gender": idUsuario.get("gender"),
        "role": idUsuario.get("role")
      };
    } else {
      print('Usuario no encontrado');
      return {
        "exists": false,
        "error": "Usuario no encontrado"
      };
    }
  } catch (e) {
    print('Error encontrado: $e');
    return {
      "exists": false,
      "error": e.toString()
    };
  }
}
