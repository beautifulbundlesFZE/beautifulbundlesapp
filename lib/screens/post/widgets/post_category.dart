import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:flutter/material.dart';

class PostCategory extends StatelessWidget with PostMixin {
  final Post post;
  final Color background;
  final Color color;
  final double radius;

  PostCategory({
    Key key,
    this.post,
    this.background,
    this.color,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return buildCategory(theme, post, false, background, color, radius);
  }
}
