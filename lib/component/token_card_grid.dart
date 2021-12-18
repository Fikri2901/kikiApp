import 'package:flutter/material.dart';
import 'package:kikiapp/models/token.dart';

class TokenCardGrid extends StatelessWidget {
  TokenCardGrid({this.token, this.detailToken});

  final Token token;
  final Function detailToken;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: detailToken,
      child: Material(
        borderRadius: BorderRadius.circular(15.0),
        elevation: 5.0,
        color: Colors.white,
        child: Container(
          child: Column(
            children: [
              Container(
                width: 100.0,
                height: 100.0,
                child: Image.asset('assets/Dprofile.png'),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 3.0, right: 3.0),
                  child: Column(
                    children: [
                      Text(
                        token.nama,
                        style: TextStyle(fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          token.nomor,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue[400],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
