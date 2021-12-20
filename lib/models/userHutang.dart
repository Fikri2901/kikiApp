// ignore_for_file: non_constant_identifier_names

import 'package:mongo_dart/mongo_dart.dart';

class UserHutang {
  final ObjectId id;
  final String nama;
  final String tanggal_upload;
  final String tanggal_update;

  const UserHutang(
      {this.id, this.nama, this.tanggal_upload, this.tanggal_update});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'nama': nama,
      'tanggal_upload': tanggal_upload,
      'tanggal_update': tanggal_update
    };
  }

  UserHutang.fromMap(Map<String, dynamic> map)
      : nama = map['nama'],
        id = map['_id'],
        tanggal_upload = map['tanggal_upload'],
        tanggal_update = map['tanggal_update'];
}
