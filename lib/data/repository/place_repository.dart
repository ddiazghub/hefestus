import 'package:hefestus/data/model/place.dart';
import 'package:hefestus/data/model/point.dart';
import 'package:hefestus/data/sources/place_datasource.dart';

class PlaceRepository {
  PlaceRepository(this.source);

  final BasePlaceDatasource source;

  Future<List<Place>> search(Point center) => source.search(center);
  Future<List<PlaceCompletion>> complete(String text, Point center) => source.complete(text, center);
  Future<String> getPhoto(String id) => source.getPhoto(id);
}
