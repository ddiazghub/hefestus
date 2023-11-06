// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map<String, dynamic> json) => Place(
      json['id'] as String,
      Place.nameFromJson(json['displayName'] as Map<String, dynamic>),
      json['formattedAddress'] as String,
      json['businessStatus'] as String,
      json['googleMapsUri'] as String,
      Point.fromJson(json['location'] as Map<String, dynamic>),
      (json['types'] as List<dynamic>).map((e) => e as String).toList(),
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => Photo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

PlaceResponse _$PlaceResponseFromJson(Map<String, dynamic> json) =>
    PlaceResponse(
      places: (json['places'] as List<dynamic>)
          .map((e) => Place.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
