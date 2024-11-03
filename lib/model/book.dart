import 'package:hive/hive.dart';
import 'package:class_9_ncert/model/pdfLink.dart';
import 'package:class_9_ncert/utils/utility.dart';
part 'book.g.dart';

@HiveType(typeId: 3)
class Book {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? fullPdfLink;
  @HiveField(3)
  String? image;
  @HiveField(4)
  List<PdfLinks>? pdfLinks;
  @HiveField(5)
  bool? favorite;
  Book(
      {this.id,
      this.name,
      this.fullPdfLink,
      this.image,
      this.pdfLinks,
      this.favorite});

  Book.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fullPdfLink = json['full_pdf_link'];
    image = json['image'];
    if (json['pdf_links'] != null) {
      pdfLinks = <PdfLinks>[];
      json['pdf_links'].forEach((v) {
        pdfLinks!.add(PdfLinks.fromJson(v));
      });
    }
    Book found = Utility()
        .getFavList()
        .firstWhere((e) => e.id == id, orElse: () => Book());
    if (found.id == null) {
      favorite = false;
    } else {
      favorite = true;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['full_pdf_link'] = fullPdfLink;
    data['image'] = image;
    if (pdfLinks != null) {
      data['pdf_links'] = pdfLinks!.map((v) => v.toJson()).toList();
    }
    data['favorite'] = favorite;

    return data;
  }
}
