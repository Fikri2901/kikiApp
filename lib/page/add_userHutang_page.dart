import 'package:flutter/material.dart';
import 'package:kikiapp/database/database.dart';
import 'package:kikiapp/models/userHutang.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

// ignore: must_be_immutable
class AddUserHutangPage extends StatefulWidget {
  @override
  _AddUserHutangPageState createState() => _AddUserHutangPageState();
}

class _AddUserHutangPageState extends State<AddUserHutangPage> {
  TextEditingController namaController = TextEditingController();
  // ignore: unused_field
  bool _validasi = false;

  @override
  void dispose() {
    super.dispose();
    namaController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserHutang userH = ModalRoute.of(context).settings.arguments;
    var widgetText = 'Tambah Data User Hutang';
    if (userH != null) {
      namaController.text = userH.nama;
      widgetText = 'Update ${userH.nama}';
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
                      if (userH != null) {
                        setState(() {
                          if (namaController.text.isEmpty) {
                            _validasi = true;
                          } else {
                            updateUserHutang(userH);
                          }
                        });
                      } else {
                        setState(() {
                          if (namaController.text.isEmpty) {
                            _validasi = true;
                          } else {
                            insertUserHutang();
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

  insertUserHutang() async {
    final userH = UserHutang(
      id: M.ObjectId(),
      nama: namaController.text,
      tanggal_upload: DateTime.now().toString(),
      tanggal_update: DateTime.now().toString(),
    );
    await MongoDatabase.insertUserHutang(userH);
    Navigator.pop(this.context);

    ScaffoldMessenger.of(this.context).showSnackBar(
      SnackBar(
        content: Text('${namaController.text} Berhasil di Tambahkan !!'),
      ),
    );
  }

  updateUserHutang(UserHutang userH) async {
    final h = UserHutang(
      id: userH.id,
      nama: namaController.text,
    );
    await MongoDatabase.updateUserHutang(h);
    Navigator.pop(this.context);

    ScaffoldMessenger.of(this.context).showSnackBar(
      SnackBar(
        content: Text('${userH.nama} Berhasil di update !!'),
      ),
    );
  }
}
