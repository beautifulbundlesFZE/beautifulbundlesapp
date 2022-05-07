import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;

class ListBlock extends StatelessWidget with Utility {
  final Map<String, dynamic> block;

  const ListBlock({Key key, @required this.block});

  @override
  Widget build(BuildContext context) {
    var document = parse(block['innerHTML']);

    var li = document.getElementsByTagName('li');

    if (li == null || li.length == 0) return Container();

    List<Widget> _li = [];

    for (int i = 0; i < li.length; i++) {
      var title = li[i].text;
      _li.add(Column(
        children: [Text(title), SizedBox(height: 20)],
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _li,
    );
  }
}
