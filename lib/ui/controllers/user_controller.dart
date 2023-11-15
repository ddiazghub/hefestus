import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:get/get.dart';
import 'package:hefestus/ui/controllers/auth_controller.dart';
import 'package:hefestus/ui/controllers/stream_controller.dart';
import 'package:loggy/loggy.dart';
import '../../data/model/user.dart';

class UserController extends MultiStreamController<AppUserQuerySnapshot,
    StoreUserQuerySnapshot> {
  final _users = <String, AppUser>{}.obs;
  final _stores = <String, StoreUser>{}.obs;
  final AuthController auth = Get.find();

  RxMap<String, AppUser> get users => _users;
  RxMap<String, StoreUser> get stores => _stores;

  Iterable<AppUser> get otherUsers =>
      _users.values.where((user) => user.uid != auth.uid);

  AppUser? operator [](String key) => users[key];

  void Function(Snapshot) onReceive<
      Model extends BaseUser,
      DocSnapshot extends FirestoreDocumentSnapshot<Model>,
      Snapshot extends FirestoreQuerySnapshot<Model, DocSnapshot>>(Map<String, Model> map) {
    return (Snapshot snapshot) {
      for (final doc in snapshot.docChanges) {
        final data = doc.doc.data!;

        switch (doc.type) {
          case DocumentChangeType.added:
            map[data.uid] = data;
            break;
          case DocumentChangeType.modified:
            map[data.uid] = data;
            break;
          case DocumentChangeType.removed:
            map.remove(data.uid);
        }
      }
    };
  }

  @override
  Future<void> start() async {
    super.start();
    _users.clear();
    _stores.clear();
    subscription = UserRef.snapshots().listen(onReceive(users));
    subscription2 = StoreRef.snapshots().listen(onReceive(stores));
  }

  Future<void> create(BaseUser user) async {
    logInfo('Creating user in realTime');

    try {
      user.type == UserType.user
          ? await UserRef.add(user as AppUser)
          : await StoreRef.add(user as StoreUser);
    } catch (error) {
      logError(error);

      return Future.error(error);
    }
  }
}
