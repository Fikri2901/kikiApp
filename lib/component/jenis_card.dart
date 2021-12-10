import 'package:flutter/material.dart';
import 'package:kikiapp/models/jenis.dart';

class JenisCard extends StatelessWidget {
  JenisCard(
      {this.jenis, this.onLongDelete, this.onTapEdit, this.onTapListBarang});

  final Jenis jenis;
  final Function onLongDelete, onTapEdit, onTapListBarang;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      color: Colors.white,
      child: ListTile(
        // leading: Text(
        //   ''
        // ),
        onTap: onTapListBarang,
        onLongPress: onLongDelete,
        // () {
        // Navigator.push(context,
        //               MaterialPageRoute(builder: (BuildContext context) {
        //             return //AddJenisPage();
        //           })).then((value) => setState(() {}));
        // var snackBar = SnackBar(content: Text('${jenis.id}'));
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // },
        title: Text(jenis.nama),
        subtitle: Text('update: ${jenis.tanggal_update}'),
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
