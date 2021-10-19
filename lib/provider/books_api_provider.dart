import 'dart:async';
import 'dart:convert';
import 'package:app_and_up/properties/props.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BooksApiProvider extends ChangeNotifier {
  List<BookList> _finalList = [];

  List<BookList> get getFinalBookList {
    return [..._finalList];
  }

  List<BookList> _finalFavList = [];

  List<BookList> get getFinalFavBookList {
    return [..._finalFavList];
  }

  Future<void> getBooks(String key) async {
    String uri = Props.getBooks.toString() + key;
    final value = await http.get(Uri.parse(uri));
    List<dynamic> originalList = json.decode(value.body)['items'];
    List<BookList> parsingList = [];

    for (int i = 0; i < originalList.length; i++) {
      parsingList.add(BookList(
        id: originalList[i]['id'] == null ? '-' : originalList[i]['id'],
        title: originalList[i]['volumeInfo']['title'] == null
            ? '-'
            : originalList[i]['volumeInfo']['title'],
        subtitle: originalList[i]['volumeInfo']['subtitle'] == null
            ? '-'
            : originalList[i]['volumeInfo']['subtitle'],
        authors: originalList[i]['volumeInfo']['authors'] == null
            ? '-'
            : 'by ' + originalList[i]['volumeInfo']['authors'][0],
        publisher: originalList[i]['volumeInfo']['publisher'] == null
            ? '-'
            : originalList[i]['volumeInfo']['publisher'],
        description: originalList[i]['volumeInfo']['description'] == null
            ? '-'
            : originalList[i]['volumeInfo']['description'],
        categories: originalList[i]['volumeInfo']['categories'] == null
            ? '-'
            : originalList[i]['volumeInfo']['categories'][0],
        averageRating:
            originalList[i]['volumeInfo']['averageRating'].toString() == null
                ? '-'
                : originalList[i]['volumeInfo']['averageRating'].toString(),
        thumbnail: originalList[i]['volumeInfo']['imageLinks'] == null
            ? '-'
            : originalList[i]['volumeInfo']['imageLinks']['thumbnail'],
        listPrice:
            originalList[i]['saleInfo']['saleability'].toString().trim() ==
                    "FOR_SALE"
                ? originalList[i]['saleInfo']['listPrice']['amount'].toString()
                : 'Not For Sale',
      ));
    }
    print(parsingList.toString());
    _finalList = parsingList.toList();
    notifyListeners();
  }

  Future<void> getFavBooks() async {
    final prefs = await SharedPreferences.getInstance();
    List<BookList> parsingFavList = [];

    var _firebaseRef =
        FirebaseFirestore.instance.collection('favorites').snapshots();
    _firebaseRef.listen((data) {
      _finalFavList = [];
      data.docs.forEach((document) {
        if (prefs.getString('uid') == document['uid']) {
          parsingFavList.add(BookList(
            id: document['data']['id'],
            title: document['data']['title'],
            subtitle: document['data']['subtitle'],
            authors: 'by ' + document['data']['authors'],
            publisher: document['data']['publisher'],
            description: document['data']['description'],
            categories: document['data']['categories'],
            averageRating: document['data']['averageRating'].toString(),
            thumbnail: document['data']['thumbnail'],
            listPrice: document['data']['listPrice'],
          ));
        }
      });
      print('getFavBooks ' + parsingFavList.toString());
      _finalFavList = parsingFavList.toList();
      notifyListeners();
    });
    _firebaseRef = null;
  }

  Future<void> checkFav(String id) async {
    final prefs = await SharedPreferences.getInstance();
    // bool flag  = false;
    // var _firebaseRef = FirebaseFirestore.instance.collection('favorites').snapshots();
    //
    //  _firebaseRef.listen((data) {
    //   if (data.docs.length == 0) Props.FAV = 'false';
    //   data.docs.forEach((document) {
    //     if (prefs.getString('uid') == document['uid']) {
    //       if (document['bookId'] == id) {
    //         flag = true;
    //         print(flag);
    //         Props.FAV = 'true';
    //       } else {
    //         flag = false;
    //         print(flag);
    //         Props.FAV = 'false';
    //       }
    //     } else {
    //       flag = false;
    //       print(flag);
    //       Props.FAV = 'false';
    //     }
    //   });
    // });

    FirebaseFirestore.instance.collection("favorites").get().then((data) {
      Props.FAV='false';
      if (data.docs.length == 0)
        {Props.FAV = 'false';
          print('inside data length check '+data.docs.length.toString());
        }
      else {
        data.docs.forEach((document) {
          if (prefs.getString('uid') == document['uid']) {
            print('user matched');
            if (document['bookId'] == id) {
              print('book id matched');
              Props.FAV = 'true';
            }
          }
        });
      }
    });
  }

  Future<void> removeFavBooks(String id) async {
    final prefs = await SharedPreferences.getInstance();

    FirebaseFirestore.instance.collection("favorites").get().then((data) {
      data.docs.forEach((document) {
        print('removeFavBooks ' + prefs.getString('uid'));
        print('removeFavBooks ' + document['uid']);
        if (prefs.getString('uid') == document['uid']) {
          if (document['bookId'] == id) {
            final collection =
                FirebaseFirestore.instance.collection('favorites');
            collection
                .doc(document.id) // <-- Doc ID to be deleted.
                .delete() // <-- Delete
                .then((_) => print('Deleted'))
                .catchError((error) => print('Delete failed: $error'));
          }
        }
      });
    });
  }
}

class BookList {
  final String id;
  final String title;
  final String subtitle;
  final String authors;
  final String publisher;
  final String description;
  final String categories;
  final String averageRating;
  final String thumbnail;
  final String listPrice;

  BookList(
      {this.id,
      this.title,
      this.subtitle,
      this.authors,
      this.publisher,
      this.description,
      this.categories,
      this.averageRating,
      this.thumbnail,
      this.listPrice});
}
