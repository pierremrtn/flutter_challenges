import 'package:animated_dragdrop/theme.dart';
import 'package:animated_dragdrop/utils.dart';
import 'package:animated_dragdrop/vm.dart';
import 'package:dimensions_theme/dimensions_theme.dart';
import 'package:flutter/material.dart';

const avatarVerticalRadius = 50 / 2;
const avatarHorizontalRadius = 43 / 2;

class VerticalItemCard extends StatelessWidget {
  const VerticalItemCard({
    super.key,
    required this.item,
  });

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 35,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: VerticalItemCardContent(
        item: item,
      ),
    );
  }
}

class VerticalItemCardDragFeedback extends StatelessWidget {
  const VerticalItemCardDragFeedback({
    super.key,
    required this.item,
    this.avatarKey,
    this.firstNameKey,
    this.lastNameKey,
    this.cardKey,
  });

  final Item item;
  final Key? cardKey;
  final Key? avatarKey;
  final Key? firstNameKey;
  final Key? lastNameKey;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(-80, -80),
      child: DefaultTextStyle(
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black,
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Material(
            type: MaterialType.transparency,
            child: Padding(
              padding: const EdgeInsets.all(80),
              child: Ink(
                key: cardKey,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      blurRadius: 35,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: VerticalItemCardContent(
                  item: item,
                  avatarKey: avatarKey,
                  firstNameKey: firstNameKey,
                  lastNameKey: lastNameKey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VerticalItemCardContent extends StatelessWidget {
  const VerticalItemCardContent({
    super.key,
    required this.item,
    this.avatarKey,
    this.firstNameKey,
    this.lastNameKey,
  });

  final Item item;
  final Key? avatarKey;
  final Key? firstNameKey;
  final Key? lastNameKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 140,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Avatar(
              key: avatarKey,
              item: item,
              radius: avatarVerticalRadius,
            ),
          ),
          Dimensions.small.h(),
          Text(
            item.firstName,
            key: firstNameKey,
            style: TextStyles.cardText,
            textAlign: TextAlign.center,
          ),
          Text(
            item.lastName,
            key: lastNameKey,
            style: TextStyles.cardText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class HorizontalItemCard extends StatelessWidget {
  const HorizontalItemCard({
    super.key,
    required this.item,
    this.firstNameKey,
    this.lastNameKey,
    this.avatarKey,
  });

  final Item item;
  final Key? firstNameKey;
  final Key? lastNameKey;
  final Key? avatarKey;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 11,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: context.padding.symmetric(
        horizontal: Dimensions.medium,
        vertical: Dimensions.small,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Avatar(
            key: avatarKey,
            radius: avatarHorizontalRadius,
            item: item,
          ),
          Dimensions.medium.w(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.firstName,
                key: firstNameKey,
                style: TextStyles.cardText,
              ),
              Text(
                item.lastName,
                key: lastNameKey,
                style: TextStyles.cardText,
              ),
            ],
          ),
          const Spacer(),
          Text(
            "\$",
            style: TextStyles.horizontalCardText.copyWith(
              color: Colors.black.withOpacity(.4),
            ),
          ),
          const Space.w(Dimensions.xlarge),
          Container(
            height: 40,
            width: 1,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black.withOpacity(.2),
              ),
            ),
          ),
          const Space.w(Dimensions.xlarge),
          Padding(
            padding: context.padding.all(Dimensions.small).copyWith(left: 0),
            child: Text(
              item.money.toString(),
              style: TextStyles.cardNumber,
            ),
          )
        ],
      ),
    );
  }
}

class AnimatedHorizontalCard extends StatefulWidget {
  const AnimatedHorizontalCard({
    super.key,
    required this.item,
  });

  final Item item;

  @override
  State<AnimatedHorizontalCard> createState() => _AnimatedHorizontalCardState();
}

class _AnimatedHorizontalCardState extends State<AnimatedHorizontalCard> {
  bool morhAnimationCompleted = false;
  OverlayEntry? entry;

  final cardKey = GlobalKey();
  final avatarKey = GlobalKey();
  final firstNameKey = GlobalKey();
  final lastNameKey = GlobalKey();

  void onItemDropped() {
    entry = OverlayEntry(
      builder: (context) => MorphAnimation(
        item: widget.item,
        avatarKey: avatarKey,
        firstNameKey: firstNameKey,
        lastNameKey: lastNameKey,
        cardKey: cardKey,
        onDone: onDone,
      ),
    );
    Overlay.of(context).insert(entry!);
  }

