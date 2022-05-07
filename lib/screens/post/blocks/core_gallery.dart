import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;

class BlockGallery extends StatelessWidget {
  final Map<String, dynamic> block;

  const BlockGallery({Key key, this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var document = parse(block['innerHTML']);
    double screenWidth = MediaQuery.of(context).size.width;

    var images = document.getElementsByTagName("figure");

    if (images == null || images.length == 0) return Container();

    List<Widget> _images = [];

    for (int i = 0; i < images.length; i++) {
      var image = images[i].getElementsByTagName("img")[0];

      double width = ConvertData.stringToDouble(image.attributes['width'], screenWidth);
      double height = ConvertData.stringToDouble(image.attributes['height'], screenWidth);

      _images.add(Column(
        children: [
          CirillaCacheImage(
            image.attributes['src'],
            width: width,
            height: height,
          ),
          SizedBox(height: 20)
        ],
      ));
    }

    return Column(
      children: _images,
    );
  }
}
