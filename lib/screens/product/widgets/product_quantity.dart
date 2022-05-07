import 'package:cirilla/widgets/cirilla_quantity.dart';
import 'package:flutter/material.dart';

class ProductQuantity extends StatelessWidget {
  final String align;
  final int qty;
  final ValueChanged<int> onChanged;

  const ProductQuantity({Key key, this.align = 'left', this.qty = 1, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AlignmentDirectional alignment = align == 'right'
        ? AlignmentDirectional.centerEnd
        : align == 'center'
            ? AlignmentDirectional.center
            : AlignmentDirectional.centerStart;
    return Container(
      alignment: alignment,
      child: CirillaQuantity(
        onChanged: onChanged,
        min: 1,
        max: 1000,
        value: qty,
        color: Theme.of(context).colorScheme.surface,
        size: 48,
        radius: 8,
      ),
    );
  }
}
