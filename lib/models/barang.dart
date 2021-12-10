import 'package:mongo_dart/mongo_dart.dart';

class Barang {
  final ObjectId id;
  final String nama;
  // ignore: non_constant_identifier_names
  final String id_jenis;
  // ignore: non_constant_identifier_names
  final String harga_grosir;
  // ignore: non_constant_identifier_names
  final String harga_ecer;
  // ignore: non_constant_identifier_names
  final String tanggal_upload;
  // ignore: non_constant_identifier_names
  final String tanggal_update;

  // ignore: non_constant_identifier_names
  const Barang(
      {this.id,
      // ignore: non_constant_identifier_names
      this.id_jenis,
      this.nama,
      // ignore: non_constant_identifier_names
      this.harga_ecer,
      // ignore: non_constant_identifier_names
      this.harga_grosir,
      // ignore: non_constant_identifier_names
      this.tanggal_upload,
      // ignore: non_constant_identifier_names
      this.tanggal_update});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'nama': nama,
      'id_jenis': id_jenis,
      'harga_grosir': harga_grosir,
      'harga_ecer': harga_ecer,
      'tanggal_upload': tanggal_upload,
      'tanggal_update': tanggal_update
    };
  }

  Barang.fromMap(Map<String, dynamic> map)
      : nama = map['nama'],
        id = map['_id'],
        id_jenis = map['id_jenis'],
        harga_ecer = map['harga_ecer'],
        harga_grosir = map['harga_grosir'],
        tanggal_upload = map['tanggal_upload'],
        tanggal_update = map['tanggal_update'];
}
