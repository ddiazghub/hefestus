import 'dart:async';
import 'package:hefestus/ui/controllers/authentication_controller.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import '../../data/model/user.dart';

class UserController extends GetxController {
  final _users = <AppUser>[].obs;

  late StreamSubscription<AppUserQuerySnapshot> subscription;

  get users {
    final auth = Get.find<AuthController>();

    return _users.where((entry) => entry.uid != auth.uid).toList();
  }

  get all => _users;

  void start() {
    _users.clear();

    subscription = UserRef.snapshots().listen((snapshot) {
      _users.value = [for (final doc in snapshot.docs) doc.data];
    });
  }

  Future<void> stop() async => await subscription.cancel();

  Future<void> create(AppUser user) async {
    logInfo('Creating user in realTime');

    try {
      await UserRef.add(user);
    } catch (error) {
      logError(error);

      return Future.error(error);
    }
  }
}
