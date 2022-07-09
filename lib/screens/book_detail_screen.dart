import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../utils/colors.dart';
import '../models/book.dart';
import '../providers/books_provider.dart';
import '../widgets/center_loading_widget.dart';
import '../widgets/custom_error_widget.dart';

class BookDetailScreen extends StatelessWidget {
  static const routeName = '/book-detail';
  const BookDetailScreen({Key? key}) : super(key: key);

  Widget ratingWidget(double avgRating, int count) {
    final List<Widget> list = [];
    for (int i = 0; i < avgRating.floor(); i++) {
      list.add(
        const Icon(
          Icons.star_rounded,
          color: yellowColor,
        ),
      );
    }
    if (avgRating.ceil() != avgRating.floor()) {
      list.add(
        const Icon(
          Icons.star_half_rounded,
          color: yellowColor,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...list,
        Text(
          avgRating.toString(),
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: secondaryColor,
          ),
        ),
        Text(
          '($count)',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: darkGreyColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    return FutureBuilder(
      future: Provider.of<BooksProvider>(context, listen: false).fetchBook(id),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: CenterLoadingWidget());
        }
        if (snapshot.hasError) {
          return const Scaffold(body: CustomErrorWidget());
        }
        final book = snapshot.data as Book;
        String overview = 'Not available';
        if (book.description != null) {
          final document = parse(book.description);
          overview = parse(document.body!.text).documentElement!.text;
        }
        return Scaffold(
          appBar: AppBar(
            foregroundColor: secondaryColor,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: book.linkTo == null
                    ? null
                    : () async {
                        try {
                          await launchUrlString(book.linkTo!);
                        } catch (_) {}
                      },
                icon: const Icon(Icons.open_in_new),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 221,
                      height: 338,
                      child: book.imageUrl == null
                          ? Image.asset(
                              'assets/images/placeholder_book_cover.png',
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              book.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    book.authors == null ? 'Unknown' : book.authors!.join(', '),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: darkGreyColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (book.rating == null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.star_border_rounded,
                          color: lightGreyColor,
                        ),
                        Text(
                          '0.0',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: secondaryColor,
                          ),
                        ),
                        Text(
                          '(0)',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: darkGreyColor,
                          ),
                        ),
                      ],
                    )
                  else
                    ratingWidget(
                      book.rating!.averageRating,
                      book.rating!.ratingsCount,
                    ),
                  const SizedBox(height: 35),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Overview',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      overview,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: darkGreyColor,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 75),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: SizedBox(
            width: 358,
            height: 55,
            child: ElevatedButton(
              onPressed: book.order == null
                  ? null
                  : () async {
                      try {
                        await launchUrlString(book.order!.buyLink);
                      } catch (_) {}
                    },
              style: ElevatedButton.styleFrom(
                primary: book.order == null ? lightGreyColor : secondaryColor,
                onPrimary: book.order == null ? darkGreyColor : Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 17, horizontal: 34),
              ),
              child: Text(
                book.order == null
                    ? 'Not available to purchase'
                    : 'Buy @ ${book.order!.currencyCode} ${book.order!.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
