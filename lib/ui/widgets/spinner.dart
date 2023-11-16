import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  const Spinner({super.key, this.progress});

  final double? progress;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(value: progress),
      ),
    );
  }
}
