import 'package:dimensions_theme/dimensions_theme.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';
import 'package:provider/provider.dart';

import 'footer.dart';
import 'vm.dart';
import 'utils.dart';
import 'item.dart';
import 'theme.dart';

const double kHeaderHeight = 260;
const double kHeaderInset = 50;

void main() {
  runApp(
    const AnimatedDragDropApp(),
  );
}

class AnimatedDragDropApp extends StatelessWidget {
  const AnimatedDragDropApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(extensions: const [
        dimensionsTheme,
      ]),
      home: const Screen(),
    );
  }
}

class Screen extends StatelessWidget {
  const Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ListVM(),
      child: const Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              child: Stack(
                children: [
                  Header(),
                  Material(
                    type: MaterialType.transparency,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: kHeaderHeight - kHeaderInset,
                      ),
                      child: Body(),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Footer(),
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kHeaderHeight,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.blue1,
            AppColors.blue2,
          ],
        ),
      ),
      child: Align(
        alignment: const Alignment(0, -.3),
        child: Row(
          children: [
            Dimensions.xlarge.w(),
            const Icon(
              CupertinoIcons.arrow_up_doc_fill,
              size: 48,
              color: Colors.white,
            ),
            Dimensions.medium.w(),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "New Multi Invoice",
                  style: TextStyles.appSubtitle,
                ),
                Text(
                  "The Fitz Bar",
                  style: TextStyles.appTitle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ItemBank(),
        Dimensions.small.h(),
        Padding(
          padding: context.padding.all(Dimensions.medium),
          child: const SelectedItemList(),
        ),
      ],
    );
  }
}

class ItemBank extends StatefulWidget {
  const ItemBank({
    super.key,
  });

  @override
  State<ItemBank> createState() => _ItemBankState();
}

class _ItemBankState extends State<ItemBank> with TickerProviderStateMixin {
  final cardKey = GlobalKey();
  final avatarKey = GlobalKey();
  final firstNameKey = GlobalKey();
  final lastNameKey = GlobalKey();

  late final inflateAnimation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  late final removeAnimation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  int? draggedItemIndex;

  void onDragStarted(Item item) {
    final itemIndex = context.read<ListVM>().itemBank.indexOf(item);
    setState(() {
      draggedItemIndex = itemIndex;
    });
    startInflateAnimation();
  }

  void onItemDropped(DraggableDetails details, Item item) {
    stopInflateAnimation();
    if (details.wasAccepted == false) {
      setState(() {
        draggedItemIndex = null;
      });
      return;
    }
    startRemoveAnimation();
    item.setDropOffsets(
      dropOffset: findOffset(cardKey),
      cardSize: findBox(cardKey).size,
      dropFirstNameOffset: findOffset(firstNameKey),
      dropLastNameOffset: findOffset(lastNameKey),
      dropAvatarOffset: findOffset(avatarKey),
    );
    context.read<ListVM>().selectItem(item);
  }

  late final removeWidthTween = Tween<double>(begin: 100, end: 0);
  late final spaceWidthTween = Tween<double>(begin: 10, end: 30);

  void startInflateAnimation() {
    inflateAnimation.animateTo(1, curve: Curves.easeInOutCubic);
  }

  void stopInflateAnimation() {
    inflateAnimation.animateTo(0, curve: Curves.easeInOutCubic);
  }

  void startRemoveAnimation() {
    removeAnimation.animateTo(1, curve: Curves.easeOutCubic).whenComplete(() {
      removeAnimation.reset();
      setState(() {
        draggedItemIndex = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = context.watch<ListVM>().itemBank;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: context.padding.symmetric(horizontal: Dimensions.xlarge),
      child: items.isEmpty
          ? const SizedBox(height: 50)
          : AnimatedBuilder(
              animation: Listenable.merge([
                removeAnimation,
                inflateAnimation,
              ]),
              builder: (context, child) {
                final effectiveItems = items
                    .map<Widget>(
                      (e) => Draggable<Item>(
                        key: ObjectKey(e),
                        data: e,
                        hitTestBehavior: HitTestBehavior.opaque,
                        onDragStarted: () => onDragStarted(e),
                        onDragEnd: (details) => onItemDropped(details, e),
                        feedback: VerticalItemCardDragFeedback(
                          item: e,
                          cardKey: cardKey,
                          avatarKey: avatarKey,
                          firstNameKey: firstNameKey,
                          lastNameKey: lastNameKey,
                        ),
                        childWhenDragging: const SizedBox(
                          height: 140,
                        ),
                        child: VerticalItemCard(
                          key: UniqueKey(),
                          item: e,
                        ),
                      ),
                    )
                    .intersperse(
                      SizedBox(
                        width: spaceWidthTween.evaluate(inflateAnimation),
                      ),
                    )
                    .toList();

                // Insert dragged item animated placeholder
                if (draggedItemIndex != null) {
                  final indexWithSpace = draggedItemIndex! * 2;
                  if (indexWithSpace >= effectiveItems.length) {
                    effectiveItems.add(
                      SizedBox(
                        width: removeWidthTween.evaluate(removeAnimation),
                      ),
                    );
                  } else {
                    effectiveItems.insert(
                      draggedItemIndex! * 2,
                      SizedBox(
                        width: removeWidthTween.evaluate(removeAnimation),
                      ),
                    );
                  }
                }

                return Row(
                  children: effectiveItems.toList(),
                );
              },
            ),
    );
  }
}

class SelectedItemList extends StatefulWidget {
  const SelectedItemList({
    super.key,
  });

  @override
  State<SelectedItemList> createState() => _SelectedItemListState();
}

class _SelectedItemListState extends State<SelectedItemList> {
  @override
  Widget build(BuildContext context) {
    final items = context.watch<ListVM>().selectedItems;
    return DragTarget<Item>(
      builder: (context, candidateData, rejectedData) {
        final showPlaceholder = candidateData.isNotEmpty;

        return ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 305),
          child: DottedBorder(
            radius: const Radius.circular(34),
            borderType: BorderType.RRect,
            strokeWidth: 2,
            dashPattern: const [6, 6],
            color: const Color(0xffDDE1E4),
            padding: context.padding.all(Dimensions.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  child: showPlaceholder
                      ? const SizedBox(
                          height: 100,
                        )
                      : const SizedBox.shrink(),
                ),
                if (candidateData.isNotEmpty)
                  AnimatedHorizontalCard(
                    item: candidateData.first!,
                    key: ObjectKey(candidateData.first!),
                  ),
                ...items
                    .map<Widget>(
                      (e) => AnimatedHorizontalCard(
                        item: e,
                        key: ObjectKey(e),
                      ),
                    )
                    .intersperse(
                      ListSpace(
                        expand: showPlaceholder,
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class VerticalListSpace extends StatelessWidget {
  const VerticalListSpace({
    super.key,
    required this.expand,
  });

  final bool expand;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 400),
      child: expand ? Dimensions.large.w() : Dimensions.small.w(),
    );
  }
}

class ListSpace extends StatelessWidget {
  const ListSpace({
    super.key,
    required this.expand,
  });

  final bool expand;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 400),
      child: expand ? Dimensions.xlarge.h() : Dimensions.small.h(),
    );
  }
}
