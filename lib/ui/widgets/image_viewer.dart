import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hefestus/ui/widgets/spinner.dart';

class ReloadImage extends StatelessWidget {
  const ReloadImage({super.key, required this.state});

  final ExtendedImageState state;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset('assets/failed.jpg', fit: BoxFit.fill),
          const Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Text(
              'load image failed, click to reload',
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
      onTap: () => state.reLoadImage(),
    );
  }
}

Widget imageLoadHandler(ExtendedImageState state) {
  return switch (state.extendedImageLoadState) {
    LoadState.loading => const Spinner(),
    LoadState.failed => ReloadImage(state: state),
    LoadState.completed => state.completedWidget,
  };
}
