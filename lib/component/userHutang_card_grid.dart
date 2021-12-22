import 'package:flutter/material.dart';
import 'package:kikiapp/models/userHutang.dart';

class UserHutangCardGrid extends StatelessWidget {
  UserHutangCardGrid({this.userH, this.detailUserHutang, this.infoDetail});
  final Function infoDetail;
  final UserHutang userH;
  final Function detailUserHutang;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20.0),
      elevation: 3.0,
      color: Colors.white,
      child: ListTile(
        onTap: detailUserHutang,
        leading: Image.asset(
          'assets/Dprofile.png',
          width: 60,
        ),
        title: Text(userH.nama),
        trailing: TextButton(
          onPressed: infoDetail,
          child: Icon(Icons.info_outline_rounded),
        ),
      ),
    );
  }
}
