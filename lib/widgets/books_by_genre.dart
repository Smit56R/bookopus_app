import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './horizontal_display.dart';
import '../providers/books_provider.dart';
import './custom_error_widget.dart';
import './center_loading_widget.dart';

class BooksByGenre extends StatefulWidget {
  const BooksByGenre({Key? key}) : super(key: key);

  @override
  State<BooksByGenre> createState() => _BooksByGenreState();
}

class _BooksByGenreState extends State<BooksByGenre> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            Provider.of<BooksProvider>(context, listen: false).getAndSetBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Expanded(child: CenterLoadingWidget());
          }
          if (snapshot.hasError) {
            return const Expanded(child: CustomErrorWidget());
          }
          final books = Provider.of<BooksProvider>(context).books;
          return Expanded(
            child: ListView(
              children: books.entries
                  .map(
                    (el) => HorizontalDisplay(
                      title: el.key,
                      books: el.value,
                    ),
                  )
                  .toList(),
            ),
          );
        });
  }
}
