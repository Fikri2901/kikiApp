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

class Info extends StatefulWidget {
  Info({Key key}) : super(key: key);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  String _admin = "";
  EasyRefreshController _refresh;

  @override
  void initState() {
    super.initState();
    _refresh = EasyRefreshController();
    _panggilAdmin();
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
            elevation: 3,
            child: ListTile(
              onTap: () {},
              leading: Text('icon'),
              title: Text('Hello'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 3,
            child: ListTile(
              onTap: () {},
              leading: Text('icon'),
              title: Text('Hello'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 3,
            child: ListTile(
              onTap: () {},
              leading: Text('icon'),
              title: Text('Hello'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 3,
            child: ListTile(
              onTap: () {},
              leading: Text('icon'),
              title: Text('Hello'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 3,
            child: ListTile(
              onTap: () {},
              leading: Text('icon'),
              title: Text('Hello'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 3,
            child: ListTile(
              onTap: () {},
              leading: Text('icon'),
              title: Text('Hello'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 3,
            child: ListTile(
              onTap: () {},
              leading: Text('icon'),
              title: Text('Hello'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 3,
            child: ListTile(
              onTap: () {},
              leading: Text('icon'),
              title: Text('Hello'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tombolLogout() {
    return IconButton(
      icon: Icon(Icons.lock_open),
      onPressed: () {
        showLogout();
      },
    );
  }

  Widget _tampilan() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            _admin == 'kikicell'
                ? Container(
                    margin: const EdgeInsets.only(right: 10.0, left: 10.0),
                    height: 125.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: menuIcon(),
                  )
                // ignore: deprecated_member_use
                : OutlineButton(
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
            listMenu(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kiki Cell'),
        centerTitle: true,
        actions: _admin == 'kikicell'
            ? <Widget>[
                _tombolLogout(),
              ]
            : null,
      ),
      body: EasyRefresh(
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
                () {},
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
                () {},
              );
              _refresh.finishLoad();
            },
          );
        },
        child: _tampilan(),
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
