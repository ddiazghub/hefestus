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
