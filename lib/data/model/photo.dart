import 'package:json_annotation/json_annotation.dart';

part 'photo.g.dart';

@JsonSerializable(createToJson: false)
class Photo {
  const Photo(this.name, this.widthPx, this.heightPx, this.authorAttributions);

  final String name;
  final int widthPx;
  final int heightPx;
  final List<AuthorAttribution> authorAttributions;

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
}

@JsonSerializable(createToJson: false)
class AuthorAttribution {
  const AuthorAttribution(this.displayName, this.uri, this.photoUri);

  final String displayName;
  final String uri;
  final String photoUri;

  factory AuthorAttribution.fromJson(Map<String, dynamic> json) => _$AuthorAttributionFromJson(json);
}
