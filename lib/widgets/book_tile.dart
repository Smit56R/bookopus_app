import 'package:flutter/material.dart';

import '../utils/colors.dart';

import '../screens/book_detail_screen.dart';

class BookTile extends StatelessWidget {
  final String id;
  final String? imageUrl;
  final String title;
  final List<dynamic>? authors;
  const BookTile({
    Key? key,
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.authors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        BookDetailScreen.routeName,
        arguments: id,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 17.5),
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: 160,
                height: 250,
                child: imageUrl == null
                    ? Image.asset(
                        'assets/images/placeholder_book_cover.png',
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: secondaryColor,
              ),
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 1),
            Text(
              authors == null ? 'unknown' : authors!.join(', '),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: darkGreyColor,
              ),
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
