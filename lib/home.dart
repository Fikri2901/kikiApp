import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:kikiapp/page/all_barang_page.dart';
import 'package:kikiapp/page/all_bayar_page.dart';
import 'package:kikiapp/page/all_token_page.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  EasyRefreshController _refresh;
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    _refresh = EasyRefreshController();
  }

  final double ukuranFont = 18.0;
  final double ukuranIcon = 70.0;
  final Color shadowColor = Colors.red;

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
              Material(
                shadowColor: shadowColor,
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
                child: IconButton(
                  iconSize: ukuranIcon,
                  color: Colors.blue[400],
                  icon: Icon(
                    Icons.inventory,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      ZoomAnimasi(
                        page: AllBarangPage(),
                      ),
                    ).then(
                      (value) => setState(() {}),
                    );
                  },
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
              Material(
                shadowColor: shadowColor,
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
                child: IconButton(
                  iconSize: ukuranIcon,
                  color: Colors.lightGreen,
                  icon: Icon(
                    Icons.menu_book_rounded,
                  ),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   ZoomAnimasi(
                    //     page: AllBarangPage(),
                    //   ),
                    // ).then(
                    //   (value) => setState(() {}),
                    // );
                  },
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
              Material(
                shadowColor: shadowColor,
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
                child: IconButton(
                  iconSize: ukuranIcon,
                  color: Colors.orange[300],
                  icon: Icon(
                    Icons.library_books,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      ZoomAnimasi(
                        page: AllTokenPage(),
                      ),
                    ).then(
                      (value) => setState(() {}),
                    );
                  },
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
              Material(
                shadowColor: shadowColor,
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
                child: IconButton(
                  iconSize: ukuranIcon,
                  color: Colors.purple[300],
                  icon: Icon(
                    Icons.list_alt_rounded,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      ZoomAnimasi(
                        page: AllBayarPage(),
                      ),
                    ).then(
                      (value) => setState(() {}),
                    );
                  },
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
        padding: const EdgeInsets.only(top: 10.0),
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
              margin: const EdgeInsets.only(right: 10.0, left: 10.0),
              height: 370.0,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: menuIcon(),
            )
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
        actions: <Widget>[],
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
        child: tampilan(),
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
