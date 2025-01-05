import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/loading.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/misc.dart';
import 'package:tez_bazar/providers/providers.dart';

class CarouselMainView extends ConsumerStatefulWidget {
  const CarouselMainView({super.key});

  @override
  ConsumerState<CarouselMainView> createState() => _CarouselMainViewState();
}

class _CarouselMainViewState extends ConsumerState<CarouselMainView> {
  final carouselHeight = 250.0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final banners = ref.watch(bannersProvider);
    logView('CarouselMainView');
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 1,
        autoPlayInterval: Duration(seconds: 6),
        autoPlayAnimationDuration: Duration(seconds: 1),
        autoPlayCurve: Curves.easeOutCirc,
      ),
      items: banners.map((item) {
        return Padding(
          padding: const EdgeInsets.all(0),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: boxShadow(),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: item.photo.isNotEmpty
                      ? networkImg(src: item.photo, width: width, size: 50)
                      : noImg(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
