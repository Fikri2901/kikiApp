import 'package:flutter/material.dart';
import 'package:kikiapp/database/database.dart';
import 'package:kikiapp/models/token.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

// ignore: must_be_immutable
class AddTokenPage extends StatefulWidget {
  @override
  _AddTokenPageState createState() => _AddTokenPageState();
}

class _AddTokenPageState extends State<AddTokenPage> {
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
    final Token token = ModalRoute.of(context).settings.arguments;
    var widgetText = 'Tambah Token Listrik';
    if (token != null) {
      namaController.text = token.nama;
      nomorController.text = token.nomor;
      widgetText = 'Update ${token.nama}';
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
                        labelText: 'Nomor Token',
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
                      if (token != null) {
                        setState(() {
                          if (namaController.text.isEmpty ||
                              nomorController.text.isEmpty) {
                            _validasi = true;
                          } else {
                            updateToken(token);
                          }
                        });
                      } else {
                        setState(() {
                          if (namaController.text.isEmpty ||
                              nomorController.text.isEmpty) {
                            _validasi = true;
                          } else {
                            insertToken();
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

  insertToken() async {
    final token = Token(
      id: M.ObjectId(),
      nama: namaController.text,
      nomor: nomorController.text,
      tanggal_upload: DateTime.now().toString(),
      tanggal_update: DateTime.now().toString(),
    );
    await MongoDatabase.insertToken(token);
    Navigator.pop(this.context);

    final aTambah = SnackBar(
        content: Text('${namaController.text} Berhasil di Tambahkan !!'));
    ScaffoldMessenger.of(this.context).showSnackBar(aTambah);
  }

  updateToken(Token token) async {
    final t = Token(
      id: token.id,
      nama: namaController.text,
      nomor: nomorController.text,
    );
    await MongoDatabase.updateToken(t);
    Navigator.pop(this.context);

    ScaffoldMessenger.of(this.context).showSnackBar(
      SnackBar(
        content: Text('${token.nama} Berhasil di update !!'),
      ),
    );
  }
}
