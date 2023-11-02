import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:hefestus/data/model/annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user.g.dart';

@FirestoreSerializable
class AppUser {
  AppUser(this.email, {required this.key, required uid});

  @Id()
  final String key;
  late final String uid;
  final String email;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}

class AuthUser extends AppUser {
  AuthUser(super.email, this.password) : super(key: '', uid: '');
  
  AppUser withUid(String uid) => AppUser(email, uid: uid, key: key);

  final String password;
}

@Collection<AppUser>('users')
final UserRef = AppUserCollectionReference();
