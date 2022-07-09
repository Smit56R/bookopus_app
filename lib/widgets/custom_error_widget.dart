import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Something went wrong!',
        style: TextStyle(
          fontFamily: 'Poppins',
          color: darkGreyColor,
          fontSize: 16,
        ),
      ),
    );
  }
}
