import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';

class PinButtons extends StatefulWidget {
  const PinButtons({super.key});

  @override
  State<PinButtons> createState() => _PinButtonsState();
}

class _PinButtonsState extends State<PinButtons> {
  late RiveAnimationController _newAdsController;
  late List pinButtons;
  @override
  void initState() {
    super.initState();
    _newAdsController = OneShotAnimation(
      'icon_animation',
      autoplay: true,
    );
    pinButtons = [
      _buildPinButtons(
        title: 'Жаны товарлар',
        rivePath: 'lib/assets/rive/new_ads.riv',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(20),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 1.0,
        crossAxisCount: 2,
      ),
      itemBuilder: (BuildContext context, int index) {
        return pinButtons[index];
      },
      itemCount: 1,
    );
  }

  _buildPinButtons({String? rivePath, required String title}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.transparent,
      ),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.primaryColor,
            ),
            child: Column(
              children: [
                Center(
                    child: textForm(
                  title,
                  18,
                  textAlign: TextAlign.center,
                )),
              ],
            ),
          ),
          if (rivePath != null)
            Positioned(
              top: 0,
              right: 0,
              child: SizedBox(
                width: 60,
                height: 60,
                child: RiveAnimation.asset(
                  rivePath,
                  fit: BoxFit.cover,
                  controllers: [_newAdsController],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
