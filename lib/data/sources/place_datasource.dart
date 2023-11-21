import 'package:get/get.dart';
import 'package:hefestus/data/model/place.dart';
import 'package:hefestus/data/model/point.dart';

abstract class BasePlaceDatasource {
  Future<List<Place>> search(Point center);
  Future<Place> getPlace(String id);
  Future<List<PlaceCompletion>> complete(String text, Point center);
  Future<String> getPhoto(String id);
}

class PlaceDatasource extends GetConnect implements BasePlaceDatasource {
  PlaceDatasource(this.apiKey) {
    searchHeaders = {
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask': PlaceSearchRequest.fields(),
    };

    getHeaders = {
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask': PlaceSearchRequest.getFields,
    };
  }

  static const String base = 'https://places.googleapis.com/v1';
  static const String searchUrl = '$base/places:searchNearby';
  static const String completeUrl = '$base/places:searchText';

  final String apiKey;
  late final Map<String, String> searchHeaders;
  late final Map<String, String> getHeaders;

  String detailsUrl(String id) => '$base/places/$id';
  String photosUrl(String id) => '$base/$id/media?key=$apiKey&maxHeightPx=4500&skipHttpRedirect=true';

  @override
  Future<String> getPhoto(String id) async {
    final Response<Map<String, dynamic>> response = await httpClient.get(photosUrl(id));

    return response.body!['photoUri'];
  }

  @override
  Future<List<PlaceCompletion>> complete(String text, Point center) async {
    final body = PlaceCompletionRequest(textQuery: text, center: center).toJson();
    final response = await httpClient.post(completeUrl, body: body, headers: searchHeaders);
    
    return PlaceCompletionResponse.fromJson(response.body).places;
  }

  @override
  Future<List<Place>> search(Point center) async {
    final body = PlaceSearchRequest(center: center).toJson();
    final response = await httpClient.post(searchUrl, body: body, headers: searchHeaders);
    
    return PlaceSearchResponse.fromJson(response.body).places;
  }

  @override
  Future<Place> getPlace(String id) async {
    final response = await httpClient.get(detailsUrl(id), headers: getHeaders);
    
    return Place.fromJson(response.body);
  }
}
