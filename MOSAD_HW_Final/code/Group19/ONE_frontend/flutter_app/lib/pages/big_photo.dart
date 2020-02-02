import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:photo_view/photo_view.dart';

class BigPhoto extends StatelessWidget {
  final String _url;
  BigPhoto(this._url);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: PhotoView(
        imageProvider: NetworkImageWithRetry(_url),
        backgroundDecoration: BoxDecoration(color: Colors.black),
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 2,
        basePosition: Alignment.center,
      ),
    );
  }
}
