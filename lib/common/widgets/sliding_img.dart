import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/misc.dart';

class SlidingImg extends ConsumerStatefulWidget {
  final List<String> imgList;
  const SlidingImg({super.key, required this.imgList});

  @override
  ConsumerState<SlidingImg> createState() => _CarouselMainViewState();
}

class _CarouselMainViewState extends ConsumerState<SlidingImg> {
  final carouselHeight = 250.0;

  @override
  Widget build(BuildContext context) {
    logView(runtimeType);
    final width = MediaQuery.of(context).size.width;
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: false,
        enlargeCenterPage: true,
        aspectRatio: 1 / 1,
        viewportFraction: 1,
        autoPlayInterval: Duration(seconds: 6),
        autoPlayAnimationDuration: Duration(seconds: 1),
        autoPlayCurve: Curves.easeOutCirc,
      ),
      items: widget.imgList.map((item) {
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
                  child: item.isNotEmpty
                      ? networkImg(src: item, width: width, size: 50)
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
