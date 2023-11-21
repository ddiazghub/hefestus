import 'package:hefestus/data/model/user.dart';
import 'package:hefestus/data/repository/place_repository.dart';
import 'package:hefestus/ui/controllers/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final PlaceRepository placeRepo = Get.find();

  final RxBool _isUser = true.obs;
  AppUser? _userData;
  StoreUserData? _storeData;

  User? get user => FirebaseAuth.instance.currentUser;
  String? get email => user?.email;
  String? get uid => user?.uid;
  bool get isUser => _isUser.value;
  AppUser? get userData => _userData;
  StoreUserData? get storeData => _storeData;

  Future<void> getUserData() async {
    final user = this.user;
    final userController = Get.find<UserController>();

    _userData = userController.users[user!.uid];
    final StoreUser? partialStoreData =
        userController.stores[user.uid];

    if (_userData != null) {
      _isUser.value = true;
    } else {
      _isUser.value = false;
      _storeData = partialStoreData!.withData(
        await placeRepo.getPlace(partialStoreData.place),
      );
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await getUserData();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Future.error('User not found');
      } else if (e.code == 'wrong-password') {
        return Future.error('Wrong password');
      }
    }
  }

  Future<void> signup(AuthUser user, bool isUser) async {
    try {
      final credentials = await user.signup();
      UserController controller = Get.find();
      await controller.create(user.withUid(credentials.uid), isUser);
      await getUserData();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Future.error('The password is too weak');
      } else if (e.code == 'email-already-in-use') {
        return Future.error('The email is taken');
      }
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      return Future.error('Logout error');
    }
  }
}
