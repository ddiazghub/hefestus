import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:hefestus/data/model/annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hefestus/helpers.dart';

part 'user.g.dart';

class BaseUser {
  BaseUser(
    this.email, {
    required this.key,
    required this.uid,
  });

  @Id()
  final String key;
  final String uid;
  final String email;
}

@FirestoreSerializable
class StoreUser extends BaseUser {
  StoreUser(
    super.email,
    this.place, {
    required super.key,
    required super.uid,
  });

  final String place;

  factory StoreUser.fromJson(Map<String, dynamic> json) => _$StoreUserFromJson(json);

  Map<String, dynamic> toJson() => _$StoreUserToJson(this);
}

@FirestoreSerializable
class AppUser extends BaseUser {
  AppUser(
    super.email,
    this.name,
    this.phone,
    this.birthday, {
    required super.key,
    required super.uid,
  });

  final String name;
  final String phone;

  @DateTimeField
  final DateTime birthday;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}

class AuthUser extends AppUser {
  AuthUser(
    super.email,
    super.name,
    super.phone,
    super.birthday,
    this.password,
  ) : super(key: '', uid: '');

  final String password;

  AppUser withUid(String uid) => AppUser(email, name, phone, birthday, uid: uid, key: key);
}

@Collection<AppUser>('users')
final UserRef = AppUserCollectionReference();
