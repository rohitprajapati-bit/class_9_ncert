import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:class_9_ncert/model/subject.dart';
import 'package:class_9_ncert/pages/subject_page.dart';
import 'package:class_9_ncert/utils/constent.dart';
import 'package:class_9_ncert/utils/theme.dart';

class CategoriesWidget extends StatelessWidget {
  final List<Subjects> foundSubjects;
  final Function showInterstitialAd;
  const CategoriesWidget(
      {super.key,
      required this.foundSubjects,
      required this.showInterstitialAd});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: foundSubjects.isEmpty
          ? Center(
              
              child: Image.asset(
              "assets/images/not_found_2.png",
              height: 300,
            )
              )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                itemCount: foundSubjects.length,
                itemBuilder: (context, index) {
                  Subjects subjects = foundSubjects[index];

                  return InkWell(
                    onTap: () {
                      Constant.adsCount++;
                      if ((Constant.appConfig?.showAds ?? false) &&
                          (Constant.adsCount % 2 == 0)) {
                        showInterstitialAd();
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubjectPage(
                                    bookList: subjects.book!,
                                    subjectName: subjects.type!,
                                  )));
                    },
                    child: Card(
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.getBgColor(context),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              '${subjects.icon}',
                              fit: BoxFit.contain,
                              height: 35,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Text(
                                '${subjects.type}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColor.getTextColor(context),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
