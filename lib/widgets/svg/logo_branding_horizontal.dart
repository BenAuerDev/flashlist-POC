import 'package:flashlist/utils/context_retriever.dart';
import 'package:flashlist/widgets/svg/logo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoBrandingHorizontal extends StatelessWidget {
  /// A Custom Widget returning the FlashList Logo with Branding in [Horizontal] orientation
  ///
  /// Branding text can be hidden by setting [withBranding] to false
  ///
  /// The [color] can be set to [LogoTheme.black], [LogoTheme.white] or default is [LogoTheme.color]
  ///
  /// The [width] and [height] can be set to any value but should be the same
  const LogoBrandingHorizontal({
    super.key,
    this.width = 595,
    this.height = 420,
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
          <g fill="#${isDark ? 'ffffff' : '000000'}">
            <polygon points="96.79,280.82 54,280.82 54,138.7 96.79,138.7 96.79,149.42 64.72,149.42 64.72,270.1 96.79,270.1 			"/>
          
            <polygon points="217,280.82 174.21,280.82 174.21,270.1 206.28,270.1 206.28,149.42 174.21,149.42 174.21,138.7 217,138.7 			"/>
          </g>
          <polygon fill="$brandingColor" points="144.38,202.18 146.34,143.31 121.07,183.07 101.28,217.35 126.68,217.35 124.73,276.22 150,236.46 169.79,202.18 
                "/>
        </g>
        <g>
          <g fill="$brandingColor">
            <path d="M291.23,220.21v-34.43c0-1.97,0.3-3.62,0.91-4.94c0.6-1.33,1.41-2.37,2.41-3.13c1-0.76,2.11-1.31,3.32-1.63
              c1.21-0.32,2.39-0.48,3.56-0.48c1.45,0,3.25,0.01,5.4,0.03c2.15,0.02,4.44,0.09,6.87,0.21c2.43,0.12,4.77,0.3,7.02,0.54v7.48
              h-16.82c-1.25,0-2.18,0.33-2.8,0.99c-0.62,0.66-0.94,1.54-0.94,2.62v7.6l17.67,0.48v7.05l-17.67,0.48v17.12H291.23z"/>
            <path d="M336.09,220.33c-2.29,0-4.19-0.37-5.7-1.12c-1.51-0.74-2.62-1.89-3.35-3.44c-0.72-1.55-1.09-3.55-1.09-6V174.2h8.92v34.25
              c0,1.21,0.12,2.16,0.36,2.87c0.24,0.7,0.61,1.22,1.11,1.54c0.5,0.32,1.14,0.54,1.9,0.66l2.47,0.36v6.45H336.09z"/>
            <path d="M351.71,220.57c-2.45,0-4.44-0.72-5.97-2.17c-1.53-1.45-2.29-3.46-2.29-6.03v-2.89c0-2.45,0.86-4.47,2.59-6.06
              c1.73-1.59,4.42-2.38,8.08-2.38h8.26v-2.23c0-1-0.18-1.84-0.54-2.5c-0.36-0.66-1.03-1.15-2.02-1.45c-0.99-0.3-2.48-0.45-4.49-0.45
              h-9.71v-5.19c1.57-0.48,3.39-0.9,5.46-1.27c2.07-0.36,4.57-0.54,7.51-0.54c2.69,0,4.99,0.32,6.9,0.97
              c1.91,0.64,3.36,1.75,4.34,3.32c0.99,1.57,1.48,3.74,1.48,6.51v22.01h-7.06l-1.45-3.44c-0.28,0.32-0.76,0.68-1.45,1.08
              c-0.68,0.4-1.52,0.82-2.5,1.24s-2.09,0.77-3.32,1.05C354.31,220.43,353.03,220.57,351.71,220.57z M356.23,214.36
              c0.4,0,0.85-0.05,1.36-0.15c0.5-0.1,1.02-0.22,1.57-0.36c0.54-0.14,1.05-0.28,1.51-0.42c0.46-0.14,0.85-0.27,1.15-0.39
              c0.3-0.12,0.49-0.2,0.57-0.24v-7.54l-5.43,0.36c-1.57,0.12-2.72,0.52-3.47,1.21c-0.74,0.68-1.11,1.61-1.11,2.77v1.33
              c0,0.8,0.17,1.47,0.51,1.99s0.8,0.89,1.39,1.11C354.85,214.25,355.5,214.36,356.23,214.36z"/>
            <path d="M389.75,220.57c-1.01,0-2.09-0.03-3.26-0.09c-1.17-0.06-2.33-0.15-3.5-0.27c-1.17-0.12-2.25-0.27-3.26-0.45
              c-1.01-0.18-1.85-0.39-2.53-0.63v-5.25h14.35c0.84,0,1.54-0.07,2.08-0.21c0.54-0.14,0.94-0.4,1.21-0.78s0.39-0.94,0.39-1.66v-1.02
              c0-0.8-0.26-1.43-0.78-1.87c-0.52-0.44-1.49-0.66-2.9-0.66h-5.06c-1.85,0-3.52-0.28-5-0.85c-1.49-0.56-2.66-1.49-3.53-2.77
              c-0.86-1.28-1.3-3.01-1.3-5.18V197c0-2.05,0.4-3.78,1.21-5.19c0.8-1.41,2.15-2.47,4.04-3.2c1.89-0.72,4.48-1.08,7.78-1.08
              c1.33,0,2.74,0.07,4.25,0.21c1.51,0.14,2.93,0.32,4.28,0.54c1.35,0.22,2.42,0.47,3.23,0.75v5.25h-13.57
              c-1.17,0-2.05,0.19-2.65,0.57c-0.6,0.38-0.9,1.1-0.9,2.14v0.97c0,0.72,0.14,1.26,0.42,1.6c0.28,0.34,0.71,0.58,1.3,0.72
              c0.58,0.14,1.32,0.21,2.2,0.21h5.19c3.3,0,5.7,0.75,7.21,2.26c1.51,1.51,2.26,3.59,2.26,6.24v2.9c0,2.17-0.51,3.89-1.54,5.15
              c-1.02,1.27-2.51,2.17-4.46,2.71C394.95,220.3,392.57,220.57,389.75,220.57z"/>
            <path d="M408.44,220.21v-45.95h8.92v16.88c1.16-0.97,2.68-1.85,4.55-2.65c1.87-0.8,3.79-1.21,5.76-1.21c2.45,0,4.4,0.48,5.85,1.45
              c1.45,0.97,2.49,2.31,3.13,4.04s0.97,3.74,0.97,6.03v21.41h-8.92v-20.26c0-1.05-0.2-1.91-0.6-2.59c-0.4-0.68-0.94-1.19-1.63-1.54
              c-0.68-0.34-1.49-0.51-2.41-0.51c-0.84,0-1.66,0.11-2.44,0.33c-0.78,0.22-1.53,0.51-2.23,0.88c-0.7,0.36-1.38,0.76-2.02,1.21
              v22.49H408.44z"/>
          </g>
          <g fill="#${isDark ? 'ffffff' : '000000'}">
            <path d="M455.29,220.21c-2.29,0-4.23-0.35-5.82-1.05c-1.59-0.7-2.77-1.83-3.56-3.38c-0.78-1.55-1.18-3.59-1.18-6.12v-34.07h8.92
              v32.62c0,0.97,0.17,1.75,0.51,2.35s0.82,1.02,1.42,1.24c0.6,0.22,1.28,0.33,2.05,0.33h14.11v8.08H455.29z"/>
            <path d="M477.66,183.07c-0.85,0-1.27-0.4-1.27-1.21v-5.91c0-0.84,0.42-1.27,1.27-1.27h6.87c0.36,0,0.64,0.12,0.84,0.36
              c0.2,0.24,0.3,0.54,0.3,0.91v5.91c0,0.81-0.38,1.21-1.15,1.21H477.66z M476.58,220.21v-32.38h8.92v32.38H476.58z"/>
            <path d="M504.13,220.57c-1.01,0-2.09-0.03-3.26-0.09c-1.17-0.06-2.33-0.15-3.5-0.27c-1.17-0.12-2.25-0.27-3.26-0.45
              c-1.01-0.18-1.85-0.39-2.53-0.63v-5.25h14.35c0.84,0,1.54-0.07,2.08-0.21c0.54-0.14,0.94-0.4,1.21-0.78s0.39-0.94,0.39-1.66v-1.02
              c0-0.8-0.26-1.43-0.78-1.87c-0.52-0.44-1.49-0.66-2.9-0.66h-5.06c-1.85,0-3.52-0.28-5-0.85c-1.49-0.56-2.66-1.49-3.53-2.77
              c-0.86-1.28-1.3-3.01-1.3-5.18V197c0-2.05,0.4-3.78,1.21-5.19c0.8-1.41,2.15-2.47,4.04-3.2c1.89-0.72,4.48-1.08,7.78-1.08
              c1.33,0,2.74,0.07,4.25,0.21c1.51,0.14,2.93,0.32,4.28,0.54c1.35,0.22,2.42,0.47,3.23,0.75v5.25h-13.57
              c-1.17,0-2.05,0.19-2.65,0.57c-0.6,0.38-0.9,1.1-0.9,2.14v0.97c0,0.72,0.14,1.26,0.42,1.6c0.28,0.34,0.71,0.58,1.3,0.72
              c0.58,0.14,1.32,0.21,2.2,0.21h5.19c3.3,0,5.7,0.75,7.21,2.26c1.51,1.51,2.26,3.59,2.26,6.24v2.9c0,2.17-0.51,3.89-1.54,5.15
              c-1.02,1.27-2.51,2.17-4.46,2.71C509.33,220.3,506.95,220.57,504.13,220.57z"/>
            <path d="M535.13,220.21c-2.49,0-4.51-0.36-6.06-1.08c-1.55-0.72-2.66-1.93-3.35-3.62c-0.68-1.69-0.99-3.96-0.91-6.81l0.3-13.69
              h-5.07v-5.73l5.37-1.45l1.21-9.04h7.05v9.04h7.6v7.18h-7.6v13.63c0,0.88,0.08,1.61,0.24,2.17c0.16,0.56,0.39,1.02,0.69,1.36
              c0.3,0.34,0.65,0.59,1.05,0.75c0.4,0.16,0.8,0.26,1.21,0.3l4.1,0.36v6.63H535.13z"/>
          </g>
        </g>
      </g>
      </svg>

    ''';

    return SvgPicture.string(
      svgString,
      width: width,
      height: height,
      fit: BoxFit.fitWidth,
    );
  }
}
