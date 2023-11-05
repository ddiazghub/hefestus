import 'dart:async';

import 'package:get/get.dart';

abstract class StreamController<T> extends GetxController {
  StreamSubscription<T>? subscription;

  bool get active => subscription != null;

  Future<void> start();

  void stop() {
    subscription?.cancel();
    subscription = null;
  }
}
