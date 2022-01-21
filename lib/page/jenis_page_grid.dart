import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:kikiapp/component/jenis_card_grid.dart';
import 'package:kikiapp/database/database.dart';
import 'package:kikiapp/models/jenis.dart';
import 'package:kikiapp/page/barang_page_grid.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class JenisPage extends StatefulWidget {
  JenisPage({Key key}) : super(key: key);

  @override
  _JenisPageState createState() => new _JenisPageState();
}

class _JenisPageState extends State<JenisPage> {
  List<Jenis> _searchResult = [];
  List<Jenis> _jenis = [];
  TextEditingController controller = new TextEditingController();
  EasyRefreshController _refresh;

  bool isLoading = false;

  Future<Null> getJenis() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: 2), () {});
    await MongoDatabase.connect();
    await Firebase.initializeApp();
    final resp = await MongoDatabase.getDocumentJenis();

    setState(() {
      for (Map jenis in resp) {
        _jenis.add(Jenis.fromMap(jenis));
      }

      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh = EasyRefreshController();
    getJenis();
  }

  Widget _shimmerJenis() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(15.0),
        elevation: 5.0,
        color: Colors.white,
        child: Container(
          margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Column(
            children: [
              Shimmer(
                child: Container(
                  padding: EdgeInsets.only(top: 10.0),
                  width: 100.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[400],
                  ),
                ),
                duration: Duration(seconds: 1),
                interval: Duration(seconds: 1),
                color: Colors.white,
                colorOpacity: 0.3,
                enabled: true,
                direction: ShimmerDirection.fromLTRB(),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 3.0, right: 3.0),
                child: Shimmer(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.grey[400],
                    ),
                    width: 100.0,
                    height: 20.0,
                  ),
                  duration: Duration(seconds: 5),
                  interval: Duration(seconds: 5),
                  color: Colors.white,
                  colorOpacity: 0.3,
                  enabled: true,
                  direction: ShimmerDirection.fromLTRB(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _jenisList() {
    return new GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: isLoading ? 6 : _jenis.length,
      itemBuilder: (context, index) {
        if (isLoading) {
          return _shimmerJenis();
        } else {
          return new Padding(
            padding: const EdgeInsets.all(8.0),
            child: JenisCardGrid(
              jenis: Jenis.fromMap(_jenis[index].toMap()),
              txtAdmin: null,
              onTapListBarang: () async {
                Navigator.push(
                  context,
                  geserKiriHalaman(
                    page: BarangPage(
                        idJenis: _jenis[index].id.toJson(),
                        namaJenis: _jenis[index].nama),
                  ),
                ).then(
                  (value) => setState(() {}),
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget _hasilCari() {
    return new GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: isLoading ? 6 : _searchResult.length,
      itemBuilder: (context, index) {
        if (isLoading) {
          return _shimmerJenis();
        } else {
          return new Padding(
            padding: const EdgeInsets.all(8.0),
            child: JenisCardGrid(
              jenis: Jenis.fromMap(_searchResult[index].toMap()),
              txtAdmin: null,
              onTapListBarang: () async {
                Navigator.push(
                  context,
                  geserKiriHalaman(
                    page: BarangPage(
                        idJenis: _searchResult[index].id.toJson(),
                        namaJenis: _searchResult[index].nama),
                  ),
                ).then((value) => setState(() {}));
              },
            ),
          );
        }
      },
    );
  }

  Widget _searchBox() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Card(
        child: new ListTile(
          leading: new Icon(Icons.search),
          title: new TextField(
            controller: controller,
            decoration: new InputDecoration(
                hintText: 'Cari jenis barang', border: InputBorder.none),
            onChanged: onSearchTextChanged,
          ),
          trailing: new IconButton(
            icon: new Icon(Icons.cancel),
            onPressed: () {
              controller.clear();
              onSearchTextChanged('');
            },
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return new Column(
      children: <Widget>[
        new Container(
          color: Theme.of(context).primaryColor,
          child: _searchBox(),
        ),
        Expanded(
          child: EasyRefresh(
            enableControlFinishRefresh: false,
            enableControlFinishLoad: true,
            controller: _refresh,
            header: BezierCircleHeader(
              color: Colors.white,
              backgroundColor: Colors.red[400],
            ),
            onRefresh: () async {
              await Future.delayed(
                Duration(seconds: 2),
                () async {
                  pullrestart();
                  setState(
                    () {},
                  );
                  _refresh.resetLoadState();
                },
              );
            },
            child: _searchResult.length != 0 || controller.text.isNotEmpty
                ? _hasilCari()
                : _jenisList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        if (connectivity == ConnectivityResult.none) {
          return Scaffold(
            appBar: new AppBar(
              title: new Text('No Internet'),
              centerTitle: true,
              elevation: 0.0,
            ),
            body: Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  'Oops, \n\nInternet Anda Bermasalah !! \n\nMohon Cek Internet, kemudian refresh halaman :)',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          );
        } else {
          return child;
        }
      },
      child: Scaffold(
        appBar: new AppBar(
          title: new Text('Jenis Barang'),
          centerTitle: true,
          elevation: 0.0,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _jenis.length.toString(),
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[200],
                  ),
                ),
                SizedBox(
                  width: 10.0,
                )
              ],
            ),
          ],
        ),
        body: _body(),
      ),
    );
  }

  pullrestart() async {
    await MongoDatabase.connect();
    await Firebase.initializeApp();
    if (_jenis.length > 0) {
      print(_jenis.length);
    } else {
      getJenis();
    }
    showSimpleNotification(
      Text(
        'Refresh Berhasil',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      background: Colors.green,
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _jenis.forEach((jenis) {
      if (jenis.nama.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(jenis);
    });

    setState(() {});
  }
}

// ignore: camel_case_types
class geserKiriHalaman extends PageRouteBuilder {
  final Widget page;
  geserKiriHalaman({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
