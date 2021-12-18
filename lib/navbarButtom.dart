import 'package:flutter/material.dart';
import 'package:kikiapp/home.dart';
import 'package:kikiapp/info.dart';
import 'package:kikiapp/page/jenis_page_grid.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class NavbarButtom extends StatefulWidget {
  @override
  _NavbarButtomState createState() => _NavbarButtomState();
}

class _NavbarButtomState extends State<NavbarButtom> {
  PageController _pageController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedIndex);
  }

  void onButtonPressed(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: _listOfWidget,
            ),
          ),
        ],
      ),
      bottomNavigationBar: SlidingClippedNavBar.colorful(
        backgroundColor: Colors.white,
        onButtonPressed: onButtonPressed,
        iconSize: 30,
        selectedIndex: selectedIndex,
        barItems: <BarItem>[
          BarItem(
            icon: Icons.home,
            title: 'Home',
            activeColor: Colors.blue[400],
            inactiveColor: Colors.red[400],
          ),
          BarItem(
            icon: Icons.inventory,
            title: 'Barang',
            activeColor: Colors.orange[400],
            inactiveColor: Colors.red[400],
          ),
          BarItem(
            icon: Icons.info_outline_rounded,
            title: 'Info',
            activeColor: Colors.green[400],
            inactiveColor: Colors.red[400],
          ),
        ],
      ),
    );
  }
}

List<Widget> _listOfWidget = <Widget>[Home(), JenisPage(), Info()];
