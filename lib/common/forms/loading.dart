import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

Widget loadingImg(
    BuildContext context, Widget child, ImageChunkEvent? loadingProgress,double size) {
  if (loadingProgress == null) return child;
  return Center(
    child: LoadingAnimation(size: size),
  );
}



class LoadingAnimation extends StatefulWidget {
  final double size;
  const LoadingAnimation({
    super.key,
    required this.size,
  });

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> {
  late RiveAnimationController _logoAnimationController;

  @override
  void initState() {
    super.initState();
    _logoAnimationController = OneShotAnimation(
      'logo_animation',
      autoplay: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: RiveAnimation.asset(
          'lib/assets/rive/logo.riv',
          fit: BoxFit.contain,
          controllers: [_logoAnimationController],
        ),
      ),
    );
  }
}
