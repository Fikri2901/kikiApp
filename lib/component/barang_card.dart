import 'package:flutter/material.dart';
import 'package:kikiapp/models/barang.dart';

class BarangCard extends StatelessWidget {
  const BarangCard({this.barang, this.onLongDelete, this.onTapEdit});

  final Barang barang;
  final Function onLongDelete, onTapEdit;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      color: Colors.white,
      child: ListTile(
        // leading: Text(
        //   '${barang}',
        //   style: Theme.of(context).textTheme.headline6,
        // ),
        onLongPress: onLongDelete,
        title: Text(barang.nama),
        subtitle: Text('Harga : Rp. ${barang.harga_ecer},00'),
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
