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
  List<Jenis> _searchResult = [];
  List<Jenis> _jenis = [];
  String _admin = "";

  TextEditingController cari = new TextEditingController();

  Future<Null> getJenis() async {
    final response = await MongoDatabase.getDocumentJenis();
    setState(() {
      for (Map jenis in response) {
        _jenis.add(Jenis.fromMap(jenis));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getJenis();
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

  Widget _jenisResult() {
    return new ListView.builder(
      itemCount: _searchResult.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: _admin == 'kikicell'
              ? JenisCard(
                  jenis: Jenis.fromMap(_searchResult[index].toMap()),
                  txtAdmin: _admin,
                  onLongDelete: () {
                    showAlertHapus(Jenis.fromMap(_searchResult[index].toMap()));
                  },
                  onTapEdit: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return AddJenisPage();
                        },
                        settings: RouteSettings(
                          arguments:
                              Jenis.fromMap(_searchResult[index].toMap()),
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
                          arguments:
                              Jenis.fromMap(_searchResult[index].toMap()),
                        ),
                      ),
                    ).then((value) => setState(() {}));
                  },
                )
              : JenisCard(
                  jenis: Jenis.fromMap(_searchResult[index].toMap()),
                  onTapListBarang: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return BarangPage();
                        },
                        settings: RouteSettings(
                          arguments:
                              Jenis.fromMap(_searchResult[index].toMap()),
                        ),
                      ),
                    ).then((value) => setState(() {}));
                  },
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: MongoDatabase.getDocumentJenis(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Barang'),
                  centerTitle: true,
                  actions: <Widget>[_tombol()],
                ),
                body: Column(
                  children: <Widget>[
                    new Container(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Card(
                          child: new ListTile(
                            leading: new Icon(Icons.search),
                            title: new TextField(
                              controller: cari,
                              decoration: new InputDecoration(
                                  hintText: 'Search', border: InputBorder.none),
                              onChanged: onSearchJenis,
                            ),
                            trailing: new IconButton(
                              icon: new Icon(Icons.cancel),
                              onPressed: () {
                                cari.clear();
                                onSearchJenis('');
                              },
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
                ));
          } else {
            if (snapshot.hasError) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Barang'),
                  centerTitle: true,
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
                appBar: AppBar(
                  title: Text('Barang'),
                  centerTitle: true,
                  actions: <Widget>[_tombol()],
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
                appBar: AppBar(
                  title: Text('Barang'),
                  centerTitle: true,
                  actions: <Widget>[_tombol()],
                ),
                body: Column(
                  children: <Widget>[
                    new Container(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Card(
                          child: new ListTile(
                            leading: new Icon(Icons.search),
                            title: new TextField(
                              controller: cari,
                              decoration: new InputDecoration(
                                  hintText: 'Cari jenis',
                                  border: InputBorder.none),
                              onChanged: onSearchJenis,
                            ),
                            trailing: new IconButton(
                              icon: new Icon(Icons.cancel),
                              onPressed: () {
                                cari.clear();
                                onSearchJenis('');
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    new Expanded(
                      child: _searchResult.length != 0 || cari.text.isNotEmpty
                          ? _jenisResult()
                          : RefreshIndicator(
                              onRefresh: refreshJenis,
                              child: new ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _admin == 'kikicell'
                                        ? JenisCard(
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
                                          )
                                        : JenisCard(
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
                                  );
                                },
                              ),
                            ),
                    )
                  ],
                ),
                floatingActionButton: _admin == 'kikicell'
                    ? FloatingActionButton(
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

  onSearchJenis(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _jenis.forEach((Jenis jenis) {
      if (jenis.nama.toLowerCase().contains(text)) {
        _searchResult.add(jenis);
      }
    });

    setState(() {});
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
