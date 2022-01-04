import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:kikiapp/models/bayar.dart';

class BayarCard extends StatelessWidget {
  const BayarCard(
      {this.bayar, this.onPress, this.onLongDelete, this.onTapEdit});

  final Bayar bayar;
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
          onLongPress: onLongDelete,
          leading: Image.asset(
            'assets/Dprofile.png',
            width: 60,
          ),
          title: Text(bayar.nama),
          subtitle: Text('Nomor : ${bayar.nomor}'),
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
