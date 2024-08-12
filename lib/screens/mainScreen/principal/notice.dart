import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:phsycho/screens/login/login.dart';
import 'package:phsycho/services/bdStore.dart';
import 'notice_card.dart';

class NoticesScreen extends StatefulWidget {
  @override
  _NoticesPageState createState() => _NoticesPageState();
}

class _NoticesPageState extends State<NoticesScreen> {
  Map<String, dynamic> infoUser = LoginState.infoUser;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  File? imagenToUpload; // Para móviles
  PlatformFile? webFile; // Para web
  String? imageURL; // URL de la imagen subida
  late Map<String, dynamic> upload;

  List<NoticeCard> _settingCards = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (infoUser['role'] == "0")
            Column(
              children: [
                Text(
                  'Anuncio',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'title',
                        decoration: const InputDecoration(
                          labelText: 'Título',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'reason',
                        decoration: InputDecoration(
                          labelText: 'Motivo',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'content',
                        decoration: InputDecoration(
                          labelText: 'Contenido',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      if (imagenToUpload != null || webFile != null)
                        Container(
                          height: 200, // Ajusta el tamaño de la imagen según sea necesario
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: kIsWeb
                                  ? MemoryImage(webFile!.bytes!)
                                  : FileImage(imagenToUpload!) as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      Container(
                        child: GestureDetector(
                          child: Icon(Icons.upload_file),
                          onTap: () async {
                            if (kIsWeb) {
                              final result = await FilePicker.platform.pickFiles();
                              if (result != null) {
                                setState(() {
                                  webFile = result.files.first;
                                });
                              }
                            } else {
                              final picker = ImagePicker();
                              final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                              if (pickedFile != null) {
                                setState(() {
                                  imagenToUpload = File(pickedFile.path);
                                });
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.saveAndValidate() ?? false) {
                            var formData = _formKey.currentState?.value;
                            String title = formData!['title'];
                            String reason = formData['reason'];
                            String content = formData['content'];

                            if (imagenToUpload != null) {
                              upload = await uploadImage(imagenToUpload!, infoUser["documentID"]);
                              imageURL = upload['url'];
                            } else if (webFile != null) {
                              imageURL = await uploadWebFile(webFile!, infoUser["documentID"]);
                            }

                            if (imageURL != null) {
                              DateTime now = DateTime.now();
                              await addAppointment(reason, content, title, now, infoUser["name"], imageURL!);

                              setState(() {
                                _settingCards.add(NoticeCard(
                                  title: title,
                                  reason: reason,
                                  content: content,
                                  url: imageURL!,
                                  formattedDate: DateFormat('hh:mm a').format(now),
                                  name: infoUser["name"],
                                ));
                              });

                              _formKey.currentState?.reset();
                              setState(() {
                                imagenToUpload = null;
                                webFile = null;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Anuncio publicado con éxito')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Error al subir la imagen')),
                              );
                            }
                          }
                        },
                        child: Text('Publicar anuncio'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          SizedBox(height: 32),
          Text(
            'Anuncios publicados',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          StreamBuilder(
            
            stream: FirebaseFirestore.instance
                .collection('appointment')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No hay Anuncios disponibles'));
              }

              return ListView(
                padding: EdgeInsets.all(8),
                scrollDirection: Axis.vertical,
                reverse: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  Timestamp timestamp = data['time'];
                  DateTime dateTime = timestamp.toDate();
                  String formattedDate = DateFormat('dd-MM-yy-   hh:mm a').format(dateTime);
                  return NoticeCard(
                    title: data['title'] ?? 'Sin título',
                    reason: data['reason'] ?? 'Sin motivo',
                    content: data['content'] ?? 'Sin contenido',
                    formattedDate: formattedDate,
                    name: data['name'] ?? 'No registra',
                    url: data['url'],
                  );
                }).toList(),
              );
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
