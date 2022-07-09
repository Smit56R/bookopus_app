import 'package:flutter/material.dart';

import '../utils/colors.dart';

class CustomNavigationBar extends StatelessWidget {
  final Function onTap;
  final int page;
  const CustomNavigationBar({Key? key, required this.onTap, required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(80),
        topRight: Radius.circular(80),
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
      child: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 20,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              page == 0 ? Icons.home : Icons.home_outlined,
              color: page == 0 ? primaryColor : lightGreyColor,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              page == 1 ? Icons.favorite : Icons.favorite_border,
              color: page == 1 ? primaryColor : lightGreyColor,
            ),
            label: '',
          ),
        ],
        onTap: (value) => onTap(value),
      ),
    );
  }
}
