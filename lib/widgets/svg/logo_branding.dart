import 'package:flashlist/constants/app_sizes.dart';
import 'package:flashlist/utils/context_retriever.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

enum LogoTheme { black, white, color }

class LogoBranding extends StatelessWidget {
  const LogoBranding({
    super.key,
    this.width = 70,
    this.height = 70,
    this.color = LogoTheme.color,
    this.withBranding = true,
  });

  final double width;
  final double height;
  final LogoTheme color;
  final bool withBranding;

  @override
  Widget build(BuildContext context) {
    final bool isDark = isDarkThemeOf(context);

    String brandingColor;
    switch (color) {
      case LogoTheme.black:
        brandingColor = "#000000";
        break;
      case LogoTheme.white:
        brandingColor = "#ffffff";
        break;
      case LogoTheme.color:
        brandingColor = "#2bb673";
        break;
    }

    String svgString = '''
      <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="Layer_1" x="0px" y="0px" style="enable-background:new 0 0 841.89 595.28;" xml:space="preserve" viewBox="170.14 228.64 157.55 137.37">
        <g>
          <g>
            <g>
              <polygon fill="#${isDark ? 'ffffff' : '000000'}" points="211.49,366.01 170.14,366.01 170.14,228.64 211.49,228.64 211.49,239.01 180.5,239.01 180.5,355.65      211.49,355.65    "/>
            </g>
            <g>
              <polygon fill="#${isDark ? 'ffffff' : '000000'}"  points="327.69,366.01 286.33,366.01 286.33,355.65 317.33,355.65 317.33,239.01 286.33,239.01 286.33,228.64      327.69,228.64    "/>
            </g>
            <polygon fill="$brandingColor" points="257.5,290 259.39,233.1 234.97,271.52 215.84,304.66 240.39,304.66 238.5,361.56 262.92,323.13 282.05,290   "/>
          </g>
        </g>
      </svg>
    ''';

    return Column(
      children: [
        SvgPicture.string(
          svgString,
          width: width,
          height: height,
        ),
        if (withBranding) gapH12,
        if (withBranding)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Flash',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontFamily: GoogleFonts.exo().fontFamily,
                  color: Color(
                    int.parse('0xFF${brandingColor.substring(1, 7)}'),
                  ),
                  fontSize: Sizes.p20,
                ),
              ),
              Text(
                'List',
                style: TextStyle(
                  fontFamily: GoogleFonts.exo().fontFamily,
                  fontWeight: FontWeight.w900,
                  color: isDarkThemeOf(context) ? Colors.white : Colors.black,
                  fontSize: Sizes.p20,
                ),
              ),
            ],
          )
      ],
    );
  }
}
