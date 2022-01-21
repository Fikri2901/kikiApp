import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kikiapp/models/jenis.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

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

  Widget _loader(BuildContext context, String url) {
    return Center(
      child: Shimmer(
        child: Container(
          margin: const EdgeInsets.only(top: 10.0),
          width: 100.0,
          height: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey[400],
          ),
        ),
        duration: Duration(seconds: 5),
        interval: Duration(seconds: 5),
        color: Colors.white,
        colorOpacity: 0.3,
        enabled: true,
        direction: ShimmerDirection.fromLTRB(),
      ),
    );
  }

  Widget _error(BuildContext context, String url, dynamic error) {
    return const Center(child: Icon(Icons.error));
  }

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
                child: CachedNetworkImage(
                  imageUrl: jenis.gambar,
                  placeholder: _loader,
                  errorWidget: _error,
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
