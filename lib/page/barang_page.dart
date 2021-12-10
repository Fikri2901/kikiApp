import 'package:flutter/material.dart';
import 'package:kikiapp/models/barang.dart';
import 'package:kikiapp/component/barang_card.dart';
import 'package:kikiapp/database/database.dart';
import 'package:kikiapp/models/jenis.dart';
// ignore: unused_import
import 'package:mongo_dart/mongo_dart.dart' as M;

import 'add_barang_page.dart';

class BarangPage extends StatefulWidget {
  BarangPage({Key key}) : super(key: key);

  @override
  _BarangPageState createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Jenis jenis = ModalRoute.of(context).settings.arguments;
    return FutureBuilder(
        future: MongoDatabase.getDocumentBarangById(jenis),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: const LinearProgressIndicator(
                backgroundColor: Colors.black,
              ),
            );
          } else {
            if (snapshot.hasError) {
              return Container(
                color: Colors.white,
                child: Center(
                  child: Text(
                    'ada kesalahan, coba lagi',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              );
            } else if (snapshot.data.length < 1) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(jenis.nama),
                ),
                body: Container(
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      'Tidak ada Data ${jenis.nama}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return AddBarangPage(
                          nama: jenis.nama, idJenis: jenis.id.toJson());
                    })).then((value) => setState(() {}));
                  },
                  child: Icon(Icons.add),
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text(jenis.nama),
                ),
                body: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BarangCard(
                        barang: Barang.fromMap(snapshot.data[index]),
                        onLongDelete: () {
                          showAlertHapus(Barang.fromMap(snapshot.data[index]));
                        },
                        onTapEdit: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return AddBarangPage(
                                    nama: jenis.nama,
                                    idJenis: jenis.id.toJson());
                              },
                              settings: RouteSettings(
                                arguments: Barang.fromMap(snapshot.data[index]),
                              ),
                            ),
                          ).then((value) => setState(() {}));
                        },
                      ),
                    );
                  },
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return AddBarangPage(
                              nama: jenis.nama, idJenis: jenis.id.toJson());
                        },
                      ),
                    ).then((value) => setState(() {}));
                  },
                  child: Icon(Icons.add),
                ),
              );
            }
          }
        });
  }

  showAlertHapus(Barang barang) {
    Widget cancelButton = TextButton(
      child: Text("Kembali"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Oke"),
      onPressed: () async {
        await MongoDatabase.deleteBarang(barang);
        setState(() {});
        Navigator.of(context).pop();
        final hapus =
            SnackBar(content: Text('${barang.nama} Sudah terhapus !!'));
        ScaffoldMessenger.of(context).showSnackBar(hapus);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Hapus ${barang.nama}"),
      content: Text("Apakah kamu yakin?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
