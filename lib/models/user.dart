import 'package:mongo_dart/mongo_dart.dart';

class User {
  final ObjectId id;
  final String nama;
  final String password;

  const User({this.id, this.nama, this.password});

  Map<String, dynamic> toMap() {
    return {'_id': id, 'nama': nama, 'password': password};
  }

  User.fromMap(Map<String, dynamic> map)
      : nama = map['nama'],
        id = map['_id'],
        password = map['password'];
}
