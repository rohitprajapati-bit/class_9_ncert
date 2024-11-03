import 'package:hive/hive.dart';
import 'package:class_9_ncert/model/book.dart';
part 'subject.g.dart';
@HiveType(typeId: 2)
class Subjects {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? type;
  @HiveField(2)
  String? icon;
  @HiveField(3)
  List<Book>? book;

  Subjects({this.id, this.type, this.icon, this.book});

  Subjects.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    icon = json['icon'];
    if (json['book'] != null) {
      book = <Book>[];
      json['book'].forEach((v) {
        book!.add(Book.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['icon'] = icon;
    if (book != null) {
      data['book'] = book!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  where(Function(dynamic item) param0) {}
}