  @override
  void initState() {
    super.initState();
    widget.item.addListener(onItemDropped);
  }

  @override
  void dispose() {
    widget.item.removeListener(onItemDropped);
    super.dispose();
  }

  void onDone() {
    if (context.mounted) {
      entry?.remove();
      setState(() {
        morhAnimationCompleted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: morhAnimationCompleted,
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: HorizontalItemCard(
        key: cardKey,
        avatarKey: avatarKey,
        firstNameKey: firstNameKey,
        lastNameKey: lastNameKey,
        item: widget.item,
      ),
    );
  }
}

class MorphAnimation extends StatefulWidget {
  const MorphAnimation({
    super.key,
    required this.item,
    required this.avatarKey,
    required this.firstNameKey,
    required this.lastNameKey,
    required this.cardKey,
    required this.onDone,
  });

  final Item item;
  final GlobalKey avatarKey;
  final GlobalKey firstNameKey;
  final GlobalKey lastNameKey;
  final GlobalKey cardKey;
  final VoidCallback onDone;

  @override
  State<MorphAnimation> createState() => _MorphAnimationState();
}

class _MorphAnimationState extends State<MorphAnimation>
    with SingleTickerProviderStateMixin {
  late final animation = AnimationController(vsync: this);

  late final avatarAnimation = CurvedAnimation(
    parent: animation,
    curve: const Interval(0, 1),
  );

  late final nameAnimation = CurvedAnimation(
    parent: animation,
    curve: const Interval(0, 1),
  );

  late final dollarAnimation = CurvedAnimation(
    parent: animation,
    curve: const Interval(0, .7),
  );

  late final numberAnimation = CurvedAnimation(
    parent: animation,
    curve: const Interval(.5, 1),
  );

  get avatarKey => widget.avatarKey;
  get firstNameKey => widget.firstNameKey;
  get lastNameKey => widget.lastNameKey;
  get cardKey => widget.cardKey;
  final stackKey = GlobalKey();

  late Animatable<Size> cardSizeTween;
  late Animatable<Offset> cardOffsetTween;
  late Animatable<double> cardXTween;
  late Animatable<double> cardYTween;

  late Animatable<double> avatarXTween;
  late Animatable<double> avatarYTween;

  final avatarRadiusTween = Tween<double>(
    begin: avatarVerticalRadius,
    end: avatarHorizontalRadius,
  );

  static const velocityOffsetValue = Offset(0, 50);
  final velocityTween = TweenSequence(
    [
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0, 0),
          end: velocityOffsetValue,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: .3,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: velocityOffsetValue,
          end: const Offset(0, 0),
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: .7,
      ),
    ],
  );

  late Animatable<double> firstNameXTween;
  late Animatable<double> firstNameYTween;

  late Animatable<double> lastNameXTween;
  late Animatable<double> lastNameYTween;

