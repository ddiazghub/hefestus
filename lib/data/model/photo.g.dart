// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Photo _$PhotoFromJson(Map<String, dynamic> json) => Photo(
      json['name'] as String,
      json['widthPx'] as int,
      json['heightPx'] as int,
      (json['authorAttributions'] as List<dynamic>)
          .map((e) => AuthorAttribution.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

AuthorAttribution _$AuthorAttributionFromJson(Map<String, dynamic> json) =>
    AuthorAttribution(
      json['displayName'] as String,
      json['uri'] as String,
      json['photoUri'] as String,
    );
