import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../models/book.dart';

import './book_tile.dart';

class HorizontalDisplay extends StatelessWidget {
  final String title;
  final List<Book> books;
  const HorizontalDisplay({
    Key? key,
    required this.title,
    required this.books,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title
              .split(' ')
              .map((e) => e[0].toUpperCase() + e.substring(1))
              .toList()
              .join(' '),
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: secondaryColor,
          ),
        ),
        const SizedBox(height: 19),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          height: 310,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (ctx, index) {
              return BookTile(
                id: books[index].id,
                imageUrl: books[index].imageUrl,
                title: books[index].title,
                authors: books[index].authors,
              );
            },
          ),
        ),
      ],
    );
  }
}
