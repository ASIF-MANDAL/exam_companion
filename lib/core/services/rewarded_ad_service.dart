import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdService {
  static RewardedAd? _rewardedAd;
  static bool _isLoading = false;

  static const String testRewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';

  static void loadRewardedAd() {
    if (_isLoading || _rewardedAd != null) {
      return;
    }

    _isLoading = true;

    RewardedAd.load(
      adUnitId: testRewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoading = false;
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          _isLoading = false;
        },
      ),
    );
  }

  static bool get isReady => _rewardedAd != null;

  static void showRewardedAd({
    required Function() onRewardEarned,
    required Function() onAdUnavailable,
  }) {
    final ad = _rewardedAd;

    if (ad == null) {
      onAdUnavailable();
      loadRewardedAd();
      return;
    }

    _rewardedAd = null;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        loadRewardedAd();
      },
    );

    ad.show(
      onUserEarnedReward: (ad, reward) {
        onRewardEarned();
      },
    );
  }
}