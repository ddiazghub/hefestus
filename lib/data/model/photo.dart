import 'package:get/get.dart';
import 'package:hefestus/data/repository/place_repository.dart';
import 'package:json_annotation/json_annotation.dart';

part 'photo.g.dart';

@JsonSerializable(createToJson: false)
class Photo {
  Photo(this.name, this.widthPx, this.heightPx);

  final String name;
  final int widthPx;
  final int heightPx;
  String? _url;

  Future<String> get url async {
    _url ??= await Get.find<PlaceRepository>().getPhoto(name);

    return _url!;
  }

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
}
