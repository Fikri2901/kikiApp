import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:kikiapp/models/barang.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BarangCardGrid extends StatelessWidget {
  BarangCardGrid({this.barang, this.detailBarang});

  final Barang barang;
  final Function detailBarang;

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
    return GridTile(
      child: Bounceable(
        onTap: detailBarang,
        child: Material(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
          elevation: 5.0,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10.0),
                width: 100.0,
                height: 100.0,
                child: CachedNetworkImage(
                  imageUrl: barang.gambar,
                  placeholder: _loader,
                  errorWidget: _error,
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 3.0, right: 3.0),
                  child: Column(
                    children: [
                      Text(
                        barang.nama,
                        style: TextStyle(fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          'Rp.' + barang.harga_ecer,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.green[300],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
