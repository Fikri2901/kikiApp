import 'package:firebase_storage/firebase_storage.dart';
import 'package:kikiapp/models/token.dart';
import 'package:kikiapp/models/user.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:kikiapp/models/jenis.dart';
import 'package:kikiapp/models/barang.dart';
import '../utils/constants.dart';

class MongoDatabase {
  static var db,
      jenisCollection,
      barangCollection,
      userCollection,
      tokenCollection;

  static connect() async {
    db = await Db.create(URL_KONEK_MONGODB);
    await db.open(secure: true);
    jenisCollection = db.collection(JENIS_COLLECTION);
    barangCollection = db.collection(BARANG_COLLECTION);
    userCollection = db.collection(USER_COLLECTION);
    tokenCollection = db.collection(TOKEN_COLLECTION);
  }

  static Future<List<Map<String, dynamic>>> getDocumentJenis() async {
    try {
      final jenis = await jenisCollection.find().toList();
      return jenis;
    } catch (e) {
      print(e);
      return Future.value(e);
    }
  }

  static insertJenis(Jenis jenis) async {
    await jenisCollection.insertAll([jenis.toMap()]);
  }

  static updateJenis(Jenis jenis) async {
    var u = await jenisCollection.findOne({"_id": jenis.id});
    u["nama"] = jenis.nama;
    u["gambar"] = jenis.gambar;
    u["tanggal_upload"] = u["tanggal_upload"];
    u["tanggal_update"] = DateTime.now().toString();
    await jenisCollection.save(u);
  }

  static deleteJenis(Jenis jenis) async {
    final deleteLink =
        FirebaseStorage.instance.refFromURL(jenis.gambar).delete();
    if (deleteLink != null) {
      await jenisCollection.remove(where.id(jenis.id));
    }
  }
  //==================== Barang ==========================//

  static Future<List<Map<String, dynamic>>> getBarang() async {
    try {
      final barang = await barangCollection.find().toList();
      return barang;
    } catch (e) {
      print(e);
      return Future.value(e);
    }
  }

  static Future<List<Map<String, dynamic>>> getDocumentBarangById(
      Jenis jenis) async {
    try {
      final barang =
          await barangCollection.find({'id_jenis': jenis.id.toJson()}).toList();
      return barang;
    } catch (e) {
      print(e);
      return Future.value(e);
    }
  }

  static Future<List<Map<String, dynamic>>> getBarangById(idJenis) async {
    try {
      final barang =
          await barangCollection.find({'id_jenis': idJenis}).toList();
      return barang;
    } catch (e) {
      print(e);
      return Future.value(e);
    }
  }

  static insertBarang(Barang barang) async {
    await barangCollection.insertAll([barang.toMap()]);
  }

  static updateBarang(Barang barang) async {
    var u = await barangCollection.findOne({"_id": barang.id});
    u["nama"] = barang.nama;
    u["id_jenis"] = barang.id_jenis;
    u["gambar"] = barang.gambar;
    u["harga_ecer"] = barang.harga_ecer;
    u["harga_grosir"] = barang.harga_grosir;
    u["tanggal_upload"] = u["tanggal_upload"];
    u["tanggal_update"] = DateTime.now().toString();
    await barangCollection.save(u);
  }

  static deleteBarang(Barang barang) async {
    final delete = FirebaseStorage.instance.refFromURL(barang.gambar).delete();
    if (delete != null) {
      await barangCollection.remove(where.id(barang.id));
    }
  }

  //================== TOKEN LISTRIK =================//

  static Future<List<Map<String, dynamic>>> getTokenListrik() async {
    try {
      final token = await tokenCollection.find().toList();
      return token;
    } catch (e) {
      print(e);
      return Future.value(e);
    }
  }

  static insertToken(Token token) async {
    await tokenCollection.insertAll([token.toMap()]);
  }

  static updateToken(Token token) async {
    var u = await tokenCollection.findOne({"_id": token.id});
    u["nama"] = token.nama;
    u["nomor"] = token.nomor;
    u["tanggal_upload"] = u["tanggal_upload"];
    u["tanggal_update"] = DateTime.now().toString();
    await tokenCollection.save(u);
  }

  static deleteToken(Token token) async {
    await tokenCollection.remove(where.id(token.id));
  }

  //================== LOGIN ========================//

  static loginAdmin(User user) async {
    final users = await userCollection
        .findOne({"nama": user.nama.toLowerCase(), "password": user.password});
    return users;
  }
}
