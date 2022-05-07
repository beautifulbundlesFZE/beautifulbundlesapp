import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/models/cart/cart.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/screens/product/product.dart';
import 'package:cirilla/widgets/cirilla_quantity.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:ui/ui.dart';
import 'package:cirilla/mixins/cart_mixin.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'dart:async';

class Item extends StatefulWidget {
  final CartItem cartItem;

  final Function onRemove;

  final Function(BuildContext context, CartItem cartItem, int value) updateQuantity;

  const Item({Key key, this.cartItem, this.onRemove, this.updateQuantity}) : super(key: key);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> with Utility, CartMixin, SnackMixin {
  int _qty = 0;

  Timer timer;
  int milliseconds = 250;
  int index;

  Future<void> onChanged(int value) async {
    if (value <= get(widget.cartItem.quantityLimit, [], 0)) {
      setState(() {
        _qty = value;
      });
      if (timer != null) {
        timer?.cancel();
      }
      timer = Timer(Duration(milliseconds: milliseconds), () => widget.updateQuantity(context, widget.cartItem, value));
    }
  }

  @override
  void didChangeDependencies() {
    setState(() {
      _qty = get(widget.cartItem.quantity, [], 0);
    });
    super.didChangeDependencies();
  }

  void _navigate() {
    if (widget.cartItem.variation != null && widget.cartItem.variation.length > 0) {
      Navigator.of(context).pushNamed(ProductScreen.routeName, arguments: {'variation_id': widget.cartItem.id});
    } else {
      Navigator.of(context).pushNamed(ProductScreen.routeName, arguments: {'id': widget.cartItem.id});
    }
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String name = get(widget.cartItem.name, [], '');

    String currencyCode = get(widget.cartItem.prices, ['currency_code'], null);

    int unit = get(widget.cartItem.prices, ['currency_minor_unit'], 0);

    ThemeData theme = Theme.of(context);

    TextTheme textTheme = theme.textTheme;

    return ProductCartItem(
      padding: EdgeInsets.symmetric(horizontal: layoutPadding, vertical: itemPaddingLarge),
      image: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: _navigate,
          child: _buildImage(),
        ),
      ),
      name: InkWell(
        onTap: _navigate,
        child: Html(data: "<div>$name</div>", style: {
          "div": Style(fontSize: FontSize(14.0), fontWeight: FontWeight.w500, color: textTheme.subtitle1.color),
          "body": Style(margin: EdgeInsets.zero),
        }),
      ),
      attribute: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(widget.cartItem.variation.length, (index) {
            Map variation = widget.cartItem.variation.elementAt(index);
            String attribute = get(variation, ['attribute'], '');
            String value = get(variation, ['value'], '');
            return RichText(
              text: TextSpan(
                text: '$attribute: ',
                style: textTheme.caption,
                children: <TextSpan>[
                  TextSpan(text: value, style: textTheme.caption.copyWith(color: textTheme.subtitle1.color)),
                ],
              ),
            );
          })
        ],
      ),
      price: Text(convertCurrency(context, currency: currencyCode, price: widget.cartItem.prices['price'], unit: unit),
          style: textTheme.subtitle2),
      quantity: CirillaQuantity(
        value: _qty,
        color: theme.colorScheme.surface,
        textStyle: textTheme.bodyText2.copyWith(color: textTheme.subtitle1.color),
        onChanged: onChanged,
      ),
      remove: InkResponse(
        onTap: widget.onRemove,
        radius: 16,
        child: Icon(FeatherIcons.trash2, size: 14, color: textTheme.bodyText1.color),
      ),
      onClick: () => {},
    );
  }

  Widget _buildImage() {
    return ImageLoading(
      widget.cartItem.images.isEmpty
          ? Assets.noImageUrl
          : widget.cartItem.images.elementAt(0)['thumbnail'] ?? Assets.noImageUrl,
      width: 86,
      height: 102,
      fit: BoxFit.cover,
    );
  }
}
