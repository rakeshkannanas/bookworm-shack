import 'package:app_and_up/properties/props.dart';
import 'package:app_and_up/provider/books_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'detailsscreen.dart';

class FavoriteScreen extends StatefulWidget {
  static const routeName = 'FavoriteScreen';

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await this._asyncMethod();
      setState(() {});
    });
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  Future<void> _asyncMethod() async {
    final provider = Provider.of<BooksApiProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    await provider.getFavBooks();
    print('getFavBooks ');
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookListData = Provider.of<BooksApiProvider>(context, listen: true);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                    child: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                  child: Text(
                    'Your \nFavorites',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        letterSpacing: 1),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      bookListData.getFinalFavBookList.length == 0
                          ? Center(
                              child: Column(
                                children: [
                                  Container(
                                    child: Lottie.asset(
                                        'assets/images/nofav.json',
                                        height: 200,
                                        width: 200),
                                  ),
                                  Text(
                                    'No Favorites Found',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Props.FAV = 'true';
                                    Navigator.of(context).pushNamed(
                                        DetailsScreen.routeName,
                                        arguments: {
                                          'id': bookListData
                                              .getFinalFavBookList[index].id,
                                          'title': bookListData
                                              .getFinalFavBookList[index].title,
                                          'subtitle': bookListData
                                              .getFinalFavBookList[index]
                                              .subtitle,
                                          'authors': bookListData
                                              .getFinalFavBookList[index]
                                              .authors,
                                          'publisher': bookListData
                                              .getFinalFavBookList[index]
                                              .publisher,
                                          'description': bookListData
                                              .getFinalFavBookList[index]
                                              .description,
                                          'categories': bookListData
                                              .getFinalFavBookList[index]
                                              .categories,
                                          'averageRating': bookListData
                                              .getFinalFavBookList[index]
                                              .averageRating,
                                          'thumbnail': bookListData
                                              .getFinalFavBookList[index]
                                              .thumbnail,
                                          'listPrice': bookListData
                                              .getFinalFavBookList[index]
                                              .listPrice,
                                          'fav': 'true',
                                        }).then((value) {
                                      setState(() {
                                        print('refresh');
                                        _asyncMethod();
                                      });
                                    });
                                  },
                                  child: Container(
                                      margin:
                                          EdgeInsets.fromLTRB(20, 30, 20, 5),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 15,
                                            offset: Offset(0,
                                                0), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 200,
                                            width: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 10, 0),
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child: bookListData
                                                                      .getFinalFavBookList[
                                                                          index]
                                                                      .thumbnail ==
                                                                  '-'
                                                              ? Image.asset(
                                                                  'assets/images/noimage.jpg',
                                                                  height: 180,
                                                                  width: 120,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Image.network(
                                                                  bookListData
                                                                      .getFinalFavBookList[
                                                                          index]
                                                                      .thumbnail,
                                                                  height: 180,
                                                                  width: 120,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )),
                                                    )),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              180,
                                                      child: Text(
                                                        bookListData
                                                            .getFinalFavBookList[
                                                                index]
                                                            .authors,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 13),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              180,
                                                      child: Text(
                                                        bookListData
                                                            .getFinalFavBookList[
                                                                index]
                                                            .title
                                                            .trim(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.star,
                                                          color:
                                                              Color(0xFFFFD700),
                                                          size: 13,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          bookListData
                                                                      .getFinalFavBookList[
                                                                          index]
                                                                      .averageRating ==
                                                                  'null'
                                                              ? '0'
                                                              : bookListData
                                                                  .getFinalFavBookList[
                                                                      index]
                                                                  .averageRating,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Color(
                                                              0xFF4a3d3ff),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                20, 5, 20, 5),
                                                        child: Text(
                                                          bookListData
                                                              .getFinalFavBookList[
                                                                  index]
                                                              .categories,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                );
                              },
                              itemCount:
                                  bookListData.getFinalFavBookList.length,
                            ),
                    ],
                  ),
                ),
              ],
            ),
            if (isLoading)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black54,
                child: SpinKitFadingFour(
                  color: Colors.white,
                  size: 40.0,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
