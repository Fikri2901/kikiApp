import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kikiapp/login.dart';
import 'package:kikiapp/models/jenis.dart';
import 'package:kikiapp/component/jenis_card.dart';
import 'package:kikiapp/database/database.dart';
import 'package:kikiapp/navbarButtom.dart';
// ignore: unused_import
import 'package:kikiapp/page/add_jenis_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kikiapp/page/barang_page.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _admin = "";
  String searchString = "";
  TextEditingController cariController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _panggilAdmin();
  }

  Widget _tombol() {
    if (_admin == 'kikicell') {
      return IconButton(
        icon: Icon(Icons.lock_open),
        onPressed: () {
          showLogout();
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.lock),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return LoginPage();
              },
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: MongoDatabase.getDocumentJenis(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: new PreferredSize(
                child: new Hero(
                  tag: AppBar,
                  child: new AppBar(
                    title: Text('Barang'),
                    centerTitle: true,
                    actions: [_tombol()],
                  ),
                ),
                preferredSize: new AppBar().preferredSize,
              ),
              body: Column(
                children: <Widget>[
                  new Container(
                    // color: Theme.of(context).primaryColor,
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
                                  hintText: 'Cari jenis',
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return AddJenisPage();
                        })).then((value) => setState(() {}));
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
                      title: Text('Barang'),
                      centerTitle: true,
                      actions: [_tombol()],
                    ),
                  ),
                  preferredSize: new AppBar().preferredSize,
                ),
                body: RefreshIndicator(
                  onRefresh: refreshJenis,
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
                      title: Text('Barang'),
                      centerTitle: true,
                      actions: [_tombol()],
                    ),
                  ),
                  preferredSize: new AppBar().preferredSize,
                ),
                body: RefreshIndicator(
                  onRefresh: refreshJenis,
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        'Tidak ada Data',
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
                            return AddJenisPage();
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
                      title: Text('Barang'),
                      centerTitle: true,
                      actions: [_tombol()],
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
                                    hintText: 'Cari jenis',
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
                        onRefresh: refreshJenis,
                        child: new ListView.builder(
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
                                            child: JenisCard(
                                              jenis: Jenis.fromMap(
                                                  snapshot.data[index]),
                                              txtAdmin: _admin,
                                              onLongDelete: () {
                                                showAlertHapus(Jenis.fromMap(
                                                    snapshot.data[index]));
                                              },
                                              onTapEdit: () async {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      return AddJenisPage();
                                                    },
                                                    settings: RouteSettings(
                                                      arguments: Jenis.fromMap(
                                                          snapshot.data[index]),
                                                    ),
                                                  ),
                                                ).then(
                                                    (value) => setState(() {}));
                                              },
                                              onTapListBarang: () async {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      return BarangPage();
                                                    },
                                                    settings: RouteSettings(
                                                      arguments: Jenis.fromMap(
                                                          snapshot.data[index]),
                                                    ),
                                                  ),
                                                ).then(
                                                    (value) => setState(() {}));
                                              },
                                            ),
                                          )
                                        : Hero(
                                            tag: 'list',
                                            child: JenisCard(
                                              jenis: Jenis.fromMap(
                                                  snapshot.data[index]),
                                              onTapListBarang: () async {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      return BarangPage();
                                                    },
                                                    settings: RouteSettings(
                                                      arguments: Jenis.fromMap(
                                                          snapshot.data[index]),
                                                    ),
                                                  ),
                                                ).then(
                                                    (value) => setState(() {}));
                                              },
                                            ),
                                          ),
                                  )
                                : Container();
                          },
                        ),
                      ),
                    )
                  ],
                ),
                floatingActionButton: _admin == 'kikicell'
                    ? FloatingActionButton(
                        heroTag: 'btnTambah',
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return AddJenisPage();
                          })).then((value) => setState(() {}));
                        },
                        child: Icon(Icons.add),
                      )
                    : null,
              );
            }
          }
        });
  }

  Future refreshJenis() async {
    await MongoDatabase.getDocumentJenis();
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

  showLogout() {
    Widget cancelButton = TextButton(
      child: Text("Kembali"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Oke"),
      onPressed: () async {
        SharedPreferences pref = await SharedPreferences.getInstance();

        setState(() {
          pref.clear();
        });
        // Navigator.pop(context);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return NavbarButtom();
          },
        ), (route) => false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout Berhasil !!!'),
          ),
        );
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${jenis.nama} Sudah terhapus !!'),
          ),
        );
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
