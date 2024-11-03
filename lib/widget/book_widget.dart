import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:class_9_ncert/model/book.dart';
import 'package:class_9_ncert/utils/constent.dart';
import 'package:class_9_ncert/utils/theme.dart';

class BookWidget extends StatelessWidget {
  final Book book;
  final Function onBookClick;
  final Future<bool?> Function(bool)? onFavTap;
  final bool showfavoriteIcon;
  const BookWidget(
      {super.key,
      required this.book,
      required this.onBookClick,
      this.onFavTap,
      required this.showfavoriteIcon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onBookClick();
        // if (Constant.appConfig?.showAds ?? false) {
        //   showInterstitialAd();
        // }
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => ChepterPage(
        //               pdfList: book.pdfLinks!,
        //               lessonsName: book.name!,
        //             )));
      },
      child: Card(
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            color:AppColor.getBgColor(context),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.maxFinite,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                         child: CachedNetworkImage(
                          imageUrl: '${Constant.Base_Url}${book.image}',
                          placeholder: (context, url) => Container(
                            width: double.maxFinite,
                            height: double.maxFinite,
                            child: Center(
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 15, top: 15, left: 5, right: 5),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        '${book.name}',
                        style:  TextStyle(
                          fontSize: 14,
                          color: AppColor.getTextColor(context),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: showfavoriteIcon,
                child: Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: LikeButton(
                      isLiked: book.favorite ?? false,
                      onTap: onFavTap,
                      // onTap: (isLiked) async {
                      //   // book.favorite = !isLiked;

                      //   // updatedFavouriteList(book);
                      //   // if (isLiked) {
                      //   //   addRemoveFavourite('Removed from favourite');
                      //   // } else {
                      //   //   addRemoveFavourite('Added to favourite');
                      //   // }
                      //   // return book.favorite;
                      // },
                      size: 40,
                      circleColor: const CircleColor(
                          start: Color(0xff00ddff), end: Color(0xff0099cc)),
                      bubblesColor: const BubblesColor(
                        dotPrimaryColor: Color(0xff33b5e5),
                        dotSecondaryColor: Color(0xff0099cc),
                      ),
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          Icons.favorite,
                          color: isLiked ? Colors.red : Colors.grey.shade200,
                          size: 35,
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
