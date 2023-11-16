import 'package:get/get.dart';
import 'package:hefestus/data/model/place.dart';
import 'package:hefestus/data/model/point.dart';

abstract class BasePlaceDatasource {
  Future<List<Place>> search(Point center);
  Future<String> getPhoto(String id);
}

class PlaceDatasource extends GetConnect implements BasePlaceDatasource {
  PlaceDatasource(this.apiKey);

  static const String base = 'https://places.googleapis.com/v1';
  static const String url = '$base/places:searchNearby';
  final String apiKey;

  String photosUrl(String id) => '$base/$id/media?key=$apiKey&maxHeightPx=4500&skipHttpRedirect=true';


  @override
  Future<String> getPhoto(String id) async {
    final Response<Map<String, dynamic>> response = await httpClient.get(photosUrl(id));

    return response.body!['photoUri'];
  }

  @override
  Future<List<Place>> search(Point center) async {
    final headers = {
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask': PlaceRequest.fields(),
    };

    final body = PlaceRequest(center: center).toJson();
    final response = await httpClient.post(url, body: body, headers: headers);
    final places = PlaceResponse.fromJson(response.body).places;

    return places;
  }
}
