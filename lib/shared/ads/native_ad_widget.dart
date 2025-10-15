import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

class NativeAdWidget extends StatefulWidget {
  final String factoryId;
  final String? adUnitId;
  final double height;

  const NativeAdWidget({
    super.key,
    required this.factoryId,
    this.adUnitId,
    this.height = 250,
  });

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;
  bool _requested = false;
  String? _lastError;
  bool _isDisposed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_requested) {
      _requested = true;
      _loadAd();
    }
  }

  void _loadAd() {
    final adUnitId = widget.adUnitId ?? _defaultAdUnitId();

    _nativeAd = NativeAd(
      adUnitId: adUnitId,
      factoryId: widget.factoryId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (_isDisposed) return;
          setState(() {
            _isLoaded = true;
            _lastError = null;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (_isDisposed) return;
          setState(() {
            _isLoaded = false;
            _lastError = '${error.code}: ${error.message}';
          });

          // Retry after a delay
          Future.delayed(const Duration(seconds: 5), () {
            if (!_isDisposed && !_isLoaded) {
              _loadAd();
            }
          });
        },
      ),
    )..load();
  }

  String _defaultAdUnitId() {
    // Force Google's TEST Native ad units to always show test ads
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/2247696110';
    } else {
      return 'ca-app-pub-3940256099942544/3986624511';
    }
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: (!_isLoaded || _nativeAd == null)
          ? _AdShimmerPlaceholder(
              height: widget.height,
              message: _lastError == null
                  ? 'Loading relevant content…'
                  : 'Ad failed: $_lastError',
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AdWidget(ad: _nativeAd!),
            ),
    );
  }
}

class _AdShimmerPlaceholder extends StatelessWidget {
  final double height;
  final String message;
  const _AdShimmerPlaceholder({
    required this.height,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade700,
        highlightColor: Colors.grey.shade500,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 12,
                color: Colors.grey.shade800,
              ),
              const SizedBox(height: 8),
              Container(
                width: 80,
                height: 12,
                color: Colors.grey.shade800,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
