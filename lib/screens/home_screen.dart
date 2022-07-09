import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../widgets/explore_tab.dart';
import '../providers/ad_state.dart';
import '../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) => setState(() {
          banner = BannerAd(
            adUnitId: adState.bannerAdUnitId,
            size: AdSize.banner,
            request: const AdRequest(),
            listener: adState.adListner,
          )..load();
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'BookOpus',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Image.asset(
            'assets/images/no_bg_app_icon.png',
            height: 48,
            width: 48,
            color: primaryColor,
          ),
        ],
      ),
      body: Column(
        children: [
          const Expanded(child: ExploreTab()),
          if (banner != null)
            SizedBox(
              height: 50,
              child: AdWidget(ad: banner!),
            ),
        ],
      ),
    );
  }
}
