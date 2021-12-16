import 'package:mongo_dart/mongo_dart.dart';

class Jenis {
  final ObjectId id;
  final String gambar;
  final String nama;
  // ignore: non_constant_identifier_names
  final String tanggal_upload;
  // ignore: non_constant_identifier_names
  final String tanggal_update;

  const Jenis(
      {this.id,
      this.nama,
      // ignore: non_constant_identifier_names
      this.tanggal_upload,
      // ignore: non_constant_identifier_names
      this.tanggal_update,
      this.gambar});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'gambar': gambar,
      'nama': nama,
      'tanggal_upload': tanggal_upload,
      'tanggal_update': tanggal_update
    };
  }

  Jenis.fromMap(Map<String, dynamic> map)
      : nama = map['nama'],
        gambar = map['gambar'],
        id = map['_id'],
        tanggal_upload = map['tanggal_upload'],
        tanggal_update = map['tanggal_update'];
}
