import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hefestus/ui/widgets/spinner.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({super.key, required this.url, this.fit});

  final String url;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {

    if (kIsWeb) {
      return Image.network(
        url,
        fit: fit,
      );
    } else {
      return CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        progressIndicatorBuilder: (context, url, progress) =>
            Spinner(progress: progress.progress),
      );
    }
  }
}
