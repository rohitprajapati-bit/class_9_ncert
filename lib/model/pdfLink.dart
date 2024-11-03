import 'package:hive/hive.dart';
 part 'pdfLink.g.dart';
@HiveType(typeId: 4)
class PdfLinks {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? link;

  PdfLinks({this.id, this.name, this.link});

  PdfLinks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['link'] = link;
    return data;
  }
}
