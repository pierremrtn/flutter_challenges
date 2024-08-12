import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

abstract class AppColors {
  static const green = Color(0xff158E4F);
  static const blue = Color(0xff0C8CE9);
  static const background = Color(0xff2C2C2C);
  static const onBackground = Color(0xff383838);
}

class FigmaBar extends StatefulWidget {
  const FigmaBar({
    super.key,
  });

  @override
  State<FigmaBar> createState() => _FigmaBarState();
}

class _FigmaBarState extends State<FigmaBar> {
  bool devModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 4,
            color: Colors.black.withOpacity(.6),
          )
        ],
      ),
      child: SizedBox(
        height: 48,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedToolbar(
              devModeEnabled: devModeEnabled,
              design: const DesignTools(),
              dev: const DevTools(),
            ),
            const VerticalDivider(
              color: AppColors.onBackground,
              width: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ToolbarSwitch(
                onChanged: (value) => setState(() {
                  devModeEnabled = value;
                }),
                devModeEnabled: devModeEnabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedToolbar extends StatefulWidget {
  const AnimatedToolbar({
    super.key,
    required this.design,
    required this.dev,
    required this.devModeEnabled,
  });

  final bool devModeEnabled;
  final Widget design;
  final Widget dev;

  @override
  State<AnimatedToolbar> createState() => _AnimatedToolbarState();
}

enum _WidthMode {
  dev,
  design,
}

class _AnimatedToolbarState extends State<AnimatedToolbar>
    with SingleTickerProviderStateMixin {
  late final _slideAnimation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  )..addStatusListener(slideAnimationListener);

  late _WidthMode widthMode =
      widget.devModeEnabled ? _WidthMode.dev : _WidthMode.design;

  @override
  void didUpdateWidget(AnimatedToolbar old) {
    super.didUpdateWidget(old);
    if (old.devModeEnabled != widget.devModeEnabled) {
      if (widget.devModeEnabled) {
        _slideAnimation.animateTo(
          1,
          curve: Curves.easeOutQuad,
        );
      } else {
        _slideAnimation.animateTo(
          0,
          curve: Curves.easeOutQuad,
        );
      }
    }
  }

  void slideAnimationListener(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        widthMode = widget.devModeEnabled ? _WidthMode.dev : _WidthMode.design;
      });
    }
  }

  Widget _overflowing(Widget widget) {
    return Positioned.fill(
      child: OverflowBox(
        alignment: Alignment.centerLeft,
        maxWidth: double.infinity,
        child: widget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, _) {
        final designOffset = Offset(0, _slideAnimation.value * -1);
        final devOffset = Offset(0, (1 - _slideAnimation.value));

        Widget design = FractionalTranslation(
          translation: designOffset,
          child: widget.design,
        );

        Widget dev = FractionalTranslation(
          translation: devOffset,
          child: widget.dev,
        );

        switch (widthMode) {
          case _WidthMode.dev:
            design = _overflowing(design);
          case _WidthMode.design:
            dev = _overflowing(dev);
        }

        return ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 340),
            curve: Curves.easeOut,
            alignment: Alignment.centerLeft,
            child: Stack(
              children: [
                design,
                dev,
              ],
            ),
          ),
        );
      },
    );
  }
}

class ToolbarTheme extends InheritedWidget {
  static ToolbarTheme of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ToolbarTheme>()!;

  final Color focusColor;

  const ToolbarTheme({
    super.key,
    required super.child,
    required this.focusColor,
  });

  @override
  bool updateShouldNotify(ToolbarTheme oldWidget) =>
      focusColor != oldWidget.focusColor;
}

class DesignTools extends StatelessWidget {
  const DesignTools({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ToolbarTheme(
      focusColor: AppColors.blue,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SeparatedRow(
              separatorBuilder: () => const Gap(8),
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Button(
                  icon: "arrow",
                  dropdown: true,
                  selected: true,
                ),
                Button(
                  icon: "frame",
                  dropdown: true,
                ),
                Button(
                  icon: "square",
                  dropdown: true,
                ),
                Button(
                  icon: "ink",
                  dropdown: true,
                ),
                Button(icon: "text"),
                Button(icon: "comment"),
                Button(icon: "star"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DevTools extends StatelessWidget {
  const DevTools({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ToolbarTheme(
      focusColor: AppColors.green,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SeparatedRow(
              separatorBuilder: () => const Gap(8),
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Button(
                  icon: "arrow",
                  selected: true,
                ),
                Button(icon: "comment"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.icon,
    this.dropdown = false,
    this.selected = false,
  });

  final bool selected;
  final bool dropdown;
  final String icon;

  @override
  Widget build(BuildContext context) {
    if (dropdown) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ButtonBase(
            selected: selected,
            icon: icon,
          ),
          const ButtonBase(
            selected: false,
            icon: "chevron_down",
            iconSize: 12,
          ),
        ],
      );
    } else {
      return ButtonBase(
        selected: selected,
        icon: icon,
      );
    }
  }
}

class ButtonBase extends StatelessWidget {
  const ButtonBase({
    super.key,
    required this.icon,
    this.iconSize = 24,
    required this.selected,
  });

  final double iconSize;
  final bool selected;
  final String icon;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(5);
    final focusColor = ToolbarTheme.of(context).focusColor;
    return Material(
      color: selected ? focusColor : Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: () {},
        borderRadius: borderRadius,
        overlayColor: WidgetStateProperty.resolveWith((_) {
          if (selected == false) {
            return AppColors.onBackground;
          } else {
            return focusColor;
          }
        }),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Image.asset(
              "assets/$icon.png",
              height: iconSize,
              width: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}

class ToolbarSwitch extends StatelessWidget {
  const ToolbarSwitch({
    super.key,
    required this.devModeEnabled,
    required this.onChanged,
  });

  final bool devModeEnabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    const animationDuration = Duration(milliseconds: 200);
    const animationCurve = Curves.easeInOut;

    return SizedBox(
      height: 26,
      width: 40,
      child: Material(
        color: devModeEnabled ? AppColors.green : AppColors.onBackground,
        animationDuration: animationDuration,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: () => onChanged(!devModeEnabled),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: AnimatedAlign(
              curve: animationCurve,
              alignment:
                  devModeEnabled ? Alignment.centerRight : Alignment.bottomLeft,
              duration: animationDuration,
              child: Container(
                height: 22,
                width: 22,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  HeroiconsMini.codeBracket,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
