import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:kikiapp/component/userHutang_card_grid.dart';
import 'package:kikiapp/database/database.dart';
import 'package:kikiapp/models/userHutang.dart';

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

  Future<Null> getUserhutang() async {
    final resp = await MongoDatabase.getUserHutang();
    setState(() {
      for (Map userH in resp) {
        _userH.add(UserHutang.fromMap(userH));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh = EasyRefreshController();
    getUserhutang();
  }

  Widget _tokenList() {
    return new ListView.builder(
      itemCount: _userH.length.clamp(startIndex, endIndex),
      itemBuilder: (context, index) {
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
          ),
        );
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
            header: PhoenixHeader(),
            footer: MaterialFooter(),
            onRefresh: () async {
              await Future.delayed(
                Duration(seconds: 2),
                () {
                  print('onRefresh');
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Token Listrik'),
        elevation: 0.0,
      ),
      body: _body(),
      // resizeToAvoidBottomPadding: true,
    );
  }

  showDetail(UserHutang userH) {
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
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 8.0),
              child: Text(
                'data hutang',
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
