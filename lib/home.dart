// ignore_for_file: unused_field

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:kikiapp/database/database.dart';
import 'package:kikiapp/page/all_barang_page.dart';
import 'package:kikiapp/page/all_bayar_page.dart';
import 'package:kikiapp/page/all_token_page.dart';
import 'package:kikiapp/page/all_userHUtang_page.dart';
import 'package:overlay_support/overlay_support.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  EasyRefreshController _refresh;
  int _current = 0;
  final CarouselController _controller = CarouselController();
  final ScrollController scrollController = ScrollController();

  final double _initFabHeight = 120.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 0; // 365.0;

  bool hasInternet = false;

  koneksi() async {
    await MongoDatabase.connect();
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    super.initState();
    _refresh = EasyRefreshController();
    _fabHeight = _initFabHeight;
    koneksi();
  }

  final double ukuranFont = 18.0;
  final double ukuranIcon = 70.0;
  final Color colorIcon = Colors.white;
  final Color shadowColor = Colors.red.withOpacity(0.5);

  Widget _menuIcon() {
    return GridView.count(
      primary: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 20.0),
      crossAxisCount: 2,
      children: <Widget>[
        GridTile(
          child: Column(
            children: [
              Bounceable(
                onTap: () {
                  Navigator.push(
                    context,
                    ZoomAnimasi(
                      page: AllBarangPage(),
                    ),
                  ).then(
                    (value) => setState(() {}),
                  );
                },
                child: Material(
                  shadowColor: shadowColor,
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.red[400],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.inventory,
                      size: ukuranIcon,
                      color: colorIcon,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Semua Barang',
                    style: TextStyle(
                      fontSize: ukuranFont,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        GridTile(
          child: Column(
            children: [
              Bounceable(
                onTap: () {
                  Navigator.push(
                    context,
                    ZoomAnimasi(
                      page: AllUserHutangPage(),
                    ),
                  ).then(
                    (value) => setState(() {}),
                  );
                },
                child: Material(
                  shadowColor: shadowColor,
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.red[400],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.menu_book_rounded,
                      size: ukuranIcon,
                      color: colorIcon,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Buku Hutang',
                    style: TextStyle(
                      fontSize: ukuranFont,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        GridTile(
          child: Column(
            children: [
              Bounceable(
                onTap: () {
                  Navigator.push(
                    context,
                    ZoomAnimasi(
                      page: AllTokenPage(),
                    ),
                  ).then(
                    (value) => setState(() {}),
                  );
                },
                child: Material(
                  shadowColor: shadowColor,
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.red[400],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.library_books,
                      size: ukuranIcon,
                      color: colorIcon,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'List Token Listrik',
                    style: TextStyle(
                      fontSize: ukuranFont,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        GridTile(
          child: Column(
            children: [
              Bounceable(
                onTap: () {
                  Navigator.push(
                    context,
                    ZoomAnimasi(
                      page: AllBayarPage(),
                    ),
                  ).then(
                    (value) => setState(() {}),
                  );
                },
                child: Material(
                  shadowColor: shadowColor,
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.red[400],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.list_alt_rounded,
                      size: ukuranIcon,
                      color: colorIcon,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'List Bayar Listrik',
                    style: TextStyle(
                      fontSize: ukuranFont,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _carousel() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            items: imageSliders,
            carouselController: _controller,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.red[400])
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _carousel2() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            items: imageSliders2,
          ),
        ],
      ),
    );
  }

  Widget refresh() {
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
          () async {
            await MongoDatabase.connect();
            await Firebase.initializeApp();

            showSimpleNotification(
                Text(
                  'Refresh Berhasil',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                background: Colors.green);
            setState(
              () {},
            );
            _refresh.resetLoadState();
          },
        );
      },
      child: _carousel(),
      // ),
    );
  }

  Widget _panel(ScrollController sc) {
    return ListView(
      controller: sc,
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 50.0,
              height: 5.0,
              decoration: BoxDecoration(
                color: Colors.red[400],
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
          ],
        ),
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin:
                    const EdgeInsets.only(right: 10.0, left: 10.0, top: 5.0),
                height: 350.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: _menuIcon(),
              ),
              _carousel2()
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;
    _panelHeightClosed = _panelHeightOpen - 260.0;

    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        if (connectivity == ConnectivityResult.none) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: new AppBar(
              title: new Text(
                'No Internet',
                style: TextStyle(
                  color: Colors.red[400],
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Kiki Cell',
            style: TextStyle(
              color: Colors.red[400],
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SizedBox.expand(
          child: Stack(
            children: <Widget>[
              refresh(),
              Padding(padding: const EdgeInsets.all(20.0)),
              SizedBox.expand(
                child: DraggableScrollableSheet(
                  initialChildSize: 0.60,
                  minChildSize: 0.60,
                  builder: (BuildContext context, s) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18.0),
                            topRight: Radius.circular(18.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10.0,
                            ),
                          ]),
                      child: _panel(s),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

final List<String> banner = [
  'assets/contohbanner.png',
  'assets/contohbanner.png',
  'assets/contohbanner.png',
  'assets/contohbanner.png'
];

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      item,
                      fit: BoxFit.cover,
                      width: 1000.0,
                      height: 500.0,
                    ),
                    // Positioned(
                    //   bottom: 0.0,
                    //   left: 0.0,
                    //   right: 0.0,
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       gradient: LinearGradient(
                    //         colors: [
                    //           Color.fromARGB(200, 0, 0, 0),
                    //           Color.fromARGB(0, 0, 0, 0)
                    //         ],
                    //         begin: Alignment.bottomCenter,
                    //         end: Alignment.topCenter,
                    //       ),
                    //     ),
                    //     padding: EdgeInsets.symmetric(
                    //         vertical: 10.0, horizontal: 20.0),
                    //   ),
                    // ),
                  ],
                )),
          ),
        ))
    .toList();

final List<Widget> imageSliders2 = banner
    .map((item) => Container(
          child: Container(
            height: 50.0,
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      item,
                      fit: BoxFit.cover,
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
