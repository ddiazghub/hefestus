import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickController extends GetxController {
  final Rxn<XFile> _image = Rxn();

  XFile? get image => _image.value;

  set image(XFile? value) => _image.value = value;
}
