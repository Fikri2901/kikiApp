import 'package:flutter/material.dart';
import 'package:kikiapp/models/jenis.dart';

class JenisCardGrid extends StatelessWidget {
  JenisCardGrid(
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
    return GestureDetector(
      onLongPress: onLongDelete,
      onTap: onTapListBarang,
      child: Material(
        borderRadius: BorderRadius.circular(15.0),
        elevation: 5.0,
        color: Colors.white,
        child: Container(
          margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Column(
            children: [
              Container(
                width: 100.0,
                height: 100.0,
                child: Image.network(
                  jenis.gambar,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 3.0, right: 3.0),
                child: Text(
                  jenis.nama,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
