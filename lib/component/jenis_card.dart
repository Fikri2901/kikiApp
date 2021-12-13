import 'package:flutter/material.dart';
import 'package:kikiapp/models/jenis.dart';

class JenisCard extends StatelessWidget {
  JenisCard(
      {this.jenis,
      this.txtAdmin,
      this.onLongDelete,
      this.onTapEdit,
      this.onTapListBarang});

  final Jenis jenis;
  final String txtAdmin;
  final Function onLongDelete, onTapEdit, onTapListBarang;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      color: Colors.white,
      child: ListTile(
        onTap: onTapListBarang,
        onLongPress: onLongDelete,
        title: Text(jenis.nama),
        subtitle: Text('update: ${jenis.tanggal_update}'),
        trailing: txtAdmin == 'kikicell'
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: Icon(Icons.edit),
                    onTap: onTapEdit,
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
