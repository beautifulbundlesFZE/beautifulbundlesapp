import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;

Map<String, double> size = {'small': 14.0, 'normal': 16.0, 'medium': 23.0, 'large': 26.0, 'Huge': 37.0};

class Heading extends StatelessWidget with Utility {
  final Map<String, dynamic> block;
  const Heading({Key key, @required this.block});
  @override
  Widget build(BuildContext context) {
    var document = parse(block['innerHTML']);

    Map attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};

    Map style = get(attrs, ['style'], {}) is Map ? get(attrs, ['style'], {}) : {};

    int level = get(attrs, ['level'], 2);

    String align = get(attrs, ['textAlign'], 'left');

    double fontCustom = ConvertData.stringToDouble(get(style, ['typography', 'fontSize']), null);

    String fontDefault = get(attrs, ['fontSize']);

    bool bold = document.getElementsByTagName('strong').isNotEmpty;

    bool italic = document.getElementsByTagName('em').isNotEmpty;

    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle textStyle = level == 1
        ? textTheme.headline1
        : level == 2
            ? textTheme.headline2
            : level == 3
                ? textTheme.headline3
                : level == 4
                    ? textTheme.headline4
                    : level == 6
                        ? textTheme.headline6
                        : textTheme.headline5;
    return Container(
      width: double.infinity,
      child: Text(document.body.text,
          style: textStyle.copyWith(
            fontWeight: bold == true ? FontWeight.bold : null,
            fontStyle: italic == true ? FontStyle.italic : null,
            fontSize: fontCustom ?? size[fontDefault],
          ),
          textAlign: align == 'center'
              ? TextAlign.center
              : align == 'right'
                  ? TextAlign.right
                  : TextAlign.left),
    );
  }
}
