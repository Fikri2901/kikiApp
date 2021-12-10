import 'package:mongo_dart/mongo_dart.dart';

class Jenis {
  final ObjectId id;
  final String nama;
  // ignore: non_constant_identifier_names
  final String tanggal_upload;
  // ignore: non_constant_identifier_names
  final String tanggal_update;

  // ignore: non_constant_identifier_names
  const Jenis({this.id, this.nama, this.tanggal_upload, this.tanggal_update});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'nama': nama,
      'tanggal_upload': tanggal_upload,
      'tanggal_update': tanggal_update
    };
  }

  Jenis.fromMap(Map<String, dynamic> map)
      : nama = map['nama'],
        id = map['_id'],
        tanggal_upload = map['tanggal_upload'],
        tanggal_update = map['tanggal_update'];
}
