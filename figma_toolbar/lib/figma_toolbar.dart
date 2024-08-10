import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class FigmaBar extends StatelessWidget {
  const FigmaBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 2),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 4,
            color: Colors.black.withOpacity(.6),
          )
        ],
      ),
      child: IntrinsicHeight(
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
            const VerticalDivider(
              color: Color(0xff383838),
              width: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return ToolbarSwitch(
                    onChanged: (value) => setState(() {
                      devMode = value;
                    }),
                    devModeEnabled: devMode,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool devMode = false;

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

// class VerticalDiv extends StatelessWidget {
//   const VerticalDiv({super.key,});

//   @override
//   Widget build(BuildContext context) {
//   return
//   }
// }

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
    return Material(
      color: selected ? const Color(0xff0C8CE9) : Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: () {},
        borderRadius: borderRadius,
        overlayColor: WidgetStateProperty.resolveWith((_) {
          return const Color(0xff383838);
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
        color: devModeEnabled ? Colors.green : const Color(0xff383838),
        animationDuration: animationDuration,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: () => onChanged(!devModeEnabled),
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
                  color: Colors.black,
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
