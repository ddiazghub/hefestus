import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hefestus/data/model/annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hefestus/data/model/place.dart';
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

  factory StoreUser.fromJson(Map<String, dynamic> json) =>
      _$StoreUserFromJson(json);

  Map<String, dynamic> toJson() => _$StoreUserToJson(this);

  StoreUserData withData(Place place) {
    return StoreUserData(email, place, key: key, uid: uid);
  }
}

class StoreUserData extends BaseUser {
  StoreUserData(
    super.email,
    this.place, {
    required super.key,
    required super.uid,
  });

  final Place place;
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
  });

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
    final credentials =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
    final credentials =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
