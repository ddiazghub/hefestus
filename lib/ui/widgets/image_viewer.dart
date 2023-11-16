import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hefestus/assets.dart';
import 'package:hefestus/data/model/place.dart';
import 'package:hefestus/ui/widgets/cached_image.dart';
import 'package:hefestus/ui/widgets/snapshot_builder.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final photos = place.photos?.map((photo) => photo.url);

    return photos == null
        ? Image.asset(Assets.fallback, fit: BoxFit.fitHeight)
        : FutureBuilder(
            future: Future.wait(photos),
            builder: (context, snapshot) {
              return SnapshotBuilder(
                snapshot: snapshot,
                builder: (context, photos) {
                  return ScrollConfiguration(
                    behavior: ViewerScrollBehavior(),
                    child: ListView.builder(
                      itemCount: photos.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return CachedImage(
                          url: photos[index],
                          fit: BoxFit.fitHeight,
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
  }
}

class ViewerScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
