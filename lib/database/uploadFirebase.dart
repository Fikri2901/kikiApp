import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class UploadImageFirebaseAPI {
  static UploadTask uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
      // ignore: unused_catch_clause
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putData(data);
      // ignore: unused_catch_clause
    } on FirebaseException catch (e) {
      return null;
    }
  }
}
