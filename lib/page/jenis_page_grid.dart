import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:kikiapp/component/jenis_card_grid.dart';
import 'package:kikiapp/database/database.dart';
import 'package:kikiapp/models/jenis.dart';
import 'package:kikiapp/page/barang_page_grid.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

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

  Future<Null> getJenis() async {
    final resp = await MongoDatabase.getDocumentJenis();

    setState(() {
      for (Map jenis in resp) {
        _jenis.add(Jenis.fromMap(jenis));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh = EasyRefreshController();
    getJenis();
  }

  Widget _jenisList() {
    return new GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: _jenis.length,
      itemBuilder: (context, index) {
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
      },
    );
  }

  Widget _hasilCari() {
    return new GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: _searchResult.length,
      itemBuilder: (context, index) {
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
            header: DeliveryHeader(),
            onRefresh: () async {
              await Future.delayed(
                Duration(seconds: 2),
                () {
                  print('onRefresh');
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Barang'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _body(),
      // resizeToAvoidBottomPadding: true,
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
