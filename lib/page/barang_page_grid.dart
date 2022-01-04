import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:kikiapp/component/barang_card_grid.dart';
import 'package:kikiapp/database/database.dart';
import 'package:kikiapp/models/barang.dart';

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

  Future<Null> getBarang() async {
    print(this.widget.idJenis);
    final resp = await MongoDatabase.getBarangById(this.widget.idJenis);
    setState(() {
      for (Map barang in resp) {
        _barang.add(Barang.fromMap(barang));
      }
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

  Widget _barangList() {
    return new GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: _barang.length.clamp(startIndex, endIndex),
      itemBuilder: (context, index) {
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
                  print('onRefresh');
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: new Text(this.widget.namaJenis),
        elevation: 0.0,
      ),
      body: _body(),
      // resizeToAvoidBottomPadding: true,
    );
  }

  Widget _loader(BuildContext context, String url) {
    return const Center(
      child: CircularProgressIndicator(),
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
