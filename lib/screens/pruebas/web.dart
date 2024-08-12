import 'dart:html' as html;
import 'package:firebase_storage/firebase_storage.dart';

Future<bool> uploadImageWeb(html.File image) async {
  try {
    final reader = html.FileReader();
    reader.readAsDataUrl(image);
    await reader.onLoad.first;
    final String base64Image = (reader.result as String).split(",").last;

    final Reference ref = FirebaseStorage.instance.ref().child("images").child(image.name);
    final UploadTask uploadTask = ref.putString(base64Image, format: PutStringFormat.base64);

    final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
    final String url = await snapshot.ref.getDownloadURL();
    print(url);

    return true;
  } catch (e) {
    print('Error al subir la imagen en web: $e');
    return false;
  }
}
