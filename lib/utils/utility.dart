import 'package:hive/hive.dart';
import 'package:class_9_ncert/model/book.dart';

class Utility {
  List<Book> getFavList() {
    // await Hive.openBox<List<Book>>('favoriteList');
    Box<Book> bookBox = Hive.box<Book>('favoriteList');
    List<Book> storedList = bookBox.values.toList();
    return storedList.reversed.toList();
  }
}
