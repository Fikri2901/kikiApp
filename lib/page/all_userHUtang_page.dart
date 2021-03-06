import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:intl/intl.dart';
import 'package:kikiapp/component/userHutang_card_grid.dart';
import 'package:kikiapp/database/database.dart';
import 'package:kikiapp/models/userHutang.dart';
import 'package:kikiapp/page/hutangUser_page.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AllUserHutangPage extends StatefulWidget {
  AllUserHutangPage({Key key}) : super(key: key);

  @override
  _AllUserHutangPageState createState() => new _AllUserHutangPageState();
}

class _AllUserHutangPageState extends State<AllUserHutangPage> {
  List<UserHutang> _searchResult = [];
  List<UserHutang> _userH = [];

  int startIndex = 0;
  int endIndex = 10;

  TextEditingController cariText = new TextEditingController();
  EasyRefreshController _refresh;

  bool isLoading = false;

  Future<Null> getUserhutang() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: 2), () {});
    await MongoDatabase.connect();
    await Firebase.initializeApp();
    final resp = await MongoDatabase.getUserHutang();
    setState(() {
      for (Map userH in resp) {
        _userH.add(UserHutang.fromMap(userH));
      }
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh = EasyRefreshController();
    getUserhutang();
  }

  Widget _shimmerUserHutang() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        elevation: 3.0,
        color: Colors.white,
        child: ListTile(
          leading: Shimmer(
            child: Container(
              margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
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
        ),
      ),
    );
  }

  Widget _userHutangList() {
    return new ListView.builder(
      itemCount: isLoading ? 9 : _userH.length.clamp(startIndex, endIndex),
      itemBuilder: (context, index) {
        if (isLoading) {
          return _shimmerUserHutang();
        } else {
          return new Padding(
            padding: const EdgeInsets.all(8.0),
            child: UserHutangCardGrid(
              userH: UserHutang.fromMap(
                _userH[index].toMap(),
              ),
              detailUserHutang: () {
                showDetail(
                  UserHutang.fromMap(
                    _userH[index].toMap(),
                  ),
                );
              },
              infoDetail: () {
                Navigator.push(
                  context,
                  geserKiriHalaman(
                    page: HutangUserPage(
                        id_user: _userH[index].id.toJson(),
                        nama: _userH[index].nama),
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
    return ListView.builder(
      itemCount: _searchResult.length,
      itemBuilder: (context, index) {
        return new Padding(
          padding: const EdgeInsets.all(8.0),
          child: UserHutangCardGrid(
            userH: UserHutang.fromMap(
              _searchResult[index].toMap(),
            ),
            detailUserHutang: () {
              showDetail(
                UserHutang.fromMap(
                  _searchResult[index].toMap(),
                ),
              );
            },
            infoDetail: () {
              Navigator.push(
                context,
                geserKiriHalaman(
                  page: HutangUserPage(
                      id_user: _userH[index].id.toJson(),
                      nama: _userH[index].nama),
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

  Widget _searchBox() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: Hero(
        tag: 'cari',
        child: new Card(
          child: new ListTile(
            leading: new Icon(Icons.search),
            title: new TextField(
              controller: cariText,
              decoration: new InputDecoration(
                  hintText: 'Cari Nama', border: InputBorder.none),
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
                : _userHutangList(),
          ),
        ),
      ],
    );
  }

  pullrestart() async {
    await MongoDatabase.connect();
    await Firebase.initializeApp();
    if (_userH.length > 0) {
      print(_userH.length);
    } else {
      getUserhutang();
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
          title: new Text('Buku Hutang'),
          elevation: 0.0,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _userH.length.toString(),
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

  showDetail(UserHutang userH) async {
    ScrollController _controller;
    final rp = NumberFormat("#,##0", "en_US");

    final resp = await MongoDatabase.getJumlah(userH);
    int sum = 0;
    List tampil = [];

    for (var i = 0; i < resp.length; i++) {
      sum += num.parse(resp[i]['harga']);
      tampil.add(resp[i]);
    }

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
                  "${userH.nama}",
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
            SingleChildScrollView(
              child: Container(
                height: 100.0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                  child: ListView.builder(
                      controller: _controller,
                      itemCount: tampil.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return new Text('Rp. ' +
                            rp.format(num.parse(tampil[index]['harga'])) +
                            ' = ' +
                            tampil[index]['deskripsi']);
                      }),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 8.0),
              child: sum != 0
                  ? Text(
                      'Total: Rp. ' + rp.format(sum).toString(),
                      style: TextStyle(fontSize: 20.0),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      'Tidak ada Hutang',
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

    _userH.forEach((userH) {
      if (userH.nama.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(userH);
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
