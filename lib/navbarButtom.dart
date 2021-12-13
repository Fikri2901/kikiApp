import 'package:flutter/material.dart';
import 'package:kikiapp/home.dart';
import 'package:kikiapp/info.dart';
import 'package:kikiapp/page/home_page.dart';
import 'package:kikiapp/page/home_page_grid.dart';
import 'package:kikiapp/page/jenis_page_grid.dart';

class NavbarButtom extends StatefulWidget {
  @override
  _NavbarButtomState createState() => _NavbarButtomState();
}

class _NavbarButtomState extends State<NavbarButtom> {
  int _selectedTabIndex = 0;

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _listPage = <Widget>[Home(), JenisPage(), Info()];

    final _navbarItem = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.inventory),
        label: 'Barang',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.info),
        label: 'Info',
      ),
    ];

    final _buttonNavbar = BottomNavigationBar(
      items: _navbarItem,
      currentIndex: _selectedTabIndex,
      selectedItemColor: Colors.red[700],
      unselectedItemColor: Colors.blueGrey,
      onTap: _onNavBarTapped,
    );

    return Scaffold(
      body: Center(
        child: _listPage[_selectedTabIndex],
      ),
      bottomNavigationBar: _buttonNavbar,
    );
  }
}
