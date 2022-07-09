import 'dart:convert';

import '../utils/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/book.dart';

import '../utils/sensitive.dart';

class BooksProvider with ChangeNotifier {
  final Map<String, List<Book>> _books = {
    'autobiographies': [],
    'biographies': [],
    'classics': [],
    'cookbooks': [],
    'essays': [],
    'fantasy': [],
    'historical fiction': [],
    'history': [],
    'horror': [],
    'literary fiction': [],
    'mystery': [],
    'novel': [],
    'poetry': [],
    'romance': [],
    'science fiction': [],
    'self help': [],
    'women fiction': [],
    'action and adventure': [],
  };
  final List<Book> _booksFound = [];

  Map<String, List<Book>> get books {
    return _books;
  }

  List<Book> get booksFound => _booksFound;

  Future<void> getAndSetBooks() async {
    try {
      for (String genre in _books.keys) {
        final Uri uri =
            Uri.parse('''https://books.googleapis.com/books/v1/volumes?
                          fields=totalItems,items(id,volumeInfo/title,volumeInfo/authors,volumeInfo/imageLinks/thumbnail)
                          &q=subject%3A$genre&orderBy=relevance&printType=BOOKS&key=$apiKey''');
        final response = await http.get(uri);
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['totalItems'] > 0) {
          final data = responseBody['items'];
          for (var el in data) {
            final book = Book(
              id: el['id'],
              title: el['volumeInfo']['title'],
              authors: el['volumeInfo']['authors'],
              imageUrl: el['volumeInfo']['imageLinks'] != null
                  ? el['volumeInfo']['imageLinks']['thumbnail']
                  : null,
            );
            _books[genre]!.add(book);
          }
        }
      }
    } catch (_) {
      rethrow;
    }
    notifyListeners();
  }

  Future<Book> fetchBook(String id) async {
    try {
      final Uri uri =
          Uri.parse('''https://books.googleapis.com/books/v1/volumes/$id?
                                    fields=id,volumeInfo/title,volumeInfo/authors,volumeInfo/decription,volumeInfo/averageRating,
                                    volumeInfo/ratingsCount,volumeInfo/imageLinks,volumeInfo/decription/thumbnail,volumeInfo/infoLink,
                                    saleInfo/retailPrice,saleInfo/buyLink
                                    &key=$apiKey''');
      final response = await http.get(uri);
      final Map<String, dynamic> el = json.decode(response.body);
      final book = Book(
        id: el['id'],
        title: el['volumeInfo']['title'],
        authors: el['volumeInfo']['authors'],
        description: el['volumeInfo']['description'],
        rating: el['volumeInfo']['averageRating'] == null ||
                el['volumeInfo']['ratingsCount'] == null
            ? null
            : Rating(
                averageRating: (el['volumeInfo']['averageRating']).toDouble(),
                ratingsCount: el['volumeInfo']['ratingsCount'],
              ),
        imageUrl: el['volumeInfo']['imageLinks'] != null
            ? el['volumeInfo']['imageLinks']['thumbnail']
            : null,
        order: el['saleInfo']['retailPrice'] == null ||
                el['saleInfo']['buyLink'] == null
            ? null
            : Order(
                currencyCode: el['saleInfo']['retailPrice']['currencyCode'] ??
                    'unavailable',
                amount: (el['saleInfo']['retailPrice']['amount']).toDouble(),
                buyLink: el['saleInfo']['buyLink'],
              ),
        linkTo: el['volumeInfo']['infoLink'],
      );
      notifyListeners();
      return book;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> search(SearchType type, String text) async {
    try {
      _booksFound.clear();
      String query = 'intitle:$text';
      if (type == SearchType.genre) {
        query = 'subject:$text';
      }
      if (type == SearchType.author) {
        query = 'inauthor:$text';
      }
      final Uri uri =
          Uri.parse('''https://books.googleapis.com/books/v1/volumes?
                                    fields=totalItems,items(id,volumeInfo/title,volumeInfo/authors,volumeInfo/imageLinks/thumbnail)
                                    &q=$query&orderBy=relevance&printType=BOOKS&key=$apiKey''');
      final response = await http.get(uri);
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['totalItems'] > 0) {
        final data = responseBody['items'];
        for (var el in data) {
          final book = Book(
            id: el['id'],
            title: el['volumeInfo']['title'],
            authors: el['volumeInfo']['authors'],
            imageUrl: el['volumeInfo']['imageLinks'] != null
                ? el['volumeInfo']['imageLinks']['thumbnail']
                : null,
          );
          _booksFound.add(book);
        }
      }
    } catch (_) {
      rethrow;
    }
    notifyListeners();
  }
}
