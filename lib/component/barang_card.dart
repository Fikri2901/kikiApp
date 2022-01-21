import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:kikiapp/models/barang.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BarangCard extends StatelessWidget {
  const BarangCard(
      {this.barang, this.onPress, this.onLongDelete, this.onTapEdit});

  final Barang barang;
  final Function onLongDelete, onTapEdit, onPress;

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
    return Bounceable(
      onTap: onPress,
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        elevation: 3.0,
        color: Colors.white,
        child: ListTile(
          onTap: onPress,
          onLongPress: onLongDelete,
          leading: CachedNetworkImage(
            imageUrl: barang.gambar,
            placeholder: (BuildContext context, String url) => Shimmer(
              child: Container(
                margin: const EdgeInsets.only(top: 10.0),
                width: 60.0,
                height: 60.0,
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
            errorWidget: _error,
          ),
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
      ),
    );
  }
}
