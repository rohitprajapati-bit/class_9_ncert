import 'package:hive/hive.dart';
import 'package:class_9_ncert/model/languag.dart';
import 'package:class_9_ncert/model/subject.dart';
part 'ncert.g.dart';

@HiveType(typeId: 0)
class Ncert {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? stg;
  @HiveField(2)
  String? name;
  @HiveField(3)
  List<Language>? language;

  Ncert({this.id, this.stg, this.name, this.language});

  Ncert.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stg = json['stg'];
    name = json['name'];
    if (json['language'] != null) {
      language = <Language>[];
      json['language'].forEach((v) {
        language!.add(Language.fromJson(v));
      });
      
    }
  }

  getAllSubject() {
    List<Subjects>? allSubject = [];
    allSubject.addAll(language![0].subjects!.toList());
    allSubject.addAll(language![1].subjects!.toList());
    allSubject.sort((a, b) => a.type!.compareTo(b.type!));
    return allSubject;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['stg'] = stg;
    data['name'] = name;
    if (language != null) {
      data['language'] = language!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
