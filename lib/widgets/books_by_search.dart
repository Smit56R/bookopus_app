import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';
import './book_tile.dart';
import '../providers/books_provider.dart';
import './custom_error_widget.dart';
import './center_loading_widget.dart';
import '../utils/enums.dart';

class BooksBySearch extends StatefulWidget {
  final SearchType searchType;
  final String text;
  const BooksBySearch({Key? key, required this.searchType, required this.text})
      : super(key: key);

  @override
  State<BooksBySearch> createState() => _BooksBySearchState();
}

class _BooksBySearchState extends State<BooksBySearch> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<BooksProvider>(context, listen: false)
            .search(widget.searchType, widget.text),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Expanded(child: CenterLoadingWidget());
          }
          if (snapshot.hasError) {
            return const Expanded(child: CustomErrorWidget());
          }
          final books = Provider.of<BooksProvider>(context).booksFound;
          return Expanded(
            child: books.isEmpty
                ? const Center(
                    child: Text(
                      'No books found!',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: darkGreyColor,
                        fontSize: 16,
                      ),
                    ),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 2,
                    ),
                    itemCount: books.length,
                    itemBuilder: (_, index) {
                      return BookTile(
                        id: books[index].id,
                        title: books[index].title,
                        authors: books[index].authors,
                        imageUrl: books[index].imageUrl,
                      );
                    },
                  ),
          );
        });
  }
}
