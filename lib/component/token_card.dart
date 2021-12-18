import 'package:flutter/material.dart';
import 'package:kikiapp/models/token.dart';

class TokenCard extends StatelessWidget {
  const TokenCard(
      {this.token, this.onPress, this.onLongDelete, this.onTapEdit});

  final Token token;
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
        title: Text(token.nama),
        subtitle: Text('Nomor Token : ${token.nomor}'),
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
