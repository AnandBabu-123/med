import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/banner_bloc/banner_bloc.dart';
import '../../../bloc/banner_bloc/banner_event.dart';
import '../../../bloc/banner_bloc/banner_state.dart';


import 'dart:async';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DashboardBannerList extends StatefulWidget {
  const DashboardBannerList({super.key});

  @override
  State<DashboardBannerList> createState() => _DashboardBannerListState();
}

class _DashboardBannerListState extends State<DashboardBannerList> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Fetch banners from Bloc
    context.read<BannerBloc>().add(FetchBannerEvent());

    // Auto-scroll timer
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _currentPage + 1;
        if (nextPage >= (context.read<BannerBloc>().state as BannerLoaded).banners.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerBloc, BannerState>(
      builder: (context, state) {
        if (state is BannerLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is BannerLoaded) {
          return Column(
            children: [
              SizedBox(
                height: 150,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: state.banners.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    final banner = state.banners[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          banner.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => const Icon(Icons.error),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              /// Dots indicator
              SmoothPageIndicator(
                controller: _pageController,
                count: state.banners.length,
                effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 6,
                  activeDotColor: Colors.blue,
                  dotColor: Colors.grey,
                ),
              ),
            ],
          );
        }

        if (state is BannerError) {
          return Text(state.message);
        }

        return const SizedBox();
      },
    );
  }
}

