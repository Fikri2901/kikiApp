import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kikiapp/database/database.dart';
import 'package:kikiapp/database/uploadFirebase.dart';
import 'package:kikiapp/models/barang.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:intl/intl.dart';
import 'package:path/path.dart';

// ignore: must_be_immutable
class AddBarangPage extends StatefulWidget {
  final String nama;
  final String idJenis;
  const AddBarangPage({this.nama, this.idJenis});

  @override
  _AddBarangPageState createState() => _AddBarangPageState();
}

class _AddBarangPageState extends State<AddBarangPage> {
  TextEditingController namaController = TextEditingController();
  TextEditingController grosirController = TextEditingController();
  TextEditingController ecerController = TextEditingController();
  TextEditingController idJenisController = TextEditingController();
  // ignore: unused_field
  bool _validasi = false;

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern('id').format(int.parse(s));
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: 'id').currencySymbol;

  File file;
  UploadTask task;
  // ignore: avoid_init_to_null
  String namaGambar = null;

  Future selectfile() async {
    final ambil = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (ambil == null) return;
    final pat = ambil.files.single.path;
    setState(() {
      file = File(pat);
    });
  }

  @override
  void dispose() {
    super.dispose();
    namaController.dispose();
    grosirController.dispose();
    ecerController.dispose();
    idJenisController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filename =
        file != null ? basename(file.path) : 'file upload belum ada';

    final Barang barang = ModalRoute.of(context).settings.arguments;
    var widgetText = 'Tambah ${this.widget.nama}';
    if (barang != null) {
      namaController.text = barang.nama;
      idJenisController.text = barang.id_jenis;
      ecerController.text = barang.harga_ecer;
      grosirController.text = barang.harga_grosir;
      namaGambar = barang.gambar;
      widgetText = 'Update ${barang.nama}';
    }
    return Scaffold(
      appBar: new PreferredSize(
        child: new Hero(
          tag: AppBar,
          child: new AppBar(
            title: Text(widgetText),
          ),
        ),
        preferredSize: new AppBar().preferredSize,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  namaGambar != null
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              // ignore: deprecated_member_use
                              child: CachedNetworkImage(
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
                                  child: CircularProgressIndicator(
                                    value: progress.progress,
                                  ),
                                ),
                                imageUrl: barang.gambar,
                                width: 100.0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0, left: 20.0, right: 20.0),
                              // ignore: deprecated_member_use
                              child: Text(filename),
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20.0, right: 20.0),
                          // ignore: deprecated_member_use
                          child: Text(filename),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      onPressed: selectfile,
                      child: Text('Pilih Gambar'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: TextFormField(
                      validator: validatorNama,
                      controller: namaController,
                      decoration: InputDecoration(
                        labelText: 'Nama',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: TextFormField(
                      validator: validatorEcer,
                      controller: ecerController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Harga Ecer',
                        prefixText: _currency,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                      onChanged: (string) {
                        string = '${_formatNumber(string.replaceAll('.', ''))}';
                        ecerController.value = TextEditingValue(
                          text: string,
                          selection:
                              TextSelection.collapsed(offset: string.length),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: TextFormField(
                      validator: validatorGrosir,
                      controller: grosirController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Harga Grosir',
                        prefixText: _currency,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                      onChanged: (string) {
                        string = '${_formatNumber(string.replaceAll('.', ''))}';
                        grosirController.value = TextEditingValue(
                          text: string,
                          selection:
                              TextSelection.collapsed(offset: string.length),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 50.0,
                width: 160.0,
                child: Hero(
                  tag: 'btnTambah',
                  child: ElevatedButton(
                    child: Text(
                      widgetText,
                      style: TextStyle(fontSize: 18.0),
                    ),
                    onPressed: () {
                      if (barang != null) {
                        setState(() {
                          if (namaController.text.isEmpty ||
                              ecerController.text.isEmpty ||
                              grosirController.text.isEmpty) {
                            _validasi = true;
                          } else if (file != null) {
                            updateBarang(barang);
                            showProgress(task);
                          } else {
                            updateBarang(barang);
                          }
                        });
                      } else {
                        setState(() {
                          if (namaController.text.isEmpty ||
                              ecerController.text.isEmpty ||
                              grosirController.text.isEmpty) {
                            _validasi = true;
                          } else {
                            insertBarang();
                          }

                          showProgress(task);
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  String validatorNama(String value) {
    if (value.length < 1)
      return 'Nama tidak boleh kosong !!!';
    else
      return null;
  }

  String validatorEcer(String value) {
    if (value.length < 1)
      return 'Harga Ecer tidak boleh kosong !!!';
    else
      return null;
  }

  String validatorGrosir(String value) {
    if (value.length < 1)
      return 'Harga Grosir tidak boleh kosong !!!';
    else
      return null;
  }

  insertBarang() async {
    if (file == null) {
      return;
    }

    final fileName = basename(file.path);
    final destination = 'barang/$fileName';

    task = UploadImageFirebaseAPI.uploadFile(destination, file);
    setState(() {});
    if (task == null) return;
    final snapshoot = await task.whenComplete(() {});
    final urlDownload = await snapshoot.ref.getDownloadURL();
    print(urlDownload);

    final barang = Barang(
        id: M.ObjectId(),
        nama: namaController.text,
        id_jenis: this.widget.idJenis,
        gambar: urlDownload,
        harga_grosir: grosirController.text,
        harga_ecer: ecerController.text,
        tanggal_upload: DateTime.now().toString(),
        tanggal_update: DateTime.now().toString());
    await MongoDatabase.insertBarang(barang);
    Navigator.pop(this.context);

    final aTambah = SnackBar(
        content: Text('${namaController.text} Berhasil di Tambahkan !!'));
    ScaffoldMessenger.of(this.context).showSnackBar(aTambah);

    Navigator.pop(this.context);
  }

  updateBarang(Barang barang) async {
    if (file == null) {
      final b = Barang(
        id: barang.id,
        nama: namaController.text,
        gambar: barang.gambar,
        id_jenis: this.widget.idJenis,
        harga_ecer: ecerController.text,
        harga_grosir: grosirController.text,
      );
      await MongoDatabase.updateBarang(b);
      Navigator.pop(this.context);

      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          content: Text('${barang.nama} Berhasil di update !!'),
        ),
      );
    } else {
      final fileName = basename(file.path);

      FirebaseStorage.instance.refFromURL(barang.gambar).delete();
      final destination = 'barang/$fileName';

      task = UploadImageFirebaseAPI.uploadFile(destination, file);
      setState(() {});
      if (task == null) return;
      final snapshoot = await task.whenComplete(() {});
      final urlDownload = await snapshoot.ref.getDownloadURL();
      print(urlDownload);

      final barang2 = Barang(
          id: barang.id,
          nama: namaController.text,
          id_jenis: this.widget.idJenis,
          gambar: urlDownload,
          harga_grosir: grosirController.text,
          harga_ecer: ecerController.text,
          tanggal_upload: DateTime.now().toString(),
          tanggal_update: DateTime.now().toString());
      await MongoDatabase.updateBarang(barang2);
      Navigator.pop(this.context);

      final aTambah = SnackBar(
          content: Text('${namaController.text} Berhasil di Update !!'));
      ScaffoldMessenger.of(this.context).showSnackBar(aTambah);
      Navigator.pop(this.context);
    }
  }

  showProgress(UploadTask task) {
    AlertDialog alert = AlertDialog(
      title: Text("Upload Data .... "),
      content: StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final persen = (progress * 100).toStringAsFixed(2);

            return Text(
              '$persen %',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            );
          } else {
            return Text(
              '0.00 %',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            );
          }
        },
      ),
    );

    showDialog(
      context: this.context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
