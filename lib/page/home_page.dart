import 'package:flutter/material.dart';
import 'package:kikiapp/login.dart';
import 'package:kikiapp/models/jenis.dart';
import 'package:kikiapp/component/jenis_card.dart';
import 'package:kikiapp/database/database.dart';
// ignore: unused_import
import 'package:kikiapp/page/add_jenis_page.dart';

import 'package:kikiapp/page/barang_page.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: MongoDatabase.getDocumentJenis(),
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
                  title: Text('Barang'),
                  centerTitle: true,
                ),
                body: Container(
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      'Tidak ada Data',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return AddJenisPage();
                    })).then((value) => setState(() {}));
                  },
                  child: Icon(Icons.add),
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Barang'),
                  centerTitle: true,
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.lock),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return LoginPage();
                          }));
                        })
                  ],
                ),
                body: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: JenisCard(
                        jenis: Jenis.fromMap(snapshot.data[index]),
                        onLongDelete: () {
                          showAlertHapus(Jenis.fromMap(snapshot.data[index]));
                        },
                        onTapEdit: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return AddJenisPage();
                              },
                              settings: RouteSettings(
                                arguments: Jenis.fromMap(snapshot.data[index]),
                              ),
                            ),
                          ).then((value) => setState(() {}));
                        },
                        onTapListBarang: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return BarangPage();
                              },
                              settings: RouteSettings(
                                arguments: Jenis.fromMap(snapshot.data[index]),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return AddJenisPage();
                    })).then((value) => setState(() {}));
                  },
                  child: Icon(Icons.add),
                ),
              );
            }
          }
        });
  }

  // ignore: unused_element
  _deleteJenis(Jenis jenis) async {
    await MongoDatabase.deleteJenis(jenis);
    setState(() {});
  }

  showAlertHapus(Jenis jenis) {
    Widget cancelButton = TextButton(
      child: Text("Kembali"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Oke"),
      onPressed: () async {
        await MongoDatabase.deleteJenis(jenis);
        setState(() {});

        Navigator.of(context).pop();

        final hapus =
            SnackBar(content: Text('${jenis.nama} Sudah terhapus !!'));
        ScaffoldMessenger.of(context).showSnackBar(hapus);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Hapus ${jenis.nama}"),
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
