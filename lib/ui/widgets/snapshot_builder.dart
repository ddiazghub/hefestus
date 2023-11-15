import 'package:flutter/material.dart';
import 'package:hefestus/ui/widgets/spinner.dart';

typedef BuilderFunction<T> = Widget Function(BuildContext, T);

class SnapshotBuilder<T> extends StatelessWidget {
  const SnapshotBuilder({
    super.key,
    required this.snapshot,
    required this.builder,
  });

  final AsyncSnapshot<T> snapshot;
  final BuilderFunction<T> builder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasError) {
      return Center(child: Text('$snapshot.error'));
    } else if (!snapshot.hasData) {
      return const Spinner();
    }

    return builder(context, snapshot.data as T);
  }
}
