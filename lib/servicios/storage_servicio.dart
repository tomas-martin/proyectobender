import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageServicio {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Sube una imagen y retorna la URL de descarga
  Future<String?> subirImagen(File imagen, String carpeta) async {
    try {
      final String nombreArchivo = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = _storage.ref().child('$carpeta/$nombreArchivo');

      final UploadTask uploadTask = ref.putFile(imagen);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('❌ Error subiendo imagen: $e');
      return null;
    }
  }

  /// Elimina una imagen por su URL
  Future<bool> eliminarImagen(String imageUrl) async {
    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      return true;
    } catch (e) {
      print('❌ Error eliminando imagen: $e');
      return false;
    }
  }
}