import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hefestus/ui/controllers/auth_controller.dart';
import 'package:hefestus/ui/controllers/stream_controller.dart';
import 'package:loggy/loggy.dart';
import '../../data/model/user.dart';

class UserController extends StreamController<AppUserQuerySnapshot> {
  final _users = <String, AppUser>{}.obs;
  final AuthController auth = Get.find();

  RxMap<String, AppUser> get users => _users;

  Iterable<AppUser> get otherUsers => _users.values.where((user) => user.uid != auth.uid);

  AppUser? operator[](String key) => users[key];

  void onReceive(AppUserQuerySnapshot snapshot) {
    for (final doc in snapshot.docChanges) {
      final user = doc.doc.data!;

      switch (doc.type) {
        case DocumentChangeType.added:
          users[user.key] = user;
          break;
        case DocumentChangeType.modified:
          users[user.key] = user;
          break;
        case DocumentChangeType.removed:
          users.remove(user.key);
      }
    }
  }

  @override
  Future<void> start() async {
    if (!active) {
      _users.clear();
      subscription = UserRef.snapshots().listen(onReceive);
    }
  }

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
