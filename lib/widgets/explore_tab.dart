import 'package:flutter/material.dart';

import '../utils/colors.dart';
import './books_by_genre.dart';
import './books_by_search.dart';
import '../utils/enums.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({Key? key}) : super(key: key);

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  final _searchController = TextEditingController();
  final FocusNode _searchBox = FocusNode();
  bool _showRadioBtns = false;
  bool _showSearchedBooks = false;
  SearchType _searchType = SearchType.title;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _searchBox.dispose();
  }

  Widget radioButton(SearchType value, String label) {
    return Row(
      children: [
        Radio<SearchType>(
          value: value,
          groupValue: _searchType,
          onChanged: (val) => setState(() {
            _searchType = val!;
          }),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: darkGreyColor,
          ),
        ),
      ],
    );
  }

  void _onSubmit() {
    setState(() {
      _showRadioBtns = false;
      _showSearchedBooks = true;
    });
    _searchBox.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome!',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: darkGreyColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'What do you want\nto read today?',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: secondaryColor,
              fontSize: 26,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 17),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TextField(
              controller: _searchController,
              focusNode: _searchBox,
              onSubmitted: (_) => _onSubmit(),
              onChanged: (_) {
                if (!_showRadioBtns) {
                  setState(() {
                    _showRadioBtns = true;
                  });
                }
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Color.fromRGBO(196, 196, 196, 0.15),
                prefixIcon: Icon(Icons.search_rounded),
                hintText: 'Search',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Color.fromRGBO(196, 196, 196, 1),
                ),
              ),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: primaryColor,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            alignment: Alignment.centerRight,
            child: Image.asset(
              'assets/images/powered_by_google_on_white.png',
              height: 15,
            ),
          ),
          if (_showRadioBtns)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                radioButton(SearchType.title, 'By title'),
                radioButton(SearchType.genre, 'By genre'),
                radioButton(SearchType.author, 'By author'),
              ],
            ),
          const SizedBox(height: 34),
          if (_showSearchedBooks)
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => setState(() {
                  _showRadioBtns = false;
                  _showSearchedBooks = false;
                  _searchController.clear();
                }),
                icon: const Icon(
                  Icons.close_rounded,
                  color: darkGreyColor,
                ),
              ),
            ),
          if (_showSearchedBooks)
            BooksBySearch(
              searchType: _searchType,
              text: _searchController.text,
            )
          else
            const BooksByGenre(),
        ],
      ),
    );
  }
}
