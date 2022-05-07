import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;

class BlockImage extends StatelessWidget {
  final Map<String, dynamic> block;

  const BlockImage({Key key, this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var document = parse(block['innerHTML']);

    var image = document.getElementsByTagName("img")[0];

    if (image.attributes['src'] == null || image.attributes['src'] == "") return Container();

    return LayoutBuilder(builder: (_, BoxConstraints constraints) {
      if (image.attributes['src'] == null || image.attributes['height'] == null) {
        return Image.network(image.attributes['src']);
      }
      double screenWidth = constraints.maxWidth;
      double width = ConvertData.stringToDouble(image.attributes['width'], screenWidth);
      double height = ConvertData.stringToDouble(image.attributes['height'], screenWidth);

      if (width > screenWidth) {
        height = (screenWidth * height) / width;
        width = screenWidth;
      }
      return CirillaCacheImage(image.attributes['src'], width: width, height: height);
    });
  }
}
