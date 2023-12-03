import 'package:flashlist/constants/app_sizes.dart';
import 'package:flashlist/utils/context_retriever.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class ColorInput extends HookWidget {
  const ColorInput({super.key, this.initialColor, this.onSelectColor});

  final Color? initialColor;
  final Function(Color)? onSelectColor;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<Color> pickerColor =
        useState(const Color.fromARGB(255, 255, 255, 255));

    ValueNotifier<Color> currentColor =
        useState(initialColor ?? colorSchemeOf(context).primary);

    void changeColor(Color color) {
      currentColor.value = color;
    }

    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('${appLocalizationsOf(context).pickAColor}!'),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: pickerColor.value,
                    onColorChanged: changeColor,
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text(appLocalizationsOf(context).pick),
                    onPressed: () {
                      pickerColor = currentColor;
                      onSelectColor!(pickerColor.value);

                      context.pop();
                    },
                  ),
                ],
              ),
            );
          },
          child: Text(appLocalizationsOf(context).pickAColor),
        ),
        gapW16,
        Container(
          color: currentColor.value,
          child: const SizedBox(
            height: 35,
            width: 35,
          ),
        )
      ],
    );
  }
}
