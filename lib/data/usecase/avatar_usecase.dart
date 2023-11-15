import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AvatarUsecase extends GetxService {
  static final storage = FirebaseStorage.instance.ref().child('avatars');

  static const defaultAvatar =  'https://firebasestorage.googleapis.com/v0/b/scheduler-96041.appspot.com/o/avatars%2FPortrait_Placeholder.png?alt=media&token=65412e11-1ad5-4120-bd8d-7d1748af3b95';

  static Future<String> create(XFile avatar) async {
    final ref = storage.child(avatar.name);

    await ref.putData(
      await avatar.readAsBytes(),
      SettableMetadata(contentType: avatar.mimeType),
    );

    final url = await ref.getDownloadURL();

    return url;
  }
}
