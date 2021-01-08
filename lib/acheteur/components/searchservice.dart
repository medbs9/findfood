import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_food/constants.dart';

class SearchService {
  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection('Products')
        .where(ksearchindex, isEqualTo: searchField[0].toUpperCase())
        .get();
  }
}
