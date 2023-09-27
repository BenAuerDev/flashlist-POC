import 'package:brainstorm_array/utils/context_retriever.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ColorInput extends HookConsumerWidget {
  const ColorInput({super.key, this.initialColor, this.onSelectColor});

  final Color? initialColor;
  final Function(Color)? onSelectColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ValueNotifier<Color> pickerColor =
        useState(const Color.fromARGB(255, 255, 255, 255));

    ValueNotifier<Color> currentColor =
        useState(initialColor ?? retrieveColorScheme(context).primary);

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
                title: const Text('Pick a color!'),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: pickerColor.value,
                    onColorChanged: changeColor,
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text('Got it'),
                    onPressed: () {
                      pickerColor = currentColor;
                      onSelectColor!(pickerColor.value);

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
          child: const Text('Pick a color'),
        ),
        const SizedBox(
          width: 16,
        ),
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