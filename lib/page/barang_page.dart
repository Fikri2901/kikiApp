import 'package:flutter/material.dart';
import 'package:kikiapp/models/barang.dart';
import 'package:kikiapp/component/barang_card.dart';
import 'package:kikiapp/database/database.dart';
import 'package:kikiapp/models/jenis.dart';
import 'package:kikiapp/page/home_page.dart';
// ignore: unused_import
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:shared_preferences/shared_preferences.dart';

import 'add_barang_page.dart';

class BarangPage extends StatefulWidget {
  BarangPage({Key key}) : super(key: key);

  @override
  _BarangPageState createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  TextEditingController cariController = new TextEditingController();
  String _admin = "";
  String searchString = "";
  @override
  void initState() {
    super.initState();
    _panggilAdmin();
  }

  @override
  Widget build(BuildContext context) {
    final Jenis jenis = ModalRoute.of(context).settings.arguments;
    return FutureBuilder(
        future: MongoDatabase.getDocumentBarangById(jenis),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: new PreferredSize(
                child: new Hero(
                  tag: AppBar,
                  child: new AppBar(
                    title: Text(jenis.nama),
                  ),
                ),
                preferredSize: new AppBar().preferredSize,
              ),
              body: Column(
                children: <Widget>[
                  new Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Hero(
                        tag: 'cari',
                        child: new Card(
                          child: new ListTile(
                            leading: new Icon(Icons.search),
                            title: new TextField(
                              controller: cariController,
                              decoration: new InputDecoration(
                                  hintText: 'Cari ${jenis.nama}',
                                  border: InputBorder.none),
                              onChanged: (value) {
                                setState(() {
                                  searchString = value;
                                });
                              },
                            ),
                            trailing: new IconButton(
                              icon: new Icon(Icons.cancel),
                              onPressed: () {
                                // cari.clear();
                                cariController.clear();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 300.0,
                    color: Colors.white,
                    child: Center(
                      child: const CircularProgressIndicator(
                        backgroundColor: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: _admin == 'kikicell'
                  ? FloatingActionButton(
                      heroTag: 'btnTambah',
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
                    )
                  : null,
            );
          } else {
            if (snapshot.hasError) {
              return Scaffold(
                appBar: new PreferredSize(
                  child: new Hero(
                    tag: AppBar,
                    child: new AppBar(
                      title: Text(jenis.nama),
                    ),
                  ),
                  preferredSize: new AppBar().preferredSize,
                ),
                body: RefreshIndicator(
                  onRefresh: refreshBarang,
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        'ada kesalahan, coba lagi',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                ),
              );
            } else if (snapshot.data.length < 1) {
              return Scaffold(
                appBar: new PreferredSize(
                  child: new Hero(
                    tag: AppBar,
                    child: new AppBar(
                      title: Text(jenis.nama),
                    ),
                  ),
                  preferredSize: new AppBar().preferredSize,
                ),
                body: RefreshIndicator(
                  onRefresh: refreshBarang,
                  child: Container(
                    color: Colors.white12,
                    child: Center(
                      child: Text(
                        'Tidak ada Data ${jenis.nama}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                ),
                floatingActionButton: _admin == 'kikicell'
                    ? FloatingActionButton(
                        heroTag: 'btnTambah',
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return AddBarangPage(
                                nama: jenis.nama, idJenis: jenis.id.toJson());
                          })).then((value) => setState(() {}));
                        },
                        child: Icon(Icons.add),
                      )
                    : null,
              );
            } else {
              return Scaffold(
                appBar: new PreferredSize(
                  child: new Hero(
                    tag: AppBar,
                    child: new AppBar(
                      title: Text(jenis.nama),
                    ),
                  ),
                  preferredSize: new AppBar().preferredSize,
                ),
                body: Column(
                  children: <Widget>[
                    new Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Hero(
                          tag: 'cari',
                          child: new Card(
                            elevation: 6,
                            child: new ListTile(
                              leading: new Icon(Icons.search),
                              title: new TextField(
                                controller: cariController,
                                decoration: new InputDecoration(
                                    hintText: 'Cari ${jenis.nama}',
                                    border: InputBorder.none),
                                onChanged: (value) {
                                  setState(() {
                                    searchString = value;
                                  });
                                },
                              ),
                              trailing: new IconButton(
                                icon: new Icon(Icons.cancel),
                                onPressed: () {
                                  cariController.clear();
                                  setState(() {
                                    searchString = "";
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    new Expanded(
                      child: RefreshIndicator(
                        onRefresh: refreshBarang,
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return snapshot.data[index]['nama']
                                    .toString()
                                    .toLowerCase()
                                    .contains(searchString)
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _admin == 'kikicell'
                                        ? Hero(
                                            tag: 'list',
                                            child: BarangCard(
                                              barang: Barang.fromMap(
                                                  snapshot.data[index]),
                                              txtAdmin: _admin,
                                              onLongDelete: () {
                                                showAlertHapus(Barang.fromMap(
                                                    snapshot.data[index]));
                                              },
                                              onTapEdit: () async {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      return AddBarangPage(
                                                          nama: jenis.nama,
                                                          idJenis: jenis.id
                                                              .toJson());
                                                    },
                                                    settings: RouteSettings(
                                                      arguments: Barang.fromMap(
                                                          snapshot.data[index]),
                                                    ),
                                                  ),
                                                ).then(
                                                    (value) => setState(() {}));
                                              },
                                              onPress: () {
                                                showDetail(Barang.fromMap(
                                                    snapshot.data[index]));
                                              },
                                            ),
                                          )
                                        : Hero(
                                            tag: 'detailBarang',
                                            child: BarangCard(
                                              barang: Barang.fromMap(
                                                  snapshot.data[index]),
                                              txtAdmin: _admin,
                                              onPress: () {
                                                showDetail(Barang.fromMap(
                                                    snapshot.data[index]));
                                              },
                                            ),
                                          ),
                                  )
                                : Container();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                floatingActionButton: _admin == 'kikicell'
                    ? FloatingActionButton(
                        heroTag: 'btnTambah',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return AddBarangPage(
                                    nama: jenis.nama,
                                    idJenis: jenis.id.toJson());
                              },
                            ),
                          ).then((value) => setState(() {}));
                        },
                        child: Icon(Icons.add),
                      )
                    : null,
              );
            }
          }
        });
  }

  Future refreshBarang() async {
    final Jenis jenis = ModalRoute.of(context).settings.arguments;
    await MongoDatabase.getDocumentBarangById(jenis);
    setState(() {});
  }

  void _panggilAdmin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      if (pref.getString('admin') != null) {
        _admin = pref.getString('admin');
      }
    });
  }

  showDetail(Barang barang) {
    Widget cancelButton = TextButton(
      child: Text("Kembali"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Detail ${barang.nama}"),
      content: Container(
        height: 100.0,
        child: Column(
          children: [
            Text(
              "Harga Ecer : ${barang.harga_ecer}",
              textAlign: TextAlign.left,
            ),
            Text(
              "Harga Grosir : ${barang.harga_grosir}",
              textAlign: TextAlign.left,
            ),
            Text(
              "Update : ${barang.tanggal_update}",
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
      actions: [
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Hero(
          tag: 'detailBarang',
          child: alert,
        );
      },
    );
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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${barang.nama} Sudah terhapus !!'),
          ),
        );
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
