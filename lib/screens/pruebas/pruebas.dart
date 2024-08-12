import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FetchData extends StatefulWidget {
  const FetchData({super.key});

  @override
  State<FetchData> createState() => _Crud();
}

class _Crud extends State<FetchData> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Muestra un formulario para crear o actualizar un documento
  void _showForm({DocumentSnapshot? document}) {
    final bool isEditing = document != null; // Verifica si estamos editando un documento existente

    // Controladores de texto para los campos del formulario
    final TextEditingController nameController = TextEditingController(text: isEditing ? document['name'] : '');
    final TextEditingController idController = TextEditingController(text: isEditing ? document['id'] : '');
    final TextEditingController courseController = TextEditingController(text: isEditing ? document['course'] : '');
    final TextEditingController ageController = TextEditingController(text: isEditing ? document['age'] : '');
    final TextEditingController codigoInstitucionalController = TextEditingController(text: isEditing ? document['codigoInstitucional'] : '');
    final TextEditingController genderController = TextEditingController(text: isEditing ? document['gender'] : '');
    final TextEditingController gradeController = TextEditingController(text: isEditing ? document['grade'] : '');
    final TextEditingController passwordController = TextEditingController(text: isEditing ? document['password'] : '');
    final TextEditingController roleController = TextEditingController(text: isEditing ? document['role'] : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Document' : 'Add Document'), // Título del diálogo
          content: SingleChildScrollView(
            child: Column(
              children:[
                TextField(
                  controller: nameController,
                 decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(labelText: 'ID'),
                ),
                TextField(
                  controller: courseController,
                  decoration: const InputDecoration(labelText: 'Course'),
                ),
                TextField(
                  controller: ageController,
                  decoration: InputDecoration(labelText: 'Age'),
                ),
                TextField(
                  controller: codigoInstitucionalController,
                  decoration: InputDecoration(labelText: 'Código Institucional'),
                ),
                TextField(
                  controller: genderController,
                  decoration: InputDecoration(labelText: 'Gender'),
                ),
                TextField(
                  controller: gradeController,
                  decoration: InputDecoration(labelText: 'Grade'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true, // Oculta el texto de la contraseña
                ),
                TextField(
                  controller: roleController,
                  decoration: InputDecoration(labelText: 'Role'),
                ),
              ],
              mainAxisSize: MainAxisSize.min,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Validar los datos del formulario
                if (nameController.text.isNotEmpty && idController.text.isNotEmpty && courseController.text.isNotEmpty) {
                  // Agrega o actualiza el documento según sea necesario
                  if (isEditing) {
                    _updateDocument(
                      document.id, // ID del documento a actualizar
                      nameController.text,
                      idController.text,
                      courseController.text,
                      ageController.text,
                      codigoInstitucionalController.text,
                      genderController.text,
                      gradeController.text,
                      passwordController.text,
                      roleController.text,
                    );
                  } else {
                    _addDocument(
                      nameController.text,
                      idController.text,
                      courseController.text,
                      ageController.text,
                      codigoInstitucionalController.text,
                      genderController.text,
                      gradeController.text,
                      passwordController.text,
                      roleController.text,
                    );
                  }
                  Navigator.of(context).pop(); // Cierra el diálogo
                } else {
                  // Mostrar mensaje de error si los campos obligatorios están vacíos
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all required fields')),
                  );
                }
              },
              child: Text(isEditing ? 'Update' : 'Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cierra el diálogo sin hacer cambios
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Agrega un nuevo documento a la colección 'Usuarios-E'
  Future<void> _addDocument(
    String name,
    String id,
    String course,
    String age,
    String codigoInstitucional,
    String gender,
    String grade,
    String password,
    String role,
  ) async {
    await _firestore.collection('Usuarios-E').add({
      'role': role,
      'password': password,
      'name': name,
      'id': id,
      'grade': grade,
      'gender': gender,
      'course': course,
      'codigoInstitucional': codigoInstitucional,
      'age': age,
    });
  }

  // Actualiza un documento existente en la colección 'Usuarios-E'
  Future<void> _updateDocument(
    String docId,
    String name,
    String id,
    String course,
    String age,
    String codigoInstitucional,
    String gender,
    String grade,
    String password,
    String role,
  ) async {
    await _firestore.collection('Usuarios-E').doc(docId).update({
      'role': role,
      'password': password,
      'name': name,
      'id': id,
      'grade': grade,
      'gender': gender,
      'course': course,
      'codigoInstitucional': codigoInstitucional,
      'age': age,
    });
  }

  // Elimina un documento de la colección 'Usuarios-E'
  Future<void> _deleteDocument(String docId) async {
    await _firestore.collection('Usuarios-E').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Data'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showForm(), // Muestra el formulario para agregar un nuevo documento
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Usuarios-E').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Muestra un indicador de carga mientras se esperan los datos
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}")); // Muestra un mensaje de error si ocurre un problema
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data found')); // Muestra un mensaje si no hay datos disponibles
          } else {
            return ListView.separated(
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final data = doc.data() as Map<String, dynamic>;

                return Container(
                  child: ListTile(
                    title: Text(data['name'] ?? 'No Name'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['id'] ?? 'No ID'),
                        Text(data['course'] ?? 'No Course'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showForm(document: doc), // Muestra el formulario para editar el documento
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteDocument(doc.id), // Elimina el documento
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(), // Agrega una línea divisoria entre los elementos de la lista
              itemCount: snapshot.data!.docs.length,
            );
          }
        },
      ),
    );
  }
}
