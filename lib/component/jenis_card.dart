import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kikiapp/models/jenis.dart';

class JenisCard extends StatelessWidget {
  JenisCard(
      {this.jenis, this.onLongDelete, this.onTapEdit, this.onTapListBarang});

  final Jenis jenis;
  final Function onLongDelete, onTapEdit, onTapListBarang;
// ignore: unused_element
  Widget _loader(BuildContext context, String url) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _error(BuildContext context, String url, dynamic error) {
    return const Center(child: Icon(Icons.error));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20.0),
      elevation: 3.0,
      color: Colors.white,
      child: ListTile(
        onTap: onTapListBarang,
        onLongPress: onLongDelete,
        leading: CachedNetworkImage(
          imageUrl: jenis.gambar,
          placeholder: (BuildContext context, String url) => Container(
            width: 60,
            height: 60,
            color: Colors.grey,
          ),
          errorWidget: _error,
        ),
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
