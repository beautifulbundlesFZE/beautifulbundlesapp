import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CirillaRating extends StatelessWidget {
  final double initialValue;
  final int count;
  final double size;
  final Color color;
  final double pad;

  CirillaRating({
    Key key,
    this.initialValue = 0,
    this.count = 5,
    this.size = 12,
    this.color,
    this.pad = 4,
  })  : assert(count >= 0),
        assert(size > 0),
        assert(pad >= 0),
        assert(initialValue >= 0 && initialValue <= count),
        super(key: key);

  factory CirillaRating.select({
    Key key,
    int defaultRating,
    int count,
    double size,
    Color color,
    Color selectColor,
    double pad,
    Function(int value) onFinishRating,
  }) = _CirillaRatingSelect;

  @override
  Widget build(BuildContext context) {
    int visit = initialValue.toInt();
    int valueFloor = initialValue.ceil();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        IconData icon = index < visit
            ? FontAwesomeIcons.solidStar
            : index >= valueFloor
                ? FontAwesomeIcons.star
                : FontAwesomeIcons.starHalfAlt;
        double padRight = index <= count - 1 ? pad : 0;
        return Padding(
          padding: EdgeInsets.only(right: padRight),
          child: Icon(
            icon,
            size: size,
            color: color ?? const Color(0xFFFFA200),
          ),
        );
      }).toList(),
    );
  }
}

class _CirillaRatingSelect extends CirillaRating {
  final int defaultRating;
  final Function(int value) onFinishRating;
  final Color selectColor;

  _CirillaRatingSelect({
    Key key,
    @required this.onFinishRating,
    this.defaultRating = 3,
    int count = 5,
    double size = 20,
    Color color,
    this.selectColor = const Color(0xFFFFA200),
    double pad = 4,
  })  : assert(count > 0),
        assert(size > 0),
        assert(pad >= 0),
        assert(defaultRating >= 0 && defaultRating <= count),
        super(
          key: key,
          count: count,
          size: size,
          color: color,
          pad: pad,
        );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        IconData icon = index < defaultRating ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star;
        Color colorIcon = index < defaultRating ? selectColor : color;
        double padRight = index <= count - 1 ? pad : 0;
        return Padding(
          padding: EdgeInsets.only(right: padRight),
          child: InkWell(
            onTap: () => onFinishRating(index + 1),
            child: Icon(
              icon,
              size: size,
              color: colorIcon,
            ),
          ),
        );
      }).toList(),
    );
  }
}
