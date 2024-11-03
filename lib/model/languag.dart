import 'package:hive/hive.dart';
import 'package:class_9_ncert/model/subject.dart';
part 'languag.g.dart';
@HiveType(typeId: 1)
class Language {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  List<Subjects>? subjects;

  Language({this.id, this.name, this.subjects});

  Language.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['subjects'] != null) {
      subjects = <Subjects>[];
      json['subjects'].forEach((v) {
        subjects!.add(Subjects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (subjects != null) {
      data['subjects'] = subjects!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
