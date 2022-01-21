import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:kikiapp/component/barang_card_grid.dart';
import 'package:kikiapp/database/database.dart';
import 'package:kikiapp/models/barang.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BarangPage extends StatefulWidget {
  final String idJenis, namaJenis;
  BarangPage({Key key, this.idJenis, this.namaJenis}) : super(key: key);

  @override
  _BarangPageState createState() => new _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  List<Barang> _searchResult = [];
  List<Barang> _barang = [];
  TextEditingController cariText = new TextEditingController();
  EasyRefreshController _refresh;

  bool isLoading = false;

  Future<Null> getBarang() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: 2), () {});
    await MongoDatabase.connect();
    await Firebase.initializeApp();
    final resp = await MongoDatabase.getBarangById(this.widget.idJenis);

    setState(() {
      for (Map barang in resp) {
        _barang.add(Barang.fromMap(barang));
      }
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh = EasyRefreshController();
    getBarang();
  }

  int startIndex = 0;
  int endIndex = 12;

  Widget _shimmerBarang() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridTile(
        child: Material(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
          elevation: 5.0,
          child: Column(
            children: [
              Shimmer(
                child: Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  width: 100.0,
                  height: 70.0,
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
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 3.0, right: 3.0),
                  child: Column(
                    children: [
                      Shimmer(
                        child: Container(
                          width: 150.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
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
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Shimmer(
                          child: Container(
                            width: 100.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _barangList() {
    return new GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: isLoading ? 6 : _barang.length.clamp(startIndex, endIndex),
      itemBuilder: (context, index) {
        if (isLoading) {
          return _shimmerBarang();
        } else {
          return new Padding(
            padding: const EdgeInsets.all(8.0),
            child: BarangCardGrid(
              barang: Barang.fromMap(
                _barang[index].toMap(),
              ),
              detailBarang: () {
                showDetail(
                  Barang.fromMap(
                    _barang[index].toMap(),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget _hasilCari() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: _searchResult.length,
      itemBuilder: (context, index) {
        return new Padding(
          padding: const EdgeInsets.all(8.0),
          child: BarangCardGrid(
            barang: Barang.fromMap(
              _searchResult[index].toMap(),
            ),
            detailBarang: () {
              showDetail(
                Barang.fromMap(
                  _searchResult[index].toMap(),
                ),
              );
            },
          ),
        );
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
            controller: cariText,
            decoration: new InputDecoration(
                hintText: 'Cari ' + this.widget.namaJenis,
                border: InputBorder.none),
            onChanged: onSearchTextChanged,
          ),
          trailing: new IconButton(
            icon: new Icon(Icons.cancel),
            onPressed: () {
              cariText.clear();
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
            footer: MaterialFooter(),
            onRefresh: () async {
              await Future.delayed(
                Duration(seconds: 2),
                () {
                  pullrestart();
                  setState(
                    () {
                      endIndex = 12;
                    },
                  );
                  _refresh.resetLoadState();
                },
              );
            },
            onLoad: () async {
              await Future.delayed(
                Duration(seconds: 2),
                () {
                  setState(
                    () {
                      endIndex += 10;
                    },
                  );
                  _refresh.finishLoad();
                },
              );
            },
            child: _searchResult.length != 0 || cariText.text.isNotEmpty
                ? _hasilCari()
                : _barangList(),
          ),
        ),
        // ),
      ],
    );
  }

  pullrestart() async {
    await MongoDatabase.connect();
    await Firebase.initializeApp();
    if (_barang.length > 0) {
      print(_barang.length);
    } else {
      getBarang();
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
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          title: new Text(this.widget.namaJenis),
          elevation: 0.0,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _barang.length.toString(),
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
        // resizeToAvoidBottomPadding: true,
      ),
    );
  }

  Widget _loader(BuildContext context, String url) {
    return Center(
      child: Shimmer(
        child: Container(
          margin: const EdgeInsets.only(top: 10.0),
          width: 100.0,
          height: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey[400],
          ),
        ),
        duration: Duration(seconds: 5),
        interval: Duration(seconds: 5),
        color: Colors.white,
        colorOpacity: 0.3,
        enabled: true,
        direction: ShimmerDirection.fromLTRB(),
      ),
    );
  }

  Widget _error(BuildContext context, String url, dynamic error) {
    return const Center(child: Icon(Icons.error));
  }

  showDetail(Barang barang) {
    Widget cancelButton = TextButton(
      child: Text("Tutup"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      contentPadding: EdgeInsets.only(top: 0),
      content: Container(
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0)),
                ),
                child: Text(
                  "${barang.nama}",
                  style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 8.0),
              child: CachedNetworkImage(
                imageUrl: barang.gambar,
                placeholder: _loader,
                errorWidget: _error,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 8.0),
              child: Text(
                "Harga Ecer : Rp.${barang.harga_ecer}",
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 8.0),
              child: Text(
                "Harga Grosir : Rp.${barang.harga_grosir}",
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 8.0),
              child: Text(
                "Update : ${barang.tanggal_update}",
                textAlign: TextAlign.left,
              ),
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

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _barang.forEach((barang) {
      if (barang.nama.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(barang);
    });

    setState(() {});
  }
}
