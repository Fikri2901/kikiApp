// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:kikiapp/database/database.dart';
import 'package:kikiapp/models/hutang.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

class AddHutangPage extends StatefulWidget {
  final String namaUser;
  final String id_user;

  const AddHutangPage({this.namaUser, this.id_user});

  @override
  _AddHutangPageState createState() => _AddHutangPageState();
}

class _AddHutangPageState extends State<AddHutangPage> {
  TextEditingController jumlahController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  // ignore: unused_field
  bool _validasi = false;

  @override
  void dispose() {
    super.dispose();
    jumlahController.dispose();
    deskripsiController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Hutang hutang = ModalRoute.of(context).settings.arguments;
    var widgetText = 'Tambah Hutang ' + this.widget.namaUser;
    if (hutang != null) {
      jumlahController.text = hutang.harga;
      deskripsiController.text = hutang.deskripsi;
      widgetText = 'Update Hutang ${this.widget.namaUser}';
    } else {
      deskripsiController.text = "-";
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
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: TextFormField(
                      validator: validatorJumlah,
                      controller: jumlahController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Jumlah',
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
                      validator: validatorDeskripsi,
                      controller: deskripsiController,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
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
                      if (hutang != null) {
                        setState(() {
                          if (jumlahController.text.isEmpty ||
                              deskripsiController.text.isEmpty) {
                            _validasi = true;
                          } else {
                            updateHutang(hutang);
                          }
                        });
                      } else {
                        setState(() {
                          if (jumlahController.text.isEmpty ||
                              deskripsiController.text.isEmpty) {
                            _validasi = true;
                          } else {
                            insertHutang();
                          }
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

  String validatorJumlah(String value) {
    if (value.length < 1)
      return 'Jumlah tidak boleh kosong !!';
    else
      return null;
  }

  String validatorDeskripsi(String value) {
    if (value.length < 1)
      return 'Deskripsi tidak boleh kosong !';
    else
      return null;
  }

  insertHutang() async {
    final hutang = Hutang(
      id: M.ObjectId(),
      harga: jumlahController.text,
      id_user: this.widget.id_user,
      deskripsi: deskripsiController.text,
      tanggal_upload: DateTime.now().toString(),
      tanggal_update: DateTime.now().toString(),
    );
    await MongoDatabase.insertHutang(hutang);
    Navigator.pop(this.context);

    ScaffoldMessenger.of(this.context).showSnackBar(
      SnackBar(
        content: Text('Rp. ${jumlahController.text} Berhasil di Tambahkan !!'),
      ),
    );
  }

  updateHutang(Hutang hutang) async {
    final h = Hutang(
      id: hutang.id,
      harga: jumlahController.text,
      id_user: this.widget.id_user,
      deskripsi: deskripsiController.text,
    );
    await MongoDatabase.updateHutang(h);
    Navigator.pop(this.context);

    ScaffoldMessenger.of(this.context).showSnackBar(
      SnackBar(
        content: Text('Rp. ${hutang.harga} Berhasil di update !!'),
      ),
    );
  }
}
