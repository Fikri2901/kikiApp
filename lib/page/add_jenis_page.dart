import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kikiapp/database/database.dart';
import 'package:kikiapp/database/uploadFirebase.dart';
import 'package:kikiapp/models/jenis.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:path/path.dart';

class AddJenisPage extends StatefulWidget {
  @override
  _AddJenisPageState createState() => _AddJenisPageState();
}

class _AddJenisPageState extends State<AddJenisPage> {
  TextEditingController namaController = TextEditingController();
  // ignore: unused_field
  bool _validasi = false;

  @override
  void dispose() {
    super.dispose();
    namaController.dispose();
  }

  // ignore: avoid_init_to_null
  String namaGambar = null;
  File file;
  UploadTask task;

  Future selectfile() async {
    final ambil = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (ambil == null) return;
    final path = ambil.files.single.path;
    setState(() {
      file = File(path);
    });
  }

  Widget buildUploadStatus(UploadTask task) {
    StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final snap = snapshot.data;
          final progress = snap.bytesTransferred / snap.totalBytes;
          final persen = (progress * 100).toStringAsFixed(2);
          return Text(
            '$persen',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filename =
        file != null ? basename(file.path) : 'file upload belum ada';

    final Jenis jenis = ModalRoute.of(context).settings.arguments;
    var widgetText = 'Tambah Jenis';
    if (jenis != null) {
      namaController.text = jenis.nama;
      namaGambar = jenis.gambar;
      widgetText = 'Update jenis';
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
              // ignore: deprecated_member_use
              autovalidate: true,
              child: Column(
                children: [
                  namaGambar != null
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              // ignore: deprecated_member_use
                              child: Image.network(
                                jenis.gambar,
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
                    padding: const EdgeInsets.all(20.0),
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
                  // task != null ? buildUploadStatus(task) : Container(),
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
                      if (jenis != null) {
                        setState(() {
                          namaController.text.isEmpty
                              ? _validasi = true
                              : _validasi = updateJenis(jenis);
                        });
                      } else {
                        setState(() {
                          namaController.text.isEmpty
                              ? _validasi = true
                              : _validasi = insertJenis();
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

  insertJenis() async {
    if (file == null) {
      return;
    }

    final fileName = basename(file.path);
    final destination = 'jenis/$fileName';

    task = UploadImageFirebaseAPI.uploadFile(destination, file);
    setState(() {});
    if (task == null) return;
    final snapshoot = await task.whenComplete(() {});
    final urlDownload = await snapshoot.ref.getDownloadURL();
    print(urlDownload);

    final jenis = Jenis(
        id: M.ObjectId(),
        gambar: urlDownload,
        nama: namaController.text,
        tanggal_upload: DateTime.now().toString(),
        tanggal_update: DateTime.now().toString());
    await MongoDatabase.insertJenis(jenis);
    Navigator.pop(this.context);

    ScaffoldMessenger.of(this.context).showSnackBar(
      SnackBar(
        content: Text('${namaController.text} Berhasil ditambahkan !!'),
      ),
    );
  }

  updateJenis(Jenis jenis) async {
    if (file == null) {
      final j = Jenis(
        id: jenis.id,
        gambar: jenis.gambar,
        nama: namaController.text,
      );
      await MongoDatabase.updateJenis(j);
      Navigator.pop(this.context);

      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          content: Text('${jenis.nama} Berhasil di update !!'),
        ),
      );
    }

    final fileName = basename(file.path);

    if (fileName != null) {
      FirebaseStorage.instance.refFromURL(jenis.gambar).delete();

      final destination = 'jenis/$fileName';

      task = UploadImageFirebaseAPI.uploadFile(destination, file);
      setState(() {});
      if (task == null) return;
      final snapshoot = await task.whenComplete(() {});
      final urlDownload = await snapshoot.ref.getDownloadURL();

      final j = Jenis(
        id: jenis.id,
        gambar: urlDownload,
        nama: namaController.text,
      );
      await MongoDatabase.updateJenis(j);
      Navigator.pop(this.context);

      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          content: Text('${jenis.nama} Berhasil di update !!'),
        ),
      );
    }
  }
}
