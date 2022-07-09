import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import './utils/colors.dart';

import './providers/books_provider.dart';
import './providers/ad_state.dart';

import './screens/home_screen.dart';
import './screens/book_detail_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  runApp(Provider.value(
    value: adState,
    builder: (context, child) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BooksProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BookOpus',
        theme: ThemeData(
          primaryColor: primaryColor,
          primarySwatch: Colors.deepOrange,
        ),
        home: const HomeScreen(),
        routes: {
          BookDetailScreen.routeName: (_) => const BookDetailScreen(),
        },
      ),
    );
  }
}
