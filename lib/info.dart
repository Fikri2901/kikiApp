// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:kikiapp/login.dart';
import 'package:kikiapp/navbarButtom.dart';
import 'package:kikiapp/page/bayar_page.dart';
import 'package:kikiapp/page/home_page.dart';
import 'package:kikiapp/page/token_page.dart';
import 'package:kikiapp/page/userHutang_page.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Info extends StatefulWidget {
  Info({Key key}) : super(key: key);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  String _admin = "";
  EasyRefreshController _refresh;

  final double _initFabHeight = 120.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 45.0;

  bool _switchValue = true;

  @override
  void initState() {
    super.initState();
    _refresh = EasyRefreshController();
    _panggilAdmin();

    _fabHeight = _initFabHeight;
  }

  Widget menuIcon() {
    return GridView.count(
      primary: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 20.0),
      crossAxisCount: 4,
      children: <Widget>[
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: IconButton(
                iconSize: 50.0,
                icon: Icon(
                  Icons.inventory,
                  color: Colors.blue[300],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    ZoomAnimasi(
                      page: Homepage(),
                    ),
                  ).then((value) => setState(() {}));
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Barang',
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: IconButton(
                iconSize: 50.0,
                icon: Icon(
                  Icons.menu_book_rounded,
                  color: Colors.lightGreen,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    ZoomAnimasi(
                      page: UserHutangPage(),
                    ),
                  ).then((value) => setState(() {}));
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Hutang',
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: IconButton(
                iconSize: 50.0,
                icon: Icon(
                  Icons.library_books,
                  color: Colors.orange[300],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    ZoomAnimasi(
                      page: TokenPage(),
                    ),
                  ).then((value) => setState(() {}));
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Token Listrik',
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: IconButton(
                iconSize: 50.0,
                icon: Icon(
                  Icons.list_alt_rounded,
                  color: Colors.purple[300],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    ZoomAnimasi(
                      page: BayarPage(),
                    ),
                  ).then((value) => setState(() {}));
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Bayar Listrik',
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget listMenu() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 4,
            color: Colors.white,
            child: ListTile(
              onTap: () {},
              leading: Icon(
                Icons.info_outline_rounded,
              ),
              title: Text('Info'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 4,
            color: Colors.white,
            child: ListTile(
              onTap: () {},
              leading: Icon(
                Icons.house_rounded,
              ),
              title: Text('Tema'),
              trailing: CupertinoSwitch(
                  value: _switchValue,
                  activeColor: Colors.red[400],
                  onChanged: (value) {
                    setState(
                      () {
                        _switchValue = value;
                      },
                    );
                  }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tombolLogout() {
    return IconButton(
      icon: Icon(Icons.lock_open),
      color: Colors.red[400],
      onPressed: () {
        showLogout();
      },
    );
  }

  Widget _body() {
    return EasyRefresh(
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
          () {
            setState(
              () {},
            );
            _refresh.resetLoadState();
          },
        );
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: listMenu(),
        ),
      ),
    );
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        controller: sc,
        children: <Widget>[
          SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50.0,
                height: 5.0,
                decoration: BoxDecoration(
                  color: Colors.red[200],
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30.0,
          ),
          _admin == 'kikicell'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red[300],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'ADMIN',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox(
                  height: 0,
                ),
          SizedBox(
            height: 25.0,
          ),
          _admin == 'kikicell'
              ? Container(
                  // padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                  margin: const EdgeInsets.only(right: 10.0, left: 10.0),
                  height: 125.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: menuIcon(),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlineButton(
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
                        child: Text('Login Admin')),
                  ],
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .45;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'Pengaturan',
          style: TextStyle(
            color: Colors.red[400],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: _admin == 'kikicell'
            ? <Widget>[
                _tombolLogout(),
              ]
            : null,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SlidingUpPanel(
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            // parallaxEnabled: true,
            // parallaxOffset: .5,
            body: _body(),
            panelBuilder: (sc) => _panel(sc),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState(() {
              _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                  _initFabHeight;
            }),
          ),
        ],
      ),
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

  void _panggilAdmin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      if (pref.getString('admin') != null) {
        _admin = pref.getString('admin');
      }
    });
  }
}

final List<String> imgList = [
  'assets/crs/1.jpg',
  'assets/crs/2.jpg',
  'assets/crs/3.jpg',
  'assets/crs/4.jpg',
  'assets/crs/5.jpg',
  'assets/crs/6.jpg',
];

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      item,
                      fit: BoxFit.cover,
                      width: 1000.0,
                      height: 500.0,
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();

class ZoomAnimasi extends PageRouteBuilder {
  final Widget page;
  ZoomAnimasi({this.page})
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
              ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ),
            ),
            child: child,
          ),
        );
}
