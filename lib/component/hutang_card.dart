import 'package:flutter/material.dart';
import 'package:kikiapp/models/hutang.dart';

class HutangCard extends StatelessWidget {
  const HutangCard(
      {this.hutang, this.onTapListHutang, this.onLongDelete, this.onTapEdit});

  final Hutang hutang;
  final Function onLongDelete, onTapEdit, onTapListHutang;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20.0),
      elevation: 3.0,
      color: Colors.white,
      child: ListTile(
        onTap: onTapListHutang,
        onLongPress: onLongDelete,
        leading: Icon(Icons.keyboard_arrow_right_rounded),
        title: Text('Rp. ' + hutang.harga),
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
