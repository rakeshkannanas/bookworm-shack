import 'package:app_and_up/properties/props.dart';
import 'package:app_and_up/provider/books_api_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsScreen extends StatefulWidget {
  static const String routeName = 'DetailsScreen';

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isFav = false;
  int count = 0;
  Map<dynamic, dynamic> arguments;

  Future<void> _addFavorite(Map args) async {
    print('status: ' + isFav.toString());
    if (isFav == false) {
      print('will be added');
      final prefs = await SharedPreferences.getInstance();
      print(prefs.getString('uid'));
      await FirebaseFirestore.instance.collection('favorites').add({
        'data': args,
        'bookId': args['id'],
        'uid': prefs.getString('uid'),
        'fav': 'true'
      });
      setState(() {
        isFav = true;
      });
      _snackBar('Book added to your Favorites', '');
    } else {
      print('will not be added');
      final prefs = await SharedPreferences.getInstance();
      print(prefs.getString('uid'));
      final provider = Provider.of<BooksApiProvider>(context, listen: false);
      await provider.removeFavBooks(args['id']);
      setState(() {
        isFav = false;
      });
      _snackBar('Book removed from your Favorites', '');
    }
  }

  void _snackBar(String textmsg, String actionmsg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(textmsg),
      action: SnackBarAction(
        label: actionmsg,
        onPressed: () {},
      ),
    ));
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (count == 0) {
      arguments = ModalRoute.of(context).settings.arguments as Map;
      if (arguments != null) print(arguments['title']);
      if (arguments['fav'] == 'true')
        isFav = true;
      else
        isFav = false;
      if (Props.FAV == 'true')
        isFav = true;
      else
        isFav = false;
      count = count + 1;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/images/libbg.jpg'),
                fit: BoxFit.cover,
              )),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 7,
                              blurRadius: 10,
                              offset:
                                  Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: arguments['thumbnail'] == '-'
                            ? Image.asset(
                                'assets/images/noimage.jpg',
                                fit: BoxFit.fill,
                                height: 250,
                              )
                            : Image.network(
                                arguments['thumbnail'],
                                fit: BoxFit.fill,
                                height: 250,
                              )),
                  ),
                ),
                Container(
                    height: constraints.biggest.height - 320,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30)),
                      color: Colors.black87.withOpacity(0.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              arguments['title'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            arguments['subtitle'] == '-'
                                ? Container()
                                : SizedBox(
                                    height: 20,
                                  ),
                            arguments['subtitle'] == '-'
                                ? Text(
                                    '',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  )
                                : Text(
                                    arguments['subtitle'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              arguments['description'],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 20,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.pen,
                                  color: Colors.white,
                                  size: 13,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Author',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    arguments['authors']
                                        .toString()
                                        .replaceAll('by ', ''),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.book,
                                  color: Colors.white,
                                  size: 13,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Publisher',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    arguments['publisher'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Category',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  arguments['categories'],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Rating',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  arguments['averageRating'] == 'null'
                                      ? '0'
                                      : arguments['averageRating'],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.dollarSign,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Price',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  arguments['listPrice'],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
            Positioned(
              child: GestureDetector(
                  onTap: () {
                    _addFavorite(arguments);
                  },
                  child: isFav
                      ? FaIcon(
                          FontAwesomeIcons.solidHeart,
                          color: Colors.red,
                        )
                      : FaIcon(
                          FontAwesomeIcons.heart,
                          color: Colors.red,
                        )),
              top: 280,
              right: 30,
            ),
            Positioned(
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.black,
                  )),
              top: 65,
              left: 20,
            ),
          ],
        );
      }),
    );
  }
}
