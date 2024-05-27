import 'dart:async';

import 'package:animated_dragdrop/vm.dart';
import 'package:dimensions_theme/dimensions_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme.dart';

class Footer extends StatelessWidget {
  const Footer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.025),
            blurRadius: 15,
            offset: const Offset(0, -4),
          )
        ],
      ),
      padding: context.padding.all(Dimensions.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Amount:",
                style: TextStyles.bottomCardText,
              ),
              Text(
                "\$ 210",
                style: TextStyles.bottomCardText,
              ),
            ],
          ),
          Dimensions.medium.h(),
          Hero(
            tag: "button",
            child: Material(
              type: MaterialType.transparency,
              child: Ink(
                height: 75,
                width: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff5ECC5C),
                      Color(0xff69D1AC),
                    ],
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () async {
                    await Navigator.of(context).push(_createRoute());
                    if (context.mounted) {
                      context.read<ListVM>().reset();
                    }
                  },
                  child: Center(
                    child: Text(
                      "Send",
                      style: TextStyles.buttonText,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const OkScreen(),
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (animation.status == AnimationStatus.reverse) {
        return Opacity(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).value,
          child: child,
        );
      }

      var begin = const Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.easeOutCubic;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      final radiusAnim = CurvedAnimation(
        parent: animation,
        curve: const Interval(.8, 1),
      );
      final radius = Tween<double>(begin: 40, end: 0)
          .chain(CurveTween(curve: curve))
          .evaluate(radiusAnim);

      return SlideTransition(
        position: offsetAnimation,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
          ),
          child: child,
        ),
      );
    },
  );
}

class OkScreen extends StatefulWidget {
  const OkScreen({
    super.key,
  });

  @override
  State<OkScreen> createState() => _OkScreenState();
}

class _OkScreenState extends State<OkScreen>
    with SingleTickerProviderStateMixin {
  late final animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  /// disable Hero on the way back for nice fade transition
  bool disableHero = false;
  late final iconOpacityTween = Tween<double>(begin: 0, end: 1);

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
    animation.forward().whenComplete(() {
      setState(() {
        disableHero = true;
      });
    });
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Hero(
          tag: disableHero == false ? "button" : '',
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: const LinearGradient(
                colors: [
                  AppColors.green1,
                  AppColors.green2,
                ],
              ),
            ),
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) => Opacity(
                opacity: animation.value,
                child: const Icon(
                  CupertinoIcons.checkmark_alt_circle,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
