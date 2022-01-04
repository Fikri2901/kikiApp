import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:kikiapp/models/token.dart';

class TokenCardGrid extends StatelessWidget {
  TokenCardGrid({this.token, this.detailToken});

  final Token token;
  final Function detailToken;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: detailToken,
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        elevation: 3.0,
        color: Colors.white,
        child: ListTile(
          onTap: detailToken,
          leading: Image.asset(
            'assets/Dprofile.png',
            width: 60,
          ),
          title: Text(token.nama),
          subtitle: Text('Token : ${token.nomor}'),
        ),
      ),
    );
  }
}
