import 'package:flutter/material.dart';
import 'package:kikiapp/models/bayar.dart';

class BayarCardGrid extends StatelessWidget {
  BayarCardGrid({this.bayar, this.detailBayar});

  final Bayar bayar;
  final Function detailBayar;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20.0),
      elevation: 3.0,
      color: Colors.white,
      child: ListTile(
        onTap: detailBayar,
        leading: Image.asset(
          'assets/Dprofile.png',
          width: 60,
        ),
        title: Text(bayar.nama),
        subtitle: Text('Token : ${bayar.nomor}'),
      ),
    );
  }
}
