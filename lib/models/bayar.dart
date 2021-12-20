import 'package:mongo_dart/mongo_dart.dart';

class Bayar {
  final ObjectId id;
  final String nama;
  final String nomor;
  // ignore: non_constant_identifier_names
  final String tanggal_upload;
  // ignore: non_constant_identifier_names
  final String tanggal_update;

  const Bayar(
      {this.id,
      this.nama,
      this.nomor,
      // ignore: non_constant_identifier_names
      this.tanggal_upload,
      // ignore: non_constant_identifier_names
      this.tanggal_update});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'nama': nama,
      'nomor': nomor,
      'tanggal_upload': tanggal_upload,
      'tanggal_update': tanggal_update
    };
  }

  Bayar.fromMap(Map<String, dynamic> map)
      : nama = map['nama'],
        id = map['_id'],
        nomor = map['nomor'],
        tanggal_upload = map['tanggal_upload'],
        tanggal_update = map['tanggal_update'];
}
