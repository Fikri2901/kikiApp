import 'package:flutter/material.dart';
import 'package:kikiapp/database/database.dart';
import 'package:kikiapp/models/jenis.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

class AddJenisPage extends StatefulWidget {
  @override
  _AddJenisPageState createState() => _AddJenisPageState();
}

class _AddJenisPageState extends State<AddJenisPage> {
  TextEditingController namaController = TextEditingController();
  bool _validasi = false;

  @override
  void dispose() {
    super.dispose();
    namaController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Jenis jenis = ModalRoute.of(context).settings.arguments;
    var widgetText = 'Tambah Jenis';
    if (jenis != null) {
      namaController.text = jenis.nama;
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
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Hero(
                      tag: 'list',
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
    final jenis = Jenis(
        id: M.ObjectId(),
        nama: namaController.text,
        tanggal_upload: DateTime.now().toString(),
        tanggal_update: DateTime.now().toString());
    await MongoDatabase.insertJenis(jenis);
    Navigator.pop(context);

    final aTambah = SnackBar(
        content: Text('${namaController.text} Berhasil ditambahkan !!'));
    ScaffoldMessenger.of(context).showSnackBar(aTambah);
  }

  updateJenis(Jenis jenis) async {
    print('updating : ${namaController.text}');
    final j = Jenis(
      id: jenis.id,
      nama: namaController.text,
    );
    await MongoDatabase.updateJenis(j);
    Navigator.pop(context);

    final aUpdate =
        SnackBar(content: Text('${jenis.nama} Berhasil di update !!'));
    ScaffoldMessenger.of(context).showSnackBar(aUpdate);
  }
}
