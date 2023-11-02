import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flash_list/utils/context_retriever.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BrightnessRadio extends HookWidget {
  const BrightnessRadio({super.key});

  @override
  Widget build(BuildContext context) {
    final currentThemeMode = AdaptiveTheme.of(context).mode;

    var selectedModes = useState<List<bool>>([false, false, true]);

    useEffect(() {
      if (currentThemeMode == AdaptiveThemeMode.light) {
        selectedModes.value = [true, false, false];
      } else if (currentThemeMode == AdaptiveThemeMode.dark) {
        selectedModes.value = [false, true, false];
      } else {
        selectedModes.value = [false, false, true];
      }
      return;
    }, [AdaptiveTheme.of(context).mode]);

    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Icon
              if (currentThemeMode == AdaptiveThemeMode.light)
                const Icon(Icons.light_mode),
              if (currentThemeMode == AdaptiveThemeMode.dark)
                const Icon(Icons.dark_mode),
              if (currentThemeMode == AdaptiveThemeMode.system)
                const Icon(Icons.settings),
              const SizedBox(width: 10),

              Text(retrieveAppLocalizations(context).brightness)
            ],
          ),
          ToggleButtons(
            direction: Axis.horizontal,
            isSelected: selectedModes.value,
            onPressed: (index) {
              switch (index) {
                case 0:
                  AdaptiveTheme.of(context).setLight();
                  selectedModes.value = [true, false, false];
                  break;
                case 1:
                  AdaptiveTheme.of(context).setDark();
                  selectedModes.value = [false, true, false];
                  break;
                default:
                  AdaptiveTheme.of(context).setSystem();
                  selectedModes.value = [false, false, true];
                  break;
              }
            },
            children: [
              Text(retrieveAppLocalizations(context).light),
              Text(retrieveAppLocalizations(context).dark),
              Text(retrieveAppLocalizations(context).system),
            ],
          ),
        ],
      ),
    );
  }
}
