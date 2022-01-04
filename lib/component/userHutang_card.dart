import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:kikiapp/models/userHutang.dart';

class UserHutangCard extends StatelessWidget {
  const UserHutangCard(
      {this.userH, this.onTapListHutang, this.onLongDelete, this.onTapEdit});

  final UserHutang userH;
  final Function onLongDelete, onTapEdit, onTapListHutang;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTapListHutang,
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        elevation: 3.0,
        color: Colors.white,
        child: ListTile(
          onTap: onTapListHutang,
          onLongPress: onLongDelete,
          leading: Image.asset(
            'assets/Dprofile.png',
            width: 60,
          ),
          title: Text(userH.nama),
          subtitle: Text('Jumlah : total hutang'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                child: Icon(Icons.edit),
                onTap: onTapEdit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
