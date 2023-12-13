import 'package:flashlist/utils/context_retriever.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum LogoTheme { black, white, color }

class LogoBrandingVertical extends StatelessWidget {
  /// A Custom Widget returning the FlashList Logo with Branding in [Vertical] orientation
  ///
  /// Branding text can be hidden by setting [withBranding] to false
  ///
  /// The [color] can be set to [LogoTheme.black], [LogoTheme.white] or default is [LogoTheme.color]
  ///
  /// The [width] and [height] can be set to any value but should be the same
  const LogoBrandingVertical({
    super.key,
    this.width = 420,
    this.height = 595,
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
      <?xml version="1.0" encoding="utf-8"?>
      <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
          viewBox="0 0 595.28 419.53" style="enable-background:new 0 0 595.28 419.53;" xml:space="preserve">
        <g>
          <g>
            <g>
              <polygon fill="#${isDark ? 'ffffff' : '000000'}" points="243.5,255.6 190.34,255.6 190.34,79.03 243.5,79.03 243.5,92.35 203.66,92.35 203.66,242.28 243.5,242.28 			"/>
            </g>
            <g>
              <polygon fill="#${isDark ? 'ffffff' : '000000'}" points="392.85,255.6 339.69,255.6 339.69,242.28 379.53,242.28 379.53,92.35 339.69,92.35 339.69,79.03 392.85,79.03 
                      "/>
            </g>
            <polygon fill="$brandingColor" points="302.63,157.89 305.06,84.75 273.67,134.14 249.08,176.73 280.64,176.73 278.22,249.87 309.61,200.48 
              334.19,157.89 		"/>
          </g>
          ${withBranding ? '''
            <g>
              <g fill="$brandingColor">
                <path d="M190.89,340.21V312.4c0-1.59,0.24-2.92,0.73-3.99c0.49-1.07,1.14-1.92,1.95-2.53c0.81-0.62,1.7-1.06,2.68-1.31
                  c0.97-0.26,1.93-0.39,2.87-0.39c1.17,0,2.62,0.01,4.36,0.02c1.74,0.02,3.59,0.07,5.55,0.17c1.96,0.1,3.85,0.24,5.67,0.44v6.04
                  h-13.59c-1.01,0-1.76,0.27-2.26,0.8c-0.5,0.54-0.76,1.24-0.76,2.12v6.14l14.27,0.39v5.7l-14.27,0.39v13.83H190.89z"/>
                <path d="M227.13,340.3c-1.85,0-3.38-0.3-4.6-0.9c-1.22-0.6-2.12-1.53-2.7-2.78c-0.58-1.25-0.88-2.87-0.88-4.85v-28.73h7.21v27.66
                  c0,0.97,0.1,1.75,0.29,2.31c0.2,0.57,0.5,0.98,0.9,1.24c0.41,0.26,0.92,0.44,1.53,0.54l2,0.29v5.21H227.13z"/>
                <path d="M239.74,340.5c-1.98,0-3.59-0.58-4.82-1.75c-1.23-1.17-1.85-2.79-1.85-4.87v-2.34c0-1.98,0.7-3.61,2.09-4.9
                  c1.4-1.28,3.57-1.92,6.53-1.92h6.67v-1.8c0-0.81-0.15-1.49-0.44-2.02c-0.29-0.54-0.84-0.93-1.63-1.17
                  c-0.8-0.24-2.01-0.37-3.63-0.37h-7.84v-4.19c1.27-0.39,2.73-0.73,4.41-1.02c1.67-0.29,3.69-0.44,6.06-0.44
                  c2.18,0,4.03,0.26,5.58,0.78c1.54,0.52,2.71,1.41,3.51,2.68s1.19,3.02,1.19,5.26v17.78h-5.7l-1.17-2.78
                  c-0.23,0.26-0.62,0.55-1.17,0.88c-0.55,0.33-1.23,0.66-2.02,1c-0.8,0.34-1.69,0.62-2.68,0.85
                  C241.84,340.39,240.81,340.5,239.74,340.5z M243.39,335.48c0.32,0,0.69-0.04,1.1-0.12s0.83-0.18,1.27-0.29
                  c0.44-0.11,0.84-0.23,1.22-0.34c0.37-0.11,0.68-0.22,0.93-0.32s0.4-0.16,0.46-0.19v-6.09l-4.38,0.29c-1.27,0.1-2.2,0.42-2.8,0.97
                  c-0.6,0.55-0.9,1.3-0.9,2.24v1.07c0,0.65,0.14,1.19,0.41,1.61c0.28,0.42,0.65,0.72,1.12,0.9
                  C242.28,335.39,242.81,335.48,243.39,335.48z"/>
                <path d="M270.47,340.5c-0.81,0-1.69-0.02-2.63-0.07s-1.88-0.12-2.82-0.22c-0.94-0.1-1.82-0.22-2.63-0.37
                  c-0.81-0.15-1.49-0.32-2.04-0.51v-4.24h11.59c0.68,0,1.24-0.06,1.68-0.17c0.44-0.11,0.76-0.32,0.97-0.63
                  c0.21-0.31,0.32-0.75,0.32-1.34v-0.83c0-0.65-0.21-1.15-0.63-1.51c-0.42-0.36-1.2-0.54-2.34-0.54h-4.09
                  c-1.49,0-2.84-0.23-4.04-0.68c-1.2-0.45-2.15-1.2-2.85-2.24c-0.7-1.04-1.05-2.44-1.05-4.19v-1.51c0-1.66,0.32-3.05,0.97-4.19
                  c0.65-1.14,1.74-2,3.26-2.58c1.53-0.58,3.62-0.88,6.28-0.88c1.07,0,2.22,0.06,3.43,0.17c1.22,0.11,2.37,0.26,3.46,0.44
                  c1.09,0.18,1.96,0.38,2.61,0.61v4.24h-10.96c-0.94,0-1.66,0.15-2.14,0.46c-0.49,0.31-0.73,0.88-0.73,1.73v0.78
                  c0,0.59,0.11,1.02,0.34,1.29c0.23,0.28,0.58,0.47,1.05,0.58c0.47,0.11,1.06,0.17,1.78,0.17h4.19c2.66,0,4.6,0.61,5.82,1.83
                  c1.22,1.22,1.83,2.9,1.83,5.04v2.34c0,1.75-0.41,3.14-1.24,4.16c-0.83,1.02-2.03,1.75-3.6,2.19
                  C274.66,340.28,272.74,340.5,270.47,340.5z"/>
                <path d="M285.57,340.21V303.1h7.21v13.64c0.94-0.78,2.17-1.49,3.68-2.14c1.51-0.65,3.06-0.97,4.65-0.97
                  c1.98,0,3.56,0.39,4.72,1.17c1.17,0.78,2.01,1.87,2.53,3.26c0.52,1.4,0.78,3.02,0.78,4.87v17.29h-7.21v-16.36
                  c0-0.84-0.16-1.54-0.49-2.09c-0.32-0.55-0.76-0.97-1.31-1.24c-0.55-0.28-1.2-0.41-1.95-0.41c-0.68,0-1.34,0.09-1.97,0.27
                  c-0.63,0.18-1.23,0.41-1.8,0.71c-0.57,0.29-1.11,0.62-1.63,0.97v18.17H285.57z"/>
              </g>
              <g fill="#${isDark ? 'ffffff' : '000000'}">
                <path d="M323.41,340.21c-1.85,0-3.42-0.28-4.7-0.85c-1.28-0.57-2.24-1.48-2.87-2.73c-0.63-1.25-0.95-2.9-0.95-4.94v-27.52h7.21
                  v26.35c0,0.78,0.14,1.41,0.41,1.9c0.28,0.49,0.66,0.82,1.15,1c0.49,0.18,1.04,0.27,1.66,0.27h11.4v6.53H323.41z"/>
                <path d="M341.47,310.21c-0.68,0-1.02-0.32-1.02-0.97v-4.77c0-0.68,0.34-1.02,1.02-1.02h5.55c0.29,0,0.52,0.1,0.68,0.29
                  s0.24,0.44,0.24,0.73v4.77c0,0.65-0.31,0.97-0.92,0.97H341.47z M340.6,340.21v-26.15h7.21v26.15H340.6z"/>
                <path d="M362.85,340.5c-0.81,0-1.69-0.02-2.63-0.07s-1.88-0.12-2.82-0.22c-0.94-0.1-1.82-0.22-2.63-0.37
                  c-0.81-0.15-1.49-0.32-2.04-0.51v-4.24h11.59c0.68,0,1.24-0.06,1.68-0.17c0.44-0.11,0.76-0.32,0.97-0.63
                  c0.21-0.31,0.32-0.75,0.32-1.34v-0.83c0-0.65-0.21-1.15-0.63-1.51c-0.42-0.36-1.2-0.54-2.34-0.54h-4.09
                  c-1.49,0-2.84-0.23-4.04-0.68c-1.2-0.45-2.15-1.2-2.85-2.24c-0.7-1.04-1.05-2.44-1.05-4.19v-1.51c0-1.66,0.32-3.05,0.97-4.19
                  c0.65-1.14,1.74-2,3.26-2.58c1.53-0.58,3.62-0.88,6.28-0.88c1.07,0,2.22,0.06,3.43,0.17s2.37,0.26,3.46,0.44
                  c1.09,0.18,1.96,0.38,2.61,0.61v4.24h-10.96c-0.94,0-1.66,0.15-2.14,0.46c-0.49,0.31-0.73,0.88-0.73,1.73v0.78
                  c0,0.59,0.11,1.02,0.34,1.29c0.23,0.28,0.58,0.47,1.05,0.58c0.47,0.11,1.06,0.17,1.78,0.17h4.19c2.66,0,4.6,0.61,5.82,1.83
                  c1.22,1.22,1.83,2.9,1.83,5.04v2.34c0,1.75-0.41,3.14-1.24,4.16c-0.83,1.02-2.03,1.75-3.6,2.19
                  C367.05,340.28,365.12,340.5,362.85,340.5z"/>
                <path d="M387.88,340.21c-2.01,0-3.64-0.29-4.89-0.88c-1.25-0.58-2.15-1.56-2.7-2.92c-0.55-1.36-0.8-3.2-0.73-5.5l0.24-11.05h-4.09
                  v-4.63l4.33-1.17l0.97-7.31h5.7v7.31h6.14v5.8h-6.14v11.01c0,0.71,0.06,1.3,0.2,1.75c0.13,0.46,0.32,0.82,0.56,1.1
                  c0.24,0.28,0.53,0.48,0.85,0.61c0.32,0.13,0.65,0.21,0.97,0.24l3.31,0.29v5.36H387.88z"/>
              </g>
            </g>
          ''' : ''}
        </g>
      </svg>
    ''';

    return SvgPicture.string(
      svgString,
      width: width,
      height: height,
    );
  }
}
