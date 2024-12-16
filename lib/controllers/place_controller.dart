import 'package:get/get.dart';

class PlaceController extends GetxController {
  // Observable list to keep track of favorite places
  var favorites = <String>[].obs; // Assuming the favorites are identified by a unique string ID.

  // Method to add a place to favorites
  void addFavorite(String id) {
    if (!favorites.contains(id)) {
      favorites.add(id);
    }
  }

  // Method to remove a place from favorites
  void removeFavorite(String id) {
    favorites.remove(id);
  }

  // Method to check if a place is favorite
  bool isFavorite(String id) {
    return favorites.contains(id);
  }
}
