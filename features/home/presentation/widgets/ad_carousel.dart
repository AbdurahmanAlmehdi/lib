import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:buzzy_bee/features/home/domain/entities/ad_banner.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';

class AdCarousel extends StatefulWidget {
  final List<AdBanner> banners;
  final Function(AdBanner)? onTap;

  const AdCarousel({super.key, required this.banners, this.onTap});

  @override
  State<AdCarousel> createState() => _AdCarouselState();
}

class _AdCarouselState extends State<AdCarousel> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.banners.length > 1) {
      _startAutoScroll();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        if (_currentIndex < widget.banners.length - 1) {
          _currentIndex++;
        } else {
          _currentIndex = 0;
        }
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const _ShimmerCarousel();
    }

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: widget.banners.length,
            itemBuilder: (context, index) {
              final banner = widget.banners[index];
              return _BannerItem(
                banner: banner,
                onTap: () => widget.onTap?.call(banner),
              );
            },
          ),
        ),
        if (widget.banners.length > 1)
          _PageIndicator(
            currentIndex: _currentIndex,
            itemCount: widget.banners.length,
          ),
      ],
    );
  }
}

class _BannerItem extends StatelessWidget {
  final AdBanner banner;
  final VoidCallback? onTap;

  const _BannerItem({required this.banner, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/frame.png',
            fit: BoxFit.contain,
            // placeholder: (context, url) => Container(
            //   color: AppColors.surfaceVariant,
            //   child: const Center(child: CircularProgressIndicator()),
            // ),
            // errorWidget: (context, url, error) => Container(
            //   color: AppColors.surfaceVariant,
            //   child: const Icon(Icons.error_outline),
            // ),
          ),
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int itemCount;

  const _PageIndicator({required this.currentIndex, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          itemCount,
          (index) => Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == currentIndex
                  ? AppColors.primary
                  : AppColors.border,
            ),
          ),
        ),
      ),
    );
  }
}

class _ShimmerCarousel extends StatelessWidget {
  const _ShimmerCarousel();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
