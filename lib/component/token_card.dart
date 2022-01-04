import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:kikiapp/models/token.dart';

class TokenCard extends StatelessWidget {
  const TokenCard(
      {this.token, this.onPress, this.onLongDelete, this.onTapEdit});

  final Token token;
  final Function onLongDelete, onTapEdit, onPress;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onPress,
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        elevation: 3.0,
        color: Colors.white,
        child: ListTile(
          onTap: onPress,
          onLongPress: onLongDelete,
          leading: Image.asset(
            'assets/Dprofile.png',
            width: 60,
          ),
          title: Text(token.nama),
          subtitle: Text('Nomor : ${token.nomor}'),
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
