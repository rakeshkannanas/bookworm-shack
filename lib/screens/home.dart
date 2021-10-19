import 'dart:async';
import 'package:app_and_up/properties/props.dart';
import 'package:app_and_up/provider/books_api_provider.dart';
import 'package:app_and_up/screens/detailsscreen.dart';
import 'package:app_and_up/screens/favoritescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  static const String routeName = 'Home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _searchBookValue;
  List<dynamic> finalList = [];
  bool isLoading = false;
  bool isLoadingList = false;
  bool isFav;
  StreamSubscription<QuerySnapshot> streamSub;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await this._asyncMethod();
      setState(() {});
    });
  }

  Future<void> _asyncMethod() async {
    final provider = Provider.of<BooksApiProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    await provider.getBooks('Thriller');

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    streamSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final bookListData = Provider.of<BooksApiProvider>(context, listen: true);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          elevation: 2.0,
          child: Icon(
            Icons.bookmark_outlined,
            color: Colors.yellowAccent,
          ),
          backgroundColor: new Color(0xFFE57373),
          onPressed: () {
            Navigator.of(context).pushNamed(FavoriteScreen.routeName);
          }),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                  child: Text(
                    'Explore thousands of books \non the go',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        letterSpacing: 1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Container(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: FaIcon(
                            FontAwesomeIcons.search,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          child: Align(
                            alignment: Alignment.center,
                            child: TextFormField(
                              style: TextStyle(fontSize: 15),
                              onChanged: (value) async {
                                print(value);
                                if (value.length > 3) {
                                  setState(() {
                                    isLoadingList = true;
                                  });
                                  await bookListData.getBooks(value.trim());
                                  setState(() {
                                    isLoadingList = false;
                                  });
                                }
                                if (value.length == 0) {
                                  {
                                    setState(() {
                                      isLoadingList = true;
                                    });
                                    await bookListData.getBooks('thriller');
                                    setState(() {
                                      isLoadingList = false;
                                    });
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  labelStyle: TextStyle(color: Colors.grey),
                                  labelText: 'Search for books...',
                                  border: InputBorder.none,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never),
                              onSaved: (value) {
                                _searchBookValue = value;
                              },
                              textAlignVertical: TextAlignVertical.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    height: 60,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                  child: Text(
                    'Famous Books',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        letterSpacing: 1),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              isFav = false;
                              bookListData.checkFav(
                                  bookListData.getFinalBookList[index].id);
                              print('before '+Props.FAV);
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                    print('after '+Props.FAV);
                                if (Props.FAV == 'true')
                                  isFav = true;
                                else
                                  isFav = false;
                                Navigator.of(context).pushNamed(
                                    DetailsScreen.routeName,
                                    arguments: {
                                      'id': bookListData
                                          .getFinalBookList[index].id,
                                      'title': bookListData
                                          .getFinalBookList[index].title,
                                      'subtitle': bookListData
                                          .getFinalBookList[index].subtitle,
                                      'authors': bookListData
                                          .getFinalBookList[index].authors,
                                      'publisher': bookListData
                                          .getFinalBookList[index].publisher,
                                      'description': bookListData
                                          .getFinalBookList[index].description,
                                      'categories': bookListData
                                          .getFinalBookList[index].categories,
                                      'averageRating': bookListData
                                          .getFinalBookList[index]
                                          .averageRating,
                                      'thumbnail': bookListData
                                          .getFinalBookList[index].thumbnail,
                                      'listPrice': bookListData
                                          .getFinalBookList[index].listPrice,
                                      'fav': isFav.toString(),
                                    });
                              });
                            },
                            child: Container(
                                margin: EdgeInsets.fromLTRB(20, 30, 20, 5),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 15,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 10, 0),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    child: bookListData
                                                                .getFinalBookList[
                                                                    index]
                                                                .thumbnail ==
                                                            '-'
                                                        ? Image.asset(
                                                            'assets/images/noimage.jpg',
                                                            height: 180,
                                                            width: 120,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.network(
                                                            bookListData
                                                                .getFinalBookList[
                                                                    index]
                                                                .thumbnail,
                                                            height: 180,
                                                            width: 120,
                                                            fit: BoxFit.cover,
                                                          )),
                                              )),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    180,
                                                child: Text(
                                                  bookListData
                                                      .getFinalBookList[index]
                                                      .authors,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 13),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    180,
                                                child: Text(
                                                  bookListData
                                                      .getFinalBookList[index]
                                                      .title
                                                      .trim(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    color: Color(0xFFFFD700),
                                                    size: 13,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    bookListData
                                                                .getFinalBookList[
                                                                    index]
                                                                .averageRating ==
                                                            'null'
                                                        ? '0'
                                                        : bookListData
                                                            .getFinalBookList[
                                                                index]
                                                            .averageRating,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Color(0xFF4a3d3ff),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 5, 20, 5),
                                                  child: Text(
                                                    bookListData
                                                        .getFinalBookList[index]
                                                        .categories,
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                        itemCount: bookListData.getFinalBookList.length,
                      ),
                      if (isLoadingList)
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

  void delay() {}
}
