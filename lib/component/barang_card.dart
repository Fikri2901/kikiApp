import 'package:flutter/material.dart';
import 'package:kikiapp/models/barang.dart';

class BarangCard extends StatelessWidget {
  const BarangCard(
      {this.barang, this.onPress, this.onLongDelete, this.onTapEdit});

  final Barang barang;
  final Function onLongDelete, onTapEdit, onPress;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      color: Colors.white,
      child: ListTile(
        onTap: onPress,
        onLongPress: onLongDelete,
        leading: Image.network(barang.gambar),
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
