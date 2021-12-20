import 'package:flutter/material.dart';
import 'package:kikiapp/models/token.dart';
import 'package:kikiapp/models/userHutang.dart';

class UserHutangCard extends StatelessWidget {
  const UserHutangCard(
      {this.userH, this.onPress, this.onLongDelete, this.onTapEdit});

  final UserHutang userH;
  final Function onLongDelete, onTapEdit, onPress;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      color: Colors.white,
      child: ListTile(
        onTap: onPress,
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
    );
  }
}
