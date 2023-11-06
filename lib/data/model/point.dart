import 'package:json_annotation/json_annotation.dart';

part 'point.g.dart';

@JsonSerializable()
class Point {
  const Point(this.latitude, this.longitude);

  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() => _$PointToJson(this);
  factory Point.fromJson(Map<String, dynamic> json) => _$PointFromJson(json);
}
