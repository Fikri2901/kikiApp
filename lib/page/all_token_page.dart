import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:kikiapp/component/token_card_grid.dart';
import 'package:kikiapp/database/database.dart';
import 'package:kikiapp/models/token.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AllTokenPage extends StatefulWidget {
  final String idJenis, namaJenis;
  AllTokenPage({Key key, this.idJenis, this.namaJenis}) : super(key: key);

  @override
  _AllTokenPageState createState() => new _AllTokenPageState();
}

class _AllTokenPageState extends State<AllTokenPage> {
  List<Token> _searchResult = [];
  List<Token> _token = [];

  int startIndex = 0;
  int endIndex = 10;

  TextEditingController cariText = new TextEditingController();
  EasyRefreshController _refresh;

  bool isLoading = false;

  Future<Null> getToken() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: 2), () {});
    await MongoDatabase.connect();
    await Firebase.initializeApp();
    final resp = await MongoDatabase.getTokenListrik();
    setState(() {
      for (Map token in resp) {
        _token.add(Token.fromMap(token));
      }
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh = EasyRefreshController();
    getToken();
  }

  Widget _shimmerToken() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        elevation: 3.0,
        color: Colors.white,
        child: ListTile(
          leading: Shimmer(
            child: Container(
              width: 60.0,
              height: 60.0,
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
          title: Shimmer(
            child: Container(
              margin: const EdgeInsets.only(right: 80.0),
              // width: 30.0,
              height: 17.0,
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
          subtitle: Shimmer(
            child: Container(
              margin: const EdgeInsets.only(right: 120.0),
              // width: 20.0,
              height: 15.0,
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
      ),
    );
  }

  Widget _tokenList() {
    return new ListView.builder(
      itemCount: isLoading ? 7 : _token.length.clamp(startIndex, endIndex),
      itemBuilder: (context, index) {
        if (isLoading) {
          return _shimmerToken();
        } else {
          return new Padding(
            padding: const EdgeInsets.all(8.0),
            child: TokenCardGrid(
              token: Token.fromMap(
                _token[index].toMap(),
              ),
              detailToken: () {
                showDetail(
                  Token.fromMap(
                    _token[index].toMap(),
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
    return ListView.builder(
      itemCount: _searchResult.length,
      itemBuilder: (context, index) {
        return new Padding(
          padding: const EdgeInsets.all(8.0),
          child: TokenCardGrid(
            token: Token.fromMap(
              _searchResult[index].toMap(),
            ),
            detailToken: () {
              showDetail(
                Token.fromMap(
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
                hintText: 'Cari Nama / Token Listrik',
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
                      endIndex = 10;
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
                : _tokenList(),
          ),
        ),
      ],
    );
  }

  pullrestart() async {
    await MongoDatabase.connect();
    await Firebase.initializeApp();
    if (_token.length > 0) {
      print(_token.length);
    } else {
      getToken();
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
        appBar: new AppBar(
          title: new Text('Token Listrik'),
          elevation: 0.0,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _token.length.toString(),
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

  showDetail(Token token) {
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
                  "${token.nama}",
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
              child: Text(
                token.nomor,
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
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
        return alert;
      },
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _token.forEach((token) {
      if (token.nama.toLowerCase().contains(text.toLowerCase()) ||
          token.nomor.contains(text)) _searchResult.add(token);
    });

    setState(() {});
  }
}
