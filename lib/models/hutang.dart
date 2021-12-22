// ignore_for_file: non_constant_identifier_names

import 'package:mongo_dart/mongo_dart.dart';

class Hutang {
  final ObjectId id;
  final String harga;
  final String id_user;
  final String deskripsi;
  final String tanggal_upload;
  final String tanggal_update;

  const Hutang(
      {this.id,
      this.id_user,
      this.deskripsi,
      this.harga,
      this.tanggal_upload,
      this.tanggal_update});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'harga': harga,
      'id_user': id_user,
      'deskripsi': deskripsi,
      'tanggal_upload': tanggal_upload,
      'tanggal_update': tanggal_update
    };
  }

  Hutang.fromMap(Map<String, dynamic> map)
      : harga = map['harga'],
        id = map['_id'],
        id_user = map['id_user'],
        deskripsi = map['deskripsi'],
        tanggal_upload = map['tanggal_upload'],
        tanggal_update = map['tanggal_update'];
}
