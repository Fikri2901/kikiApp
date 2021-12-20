import 'package:flutter/material.dart';
import 'package:kikiapp/database/database.dart';
import 'package:kikiapp/models/bayar.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

// ignore: must_be_immutable
class AddBayarPage extends StatefulWidget {
  @override
  _AddBayarPageState createState() => _AddBayarPageState();
}

class _AddBayarPageState extends State<AddBayarPage> {
  TextEditingController namaController = TextEditingController();
  TextEditingController nomorController = TextEditingController();
  // ignore: unused_field
  bool _validasi = false;

  @override
  void dispose() {
    super.dispose();
    namaController.dispose();
    nomorController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Bayar bayar = ModalRoute.of(context).settings.arguments;
    var widgetText = 'Tambah Data Bayar Listrik';
    if (bayar != null) {
      namaController.text = bayar.nama;
      nomorController.text = bayar.nomor;
      widgetText = 'Update ${bayar.nama}';
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
                      validator: validatorNomor,
                      controller: nomorController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Nomor Pembayaran Listrik',
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
                      if (bayar != null) {
                        setState(() {
                          if (namaController.text.isEmpty ||
                              nomorController.text.isEmpty) {
                            _validasi = true;
                          } else {
                            updateBayar(bayar);
                          }
                        });
                      } else {
                        setState(() {
                          if (namaController.text.isEmpty ||
                              nomorController.text.isEmpty) {
                            _validasi = true;
                          } else {
                            insertBayar();
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

  String validatorNama(String value) {
    if (value.length < 1)
      return 'Nama tidak boleh kosong !';
    else
      return null;
  }

  String validatorNomor(String value) {
    if (value.length < 1)
      return 'Nomor Token Listrik tidak boleh kosong !';
    else
      return null;
  }

  insertBayar() async {
    final bayar = Bayar(
      id: M.ObjectId(),
      nama: namaController.text,
      nomor: nomorController.text,
      tanggal_upload: DateTime.now().toString(),
      tanggal_update: DateTime.now().toString(),
    );
    await MongoDatabase.insertBayar(bayar);
    Navigator.pop(this.context);

    ScaffoldMessenger.of(this.context).showSnackBar(
      SnackBar(
        content: Text('${namaController.text} Berhasil di Tambahkan !!'),
      ),
    );
  }

  updateBayar(Bayar bayar) async {
    final b = Bayar(
      id: bayar.id,
      nama: namaController.text,
      nomor: nomorController.text,
    );
    await MongoDatabase.updateBayar(b);
    Navigator.pop(this.context);

    ScaffoldMessenger.of(this.context).showSnackBar(
      SnackBar(
        content: Text('${bayar.nama} Berhasil di update !!'),
      ),
    );
  }
}
