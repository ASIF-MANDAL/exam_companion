import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../premium/premium_provider.dart';

class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key});

  @override
  ConsumerState<BannerAdWidget> createState() =>
      _BannerAdWidgetState();
}

class _BannerAdWidgetState
    extends ConsumerState<BannerAdWidget> {
  BannerAd? bannerAd;
  bool isLoaded = false;

  static const String testBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';

  @override
  void initState() {
    super.initState();
    loadAd();
  }

  void loadAd() {
    bannerAd = BannerAd(
      adUnitId: testBannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;

          setState(() {
            isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPremium =
    ref.watch(premiumProvider);

    if (isPremium) {
      return const SizedBox.shrink();
    }

    if (!isLoaded || bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      width: bannerAd!.size.width.toDouble(),
      height: bannerAd!.size.height.toDouble(),
      child: AdWidget(
        ad: bannerAd!,
      ),
    );
  }
}