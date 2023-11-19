// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map<String, dynamic> json) => Place(
      json['id'] as String,
      nameFromJson(json['displayName'] as Map<String, dynamic>),
      json['formattedAddress'] as String,
      json['googleMapsUri'] as String,
      Point.fromJson(json['location'] as Map<String, dynamic>),
      (json['types'] as List<dynamic>).map((e) => e as String).toList(),
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => Photo.fromJson(e as Map<String, dynamic>))
          .toList(),
      businessStatus:
          $enumDecodeNullable(_$BusinessStatusEnumMap, json['businessStatus']),
      nationalPhoneNumber: json['nationalPhoneNumber'] as String?,
      currentOpeningHours: json['currentOpeningHours'] == null
          ? null
          : OpeningHours.fromJson(
              json['currentOpeningHours'] as Map<String, dynamic>),
      rating: (json['rating'] as num?)?.toDouble(),
      userRatingCount: json['userRatingCount'] as int?,
      websiteUri: Place.uriFromJson(json['websiteUri'] as String?),
    );

const _$BusinessStatusEnumMap = {
  BusinessStatus.operational: 'OPERATIONAL',
  BusinessStatus.closedTemporarily: 'CLOSED_TEMPORARILY',
  BusinessStatus.closedPermanently: 'CLOSED_PERMANENTLY',
};

PlaceCompletion _$PlaceCompletionFromJson(Map<String, dynamic> json) =>
    PlaceCompletion(
      json['id'] as String,
      PlaceCompletion.nameFromJson(json['displayName'] as Map<String, dynamic>),
      json['formattedAddress'] as String,
      Point.fromJson(json['location'] as Map<String, dynamic>),
    );

PlaceSearchResponse _$PlaceSearchResponseFromJson(Map<String, dynamic> json) =>
    PlaceSearchResponse(
      places: (json['places'] as List<dynamic>)
          .map((e) => Place.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

PlaceCompletionResponse _$PlaceCompletionResponseFromJson(
        Map<String, dynamic> json) =>
    PlaceCompletionResponse(
      places: (json['places'] as List<dynamic>)
          .map((e) => PlaceCompletion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

OpeningHours _$OpeningHoursFromJson(Map<String, dynamic> json) => OpeningHours(
      json['openNow'] as bool,
      (json['weekdayDescriptions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
