import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hefestus/data/model/annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hefestus/helpers.dart';
import 'package:hefestus/ui/controllers/user_controller.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum UserType {
  @JsonValue(0)
  user,

  @JsonValue(1)
  store,
}

class BaseUser {
  BaseUser(
    this.email, {
    required this.key,
    required this.uid,
    required this.type,
  });

  @Id()
  final String key;
  final String uid;
  final String email;
  final UserType type;
}

@FirestoreSerializable
class StoreUser extends BaseUser {
  StoreUser(
    super.email,
    this.place, {
    required super.key,
    required super.uid,
  }) : super(type: UserType.store);

  final String place;

  factory StoreUser.fromJson(Map<String, dynamic> json) =>
      _$StoreUserFromJson(json);

  Map<String, dynamic> toJson() => _$StoreUserToJson(this);
}

@FirestoreSerializable
class AppUser extends BaseUser {
  AppUser(
    super.email,
    this.name,
    this.phone,
    this.birthday,
    this.image, {
    required super.key,
    required super.uid,
  }) : super(type: UserType.user);

  final String name;
  final String phone;
  final String image;

  @DateTimeField
  final DateTime birthday;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}

abstract class AuthUser<T extends BaseUser> {
  Future<User> signup();
  T withUid(String uid);
}

class AppAuthUser extends AppUser implements AuthUser<AppUser> {
  AppAuthUser(
    super.email,
    super.name,
    super.phone,
    super.birthday,
    super.image,
    this.password,
  ) : super(key: '', uid: '');

  final String password;

  @override
  AppUser withUid(String uid) => AppUser(
        email,
        name,
        phone,
        birthday,
        image,
        uid: uid,
        key: key,
      );

  @override
  Future<User> signup() async {
      final credentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credentials.user!;
  }
}

class StoreAuthUser extends StoreUser implements AuthUser<StoreUser> {
  StoreAuthUser(
    super.email,
    super.place,
    this.password,
  ) : super(key: '', uid: '');

  final String password;

  @override
  StoreUser withUid(String uid) => StoreUser(
        email,
        place,
        uid: uid,
        key: key,
      );

  @override
  Future<User> signup() async {
      final credentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credentials.user!;
  }
}

@Collection<AppUser>('users')
final UserRef = AppUserCollectionReference();

@Collection<StoreUser>('stores')
final StoreRef = StoreUserCollectionReference();
