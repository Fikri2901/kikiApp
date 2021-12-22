// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:kikiapp/component/hutang_card.dart';
import 'package:kikiapp/database/database.dart';
import 'package:kikiapp/models/hutang.dart';
import 'package:kikiapp/models/userHutang.dart';
import 'package:kikiapp/navbarButtom.dart';
import 'package:kikiapp/page/add_hutang_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HutangUserPage extends StatefulWidget {
  final String id_user, nama;
  HutangUserPage({Key key, this.id_user, this.nama}) : super(key: key);

  @override
  _HutangUserPageState createState() => _HutangUserPageState();
}

class _HutangUserPageState extends State<HutangUserPage> {
  String searchString = "";
  TextEditingController cariController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Widget _tombol() {
    return IconButton(
      icon: Icon(Icons.lock_open),
      onPressed: () {
        showLogout();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MongoDatabase.getHutangByid(this.widget.id_user),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: new PreferredSize(
              child: new Hero(
                tag: AppBar,
                child: new AppBar(
                  title: Text('Hutang ' + this.widget.nama),
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
                                hintText: 'Cari', border: InputBorder.none),
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
            floatingActionButton: FloatingActionButton(
              heroTag: 'btnTambah',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return AddHutangPage(
                    namaUser: this.widget.nama,
                    id_user: this.widget.id_user,
                  );
                })).then(
                  (value) => setState(() {}),
                );
              },
              child: Icon(Icons.add),
            ),
          );
        } else {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: new PreferredSize(
                child: new Hero(
                  tag: AppBar,
                  child: new AppBar(
                    title: Text('Hutang ' + this.widget.nama),
                  ),
                ),
                preferredSize: new AppBar().preferredSize,
              ),
              body: RefreshIndicator(
                onRefresh: refreshToken,
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
                    title: Text('Hutang ' + this.widget.nama),
                  ),
                ),
                preferredSize: new AppBar().preferredSize,
              ),
              body: RefreshIndicator(
                onRefresh: refreshToken,
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      'Tidak ada Hutang',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                heroTag: 'btnTambah',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return AddHutangPage(
                      namaUser: this.widget.nama,
                      id_user: this.widget.id_user,
                    );
                  })).then(
                    (value) => setState(() {}),
                  );
                },
                child: Icon(Icons.add),
              ),
            );
          } else {
            return Scaffold(
              appBar: new PreferredSize(
                child: new Hero(
                  tag: AppBar,
                  child: new AppBar(
                    title: Text('Hutang ' + this.widget.nama),
                    elevation: 0.0,
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
                                  hintText: 'Cari', border: InputBorder.none),
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
                      onRefresh: refreshToken,
                      child: new ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return snapshot.data[index]['harga']
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchString)
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: HutangCard(
                                    hutang:
                                        Hutang.fromMap(snapshot.data[index]),
                                    onLongDelete: () {
                                      showAlertHapus(
                                        Hutang.fromMap(snapshot.data[index]),
                                      );
                                    },
                                    onTapEdit: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return AddHutangPage(
                                              namaUser: this.widget.nama,
                                              id_user: this.widget.id_user,
                                            );
                                          },
                                          settings: RouteSettings(
                                            arguments: Hutang.fromMap(
                                                snapshot.data[index]),
                                          ),
                                        ),
                                      ).then((value) => setState(() {}));
                                    },
                                  ),
                                )
                              : Container();
                        },
                      ),
                    ),
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton(
                heroTag: 'btnTambah',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return AddHutangPage(
                      namaUser: this.widget.nama,
                      id_user: this.widget.id_user,
                    );
                  })).then((value) => setState(() {}));
                },
                child: Icon(Icons.add),
              ),
            );
          }
        }
      },
    );
  }

  Future refreshToken() async {
    await MongoDatabase.getHutangByid(this.widget.id_user);
    setState(() {});
  }

  showDetail(Hutang hutang) {
    final UserHutang userH = ModalRoute.of(context).settings.arguments;

    Widget cancelButton = TextButton(
      child: Text("Kembali"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Hutang ${userH.nama}"),
      content: Container(
        height: 100.0,
        child: Column(
          children: [
            Text(
              "Jumlah : ${hutang.harga}",
              textAlign: TextAlign.left,
            ),
            Text(
              "Deskripsi : ${hutang.deskripsi}",
              textAlign: TextAlign.left,
            ),
            Text(
              "Update : ${hutang.tanggal_update}",
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
        return alert;
      },
    );
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

  showAlertHapus(Hutang hutang) {
    Widget cancelButton = TextButton(
      child: Text("Kembali"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Oke"),
      onPressed: () async {
        await MongoDatabase.deleteHutang(hutang);
        setState(() {});

        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${hutang.harga} Sudah terhapus !!'),
          ),
        );
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Hapus ${hutang.harga}"),
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
