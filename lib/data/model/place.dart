import 'package:hefestus/data/model/photo.dart';
import 'package:hefestus/data/model/point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'place.g.dart';

String formatFields(Iterable<String> fields) => fields.map((field) => 'places.$field').join(',');
String nameFromJson(Map<String, dynamic> json) => json['text'].toString();

@JsonSerializable(createToJson: false)
class Place {
  const Place(
    this.id,
    this.displayName,
    this.formattedAddress,
    this.googleMapsUri,
    this.location,
    this.types, {
    this.photos,
    this.businessStatus,
    this.nationalPhoneNumber,
    this.currentOpeningHours,
    this.rating,
    this.userRatingCount,
    this.websiteUri,
  });

  final String id;
  final String formattedAddress;
  final String googleMapsUri;
  final Point location;
  final BusinessStatus? businessStatus;
  final List<Photo>? photos;
  final List<String> types;
  final double? rating;
  final int? userRatingCount;
  final String? nationalPhoneNumber;
  final OpeningHours? currentOpeningHours;

  @JsonKey(fromJson: uriFromJson)
  final Uri? websiteUri;

  @JsonKey(fromJson: nameFromJson)
  final String displayName;

  static Uri? uriFromJson(String? uri) => uri == null ? null : Uri.parse(uri);

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}

@JsonSerializable(createToJson: false)
class PlaceCompletion {
  const PlaceCompletion(
    this.id,
    this.displayName,
    this.formattedAddress,
    this.location,
  );

  final String id;
  final String formattedAddress;
  final Point location;

  @JsonKey(fromJson: nameFromJson)
  final String displayName;

  static String nameFromJson(Map<String, dynamic> json) => json['text'].toString();

  factory PlaceCompletion.fromJson(Map<String, dynamic> json) => _$PlaceCompletionFromJson(json);
}

@JsonSerializable(explicitToJson: true, createToJson: false)
class PlaceSearchResponse {
  const PlaceSearchResponse({required this.places});

  final List<Place> places;

  factory PlaceSearchResponse.fromJson(Map<String, dynamic> json) => _$PlaceSearchResponseFromJson(json);
}

class PlaceSearchRequest {
  const PlaceSearchRequest({
    required this.center,
    this.includedTypes = const ['hardware_store'],
    this.maxResultCount = 20,
    this.radius = 3000,
    this.rankPreference = 'DISTANCE',
  });

  final List<String> includedTypes;
  final int maxResultCount;
  final double radius;
  final Point center;
  final String rankPreference;

  static const _fields = [
    'id',
    'displayName',
    'formattedAddress',
    'businessStatus',
    'googleMapsUri',
    'iconBackgroundColor',
    'iconMaskBaseUri',
    'location',
    'photos',
    'types',
    'rating',
    'userRatingCount',
    'nationalPhoneNumber',
    'currentOpeningHours',
    'websiteUri',
  ];

  static String? _formattedFields;

  static String fields() {
    _formattedFields ??= formatFields(_fields);

    return _formattedFields!;
  }

  Map<String, dynamic> toJson() {
    return {
      'includedTypes': includedTypes,
      'maxResultCount': maxResultCount,
      'rankPreference': rankPreference,
      'locationRestriction': {
        'circle': {
          'center': center.toJson(),
          'radius': radius,
        },
      },
    };
  }
}

@JsonSerializable(explicitToJson: true, createToJson: false)
class PlaceCompletionResponse {
  const PlaceCompletionResponse({required this.places});

  final List<PlaceCompletion> places;

  factory PlaceCompletionResponse.fromJson(Map<String, dynamic> json) => _$PlaceCompletionResponseFromJson(json);
}

class PlaceCompletionRequest {
  const PlaceCompletionRequest({
    required this.textQuery,
    required this.center,
    this.includedType = 'hardware_store',
    this.maxResultCount = 20,
    this.strictTypeFiltering = true,
    this.radius = 50000,
    this.rankPreference = 'DISTANCE',
  });

  final String textQuery;
  final String includedType;
  final int maxResultCount;
  final double radius;
  final Point center;
  final bool strictTypeFiltering;
  final String rankPreference;

  static const _fields = [
    'id',
    'displayName',
    'formattedAddress',
    'location',
  ];

  static String? _formattedFields;

  static String fields() {
    _formattedFields ??= formatFields(_fields);

    return _formattedFields!;
  }

  Map<String, dynamic> toJson() {
    return {
      'textQuery': textQuery,
      'includedType': includedType,
      'maxResultCount': maxResultCount,
      'rankPreference': rankPreference,
      'strictTypeFiltering': strictTypeFiltering,
      'locationBias': {
        'circle': {
          'center': center.toJson(),
          'radius': radius,
        },
      },
    };
  }
}

enum BusinessStatus {
  @JsonValue('OPERATIONAL')
  operational,

  @JsonValue('CLOSED_TEMPORARILY')
  closedTemporarily,

  @JsonValue('CLOSED_PERMANENTLY')
  closedPermanently;
}

@JsonSerializable(createToJson: false)
class OpeningHours {
  OpeningHours(this.openNow, this.weekdayDescriptions);

  final bool openNow;
  final List<String> weekdayDescriptions;

  factory OpeningHours.fromJson(Map<String, dynamic> json) => _$OpeningHoursFromJson(json);
}
