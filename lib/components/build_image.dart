import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BuildImage extends StatelessWidget {
  const BuildImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
  }) : super(key: key);
  final double? width;
  final double? height;
  final String imageUrl;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => Image.asset("assets/images/no-image.jpg"),
      errorWidget: (context, url, error) => Icon(Icons.error),
      width: width,
      height: height,
      fit: fit,
    );
  }
}
