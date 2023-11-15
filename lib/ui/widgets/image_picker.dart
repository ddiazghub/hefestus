import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/ui/pages/login/signup.dart';
import 'package:hefestus/ui/widgets/snapshot_builder.dart';
import 'package:image_picker/image_picker.dart';

class AppImagePicker extends StatelessWidget {
  const AppImagePicker({super.key, required this.picker});

  final ImagePickController picker;

  Future<void> pickAvatar() async {
    picker.image = await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    const InputDecoration(
      labelText: 'Image picker',
      border: OutlineInputBorder(),
      helperText: '',
    );

    return Obx(() {
        return FutureBuilder(
          future: picker.image?.readAsBytes() ?? Future.value(Uint8List(0)),
          builder: (context, snapshot) {
            return SnapshotBuilder(
              snapshot: snapshot,
              builder: (context, bytes) {
                return Container(
                  padding: const EdgeInsets.all(30),
                  height: double.infinity,
                  child: InkWell(
                    onTap: pickAvatar,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(2)),
                        image: bytes.isEmpty
                            ? null
                            : DecorationImage(image: MemoryImage(bytes)),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 50,
                          minHeight: 30,
                        ),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: pickAvatar,
                            child: const Text('Pick Avatar'),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      }
    );
  }
}
