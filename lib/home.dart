import 'package:fluent_appbar/fluent_appbar.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:kikiapp/page/all_barang_page.dart';
import 'package:kikiapp/page/all_bayar_page.dart';
import 'package:kikiapp/page/all_token_page.dart';
import 'package:kikiapp/page/all_userHUtang_page.dart';

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

  @override
  void initState() {
    super.initState();
    _refresh = EasyRefreshController();
  }

  final double ukuranFont = 18.0;
  final double ukuranIcon = 70.0;
  final Color colorIcon = Colors.white;
  final Color shadowColor = Colors.red.withOpacity(0.5);

  Widget menuIcon() {
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

  Widget tampilan() {
    return SingleChildScrollView(
      child: Padding(
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                  ),
                );
              }).toList(),
            ),
            Container(
              margin: const EdgeInsets.only(right: 10.0, left: 10.0, top: 5.0),
              height: 570.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: menuIcon(),
            )
          ],
        ),
      ),
    );
  }

  Widget refresh() {
    return Padding(
      padding: EdgeInsets.only(
        top: AppBar().preferredSize.height + MediaQuery.of(context).padding.top,
      ),
      child: EasyRefresh(
        enableControlFinishRefresh: false,
        enableControlFinishLoad: true,
        controller: _refresh,
        scrollController: scrollController,
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
        child: tampilan(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          refresh(),
          FluentAppBar(
            appBarColor: Colors.white,
            titleText: "Kiki Cell",
            scrollController: scrollController,
            titleColor: Colors.red[400],
          )
        ],
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
