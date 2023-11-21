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

  AppUser? operator [](String key) => users[key];

  void Function(Snapshot) onReceive<
      Model extends BaseUser,
      DocSnapshot extends FirestoreDocumentSnapshot<Model>,
      Snapshot extends FirestoreQuerySnapshot<Model, DocSnapshot>>(Map<String, Model> map, String Function(Model) key) {
    return (Snapshot snapshot) {
      for (final doc in snapshot.docChanges) {
        final data = doc.doc.data!;

        switch (doc.type) {
          case DocumentChangeType.added:
            map[key(data)] = data;
            break;
          case DocumentChangeType.modified:
            map[key(data)] = data;
            break;
          case DocumentChangeType.removed:
            map.remove(key(data));
        }
      }
    };
  }

  @override
  Future<void> start() async {
    super.start();
    _users.clear();
    _stores.clear();
    subscription = UserRef.snapshots().listen(onReceive(users, (user) => user.uid));
    subscription2 = StoreRef.snapshots().listen(onReceive(stores, (store) => store.place));
  }

  Future<void> create(BaseUser user, bool isUser) async {
    try {
    logInfo('Creating user in realTime');

      isUser
          ? await UserRef.add(user as AppUser)
          : await StoreRef.add(user as StoreUser);
    } catch (error) {
      logInfo('Creating sstore in realtime');
      logError(error);

      return Future.error(error);
    }
  }
}
