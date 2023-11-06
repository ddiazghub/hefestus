import 'package:hefestus/data/model/photo.dart';
import 'package:hefestus/data/model/point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'place.g.dart';


@JsonSerializable(createToJson: false)
class Place {
  const Place(
    this.id,
    this.displayName,
    this.formattedAddress,
    this.businessStatus,
    this.googleMapsUri,
    this.location,
    this.types, {
    this.photos,
  });

  final String id;
  final String formattedAddress;
  final String businessStatus;
  final String googleMapsUri;
  final Point location;
  final List<Photo>? photos;
  final List<String> types;
  
  @JsonKey(fromJson: nameFromJson)
  final String displayName;

  static String nameFromJson(Map<String, dynamic> json) => json['text'].toString();

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}

@JsonSerializable(explicitToJson: true, createToJson: false)
class PlaceResponse {
  const PlaceResponse({required this.places});

  final List<Place> places;

  factory PlaceResponse.fromJson(Map<String, dynamic> json) => _$PlaceResponseFromJson(json);
}

class PlaceRequest {
  const PlaceRequest({
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
  ];

  static String? _formattedFields;

  static String fields() {
    _formattedFields ??= _fields.map((field) => 'places.$field').join(',');

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
