import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

abstract class StreamController<T> extends GetxController {
  StreamSubscription<T>? subscription;

  bool get active => subscription != null;

  @mustCallSuper
  Future<void> start() async => stop();

  void stop() {
    subscription?.cancel();
    subscription = null;
  }
}

abstract class MultiStreamController<T, E> extends StreamController<T> {
  StreamSubscription<E>? subscription2;

  @mustCallSuper
  Future<void> start() async => stop();

  @override
  void stop() {
    subscription?.cancel();
    subscription2?.cancel();
    subscription = null;
    subscription2 = null;
  }
}