  final trailingOpacityTween =
      Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.ease));

  Item get item => widget.item;

  (Offset, Offset) calculateOffsets(
    Offset startOffsetGlobal,
    GlobalKey targetKey,
  ) {
    final targetBox = findBoxOrNull(targetKey);
    if (targetBox != null) {
      final targetOffsetGlobal = targetBox.localToGlobal(Offset.zero);
      return (startOffsetGlobal, targetOffsetGlobal);
    } else {
      return (startOffsetGlobal, startOffsetGlobal);
    }
  }

  static const morphDuation = Duration(milliseconds: 350);

  @override
  void initState() {
    super.initState();
    animation
        .animateTo(
      1,
      duration: morphDuation,
    )
        .whenComplete(() {
      widget.onDone();
    });
  }

  void morph() {
    final cardOffsets = calculateOffsets(
      widget.item.cardOffset!,
      cardKey,
    );

    const xCurve = Curves.ease;
    const yCurve = Curves.decelerate;

    cardXTween = Tween(begin: cardOffsets.$1.dx, end: cardOffsets.$2.dx)
        .chain(CurveTween(curve: xCurve));
    cardYTween = Tween(begin: cardOffsets.$1.dy, end: cardOffsets.$2.dy)
        .chain(CurveTween(curve: yCurve));

    final avatarOffsets = calculateOffsets(
      widget.item.dropAvatarOffset!,
      avatarKey,
    );

    avatarXTween = Tween(begin: avatarOffsets.$1.dx, end: avatarOffsets.$2.dx)
        .chain(CurveTween(curve: xCurve));
    avatarYTween = Tween(begin: avatarOffsets.$1.dy, end: avatarOffsets.$2.dy)
        .chain(CurveTween(curve: yCurve));

    final firstNameOffsets = calculateOffsets(
      widget.item.dropFirstNameOffset!,
      firstNameKey,
    );

    firstNameXTween =
        Tween(begin: firstNameOffsets.$1.dx, end: firstNameOffsets.$2.dx)
            .chain(CurveTween(curve: xCurve));

    firstNameYTween =
        Tween(begin: firstNameOffsets.$1.dy, end: firstNameOffsets.$2.dy)
            .chain(CurveTween(curve: yCurve));

    final lastNameOffsets = calculateOffsets(
      widget.item.dropLastNameOffset!,
      lastNameKey,
    );

    lastNameXTween =
        Tween(begin: lastNameOffsets.$1.dx, end: lastNameOffsets.$2.dx)
            .chain(CurveTween(curve: xCurve));

    lastNameYTween =
        Tween(begin: lastNameOffsets.$1.dy, end: lastNameOffsets.$2.dy)
            .chain(CurveTween(curve: yCurve));

    final targetCardBox = findBoxOrNull(cardKey);
    cardSizeTween =
        Tween(begin: item.cardSize, end: targetCardBox?.size ?? item.cardSize!)
            .chain(
      CurveTween(
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    animation.dispose();
    avatarAnimation.dispose();
    nameAnimation.dispose();
    dollarAnimation.dispose();
    numberAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          morph();

          final cardSize = cardSizeTween.evaluate(animation);

          final firstNameOffset = Offset(
            firstNameXTween.evaluate(nameAnimation),
            firstNameYTween.evaluate(nameAnimation),
          );
          final lastNameOffset = Offset(
            lastNameXTween.evaluate(nameAnimation),
            lastNameYTween.evaluate(nameAnimation),
          );

          final trailing1Opacity =
              trailingOpacityTween.evaluate(dollarAnimation);
          final trailing2Opcaity =
              trailingOpacityTween.evaluate(numberAnimation);
          return Stack(
            key: stackKey,
            children: [
              Transform.translate(
                offset: Offset(
                  cardXTween.evaluate(animation),
                  cardYTween.evaluate(animation),
                ),
                child: Container(
                  height: cardSize.height,
                  width: cardSize.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 11,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Opacity(
                        opacity: trailing1Opacity,
                        child: Text(
                          "\$",
                          style: TextStyles.horizontalCardText.copyWith(
                            color: Colors.black.withOpacity(.4),
                          ),
                        ),
                      ),
                      const Space.w(Dimensions.xlarge),
                      AnimatedSize(
                        duration: Duration(
                            milliseconds:
                                (morphDuation.inMilliseconds / 2).round()),
                        curve: Curves.easeOut,
                        alignment: Alignment.centerLeft,
                        child: Offstage(
                          offstage: trailing2Opcaity == 0,
                          child: Opacity(
                            opacity: trailing2Opcaity,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 40,
                                  width: 1,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black.withOpacity(.2),
                                    ),
                                  ),
                                ),
                                const Space.w(Dimensions.xlarge),
                                Padding(
                                  padding: context.padding
                                      .symmetric(horizontal: Dimensions.small)
                                      .copyWith(left: 0),
                                  child: Text(
                                    item.money.toString(),
                                    style: TextStyles.cardNumber,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Dimensions.medium.w(),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(
                  avatarXTween.evaluate(animation),
                  avatarYTween.evaluate(animation),
                ),
                child: Avatar(
                  item: item,
                  radius: avatarRadiusTween.evaluate(avatarAnimation),
                ),
              ),
              Transform.translate(
                offset: firstNameOffset,
                child: Text(
                  item.firstName,
                  style: TextStyles.cardText,
                ),
              ),
              Transform.translate(
                offset: lastNameOffset,
                child: Text(
                  item.lastName,
                  style: TextStyles.cardText,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.radius,
    required this.item,
  });

  final double radius;
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius * 2,
      width: radius * 2,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/${item.asset}'),
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
