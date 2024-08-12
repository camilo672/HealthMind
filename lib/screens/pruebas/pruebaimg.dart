import 'dart:io'; // Para móviles
import 'package:flutter/foundation.dart'; // Para web
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:phsycho/services/bdStore.dart';
import 'package:phsycho/screens/login/login.dart';
import 'package:phsycho/components/item/color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? imagenToUpload; // Para móviles
  PlatformFile? webFile;  // Para web

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Imágenes en Flutter"),
      ),
      body: Column(
        children: [
          if (imagenToUpload != null)
            Image.file(imagenToUpload!) // Muestra la imagen para móviles
          else if (webFile != null)
            Image.memory(webFile!.bytes!) // Muestra la imagen para web
          else
            Container(
              height: 200,
              width: double.infinity,
              color: primaryColor,
              margin: const EdgeInsets.all(20),
            ),
          ElevatedButton(
            onPressed: () async {
              if (kIsWeb) {
                // Selección de archivo para web
                final result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  setState(() {
                    webFile = result.files.first;
                  });
                }
              } else {
                // Selección de archivo para móviles
                final result = await FilePicker.platform.pickFiles(type: FileType.image);
                if (result != null) {
                  setState(() {
                    imagenToUpload = File(result.files.single.path!);
                  });
                }
              }
            },
            child: const Text("Seleccionar Imagen"),
          ),
          ElevatedButton(
            onPressed: () async {
             
            },
            child: const Text("Subir Imagen"),
          ),
        ],
      ),
    );
  }


}