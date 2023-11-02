import 'package:hefestus/data/model/user.dart';
import 'package:hefestus/ui/controllers/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  User? get user => FirebaseAuth.instance.currentUser;
  String? get email => user?.email;
  String? get uid => user?.uid;

  Future<void> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Future.error('User not found');
      } else if (e.code == 'wrong-password') {
        return Future.error('Wrong password');
      }
    }
  }

  Future<void> signup(AuthUser user) async {
    try {
      final credentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      UserController controller = Get.find();
      await controller.create(user.withUid(credentials.user!.uid));
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
