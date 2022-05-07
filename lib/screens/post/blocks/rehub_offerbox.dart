import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_badge.dart';
import 'package:cirilla/widgets/cirilla_rating.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RehubOfferbox extends StatelessWidget with Utility {
  final Map<String, dynamic> block;

  const RehubOfferbox({Key key, this.block}) : super(key: key);

  Widget buildCoupon(BuildContext context, {String coupon, bool checkExpire}) {
    ThemeData theme = Theme.of(context);
    Color color = checkExpire ? theme.primaryColor : theme.colorScheme.onSurface;
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(4),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      color: color,
      child: Text(
        coupon,
        style: theme.textTheme.caption.copyWith(color: color, decoration: TextDecoration.lineThrough),
      ),
    );
  }

  void share(String url) {
    if (url is String && url != '') {
      launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context).translate;

    Map attrs = get(block, ['attrs'], {});

    Color borderColor = ConvertData.fromHex(get(attrs, ['borderColor'], ''), Colors.transparent);
    String urlImage = get(attrs, ['thumbnail', 'url'], '');
    String salePrice = get(attrs, ['sale_price'], '');
    String oldPrice = get(attrs, ['old_price'], '');
    String name = get(attrs, ['name'], '');
    String disclaimer = get(attrs, ['disclaimer'], '');
    String description = get(attrs, ['description'], '');
    String couponCode = get(attrs, ['coupon_code'], '');
    bool maskCoupon = get(attrs, ['mask_coupon_code'], false);
    String textButton = get(attrs, ['button', 'text'], translate('post_detail_offerbox_button'));
    String urlButton = get(attrs, ['button', 'url'], '');
    String maskText = get(attrs, ['mask_coupon_text'], translate('post_detail_offerbox_reveal'));
    String expireDate = get(attrs, ['expiration_date'], '');
    int discount = ConvertData.stringToInt(get(attrs, ['discount_tag'], 0), 0);
    int rating = ConvertData.stringToInt(get(attrs, ['rating'], 0), 0);

    bool checkExpire = expireDate.isNotEmpty ? compareSpaceDate(date: expireDate, space: 0) : false;

    return Container(
      decoration: BoxDecoration(border: Border.all(color: borderColor, width: 1)),
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              child: Stack(
                children: [
                  if (urlImage.isNotEmpty)
                    Image.network(
                      urlImage,
                      fit: BoxFit.contain,
                    )
                  else
                    Container(),
                  Positioned.directional(
                    textDirection: Directionality.of(context),
                    top: 10,
                    start: 10,
                    child: discount > 0
                        ? CirillaBadge(label: '-$discount%', size: 40, type: CirillaBadgeType.primary)
                        : Container(),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (name.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(name, style: theme.textTheme.headline4),
                  ),
                if (rating > 0)
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: CirillaRating(initialValue: rating.toDouble(), size: 20),
                  ),
                if (salePrice.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: [
                      Text(salePrice, style: theme.textTheme.subtitle1.copyWith(color: Color(0xFFF01F0E))),
                      if (oldPrice.isNotEmpty) Text(oldPrice, style: theme.textTheme.subtitle2),
                    ],
                  ),
                if (disclaimer.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(disclaimer, style: theme.textTheme.caption.copyWith(color: theme.primaryColor)),
                  ),
                SizedBox(
                  height: 34,
                  child: ElevatedButton(
                    onPressed: () => share(urlButton),
                    child: Text(maskCoupon ? maskText : textButton),
                  ),
                ),
                if (!maskCoupon && couponCode.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: buildCoupon(context, coupon: couponCode, checkExpire: checkExpire),
                  ),
                if (expireDate.isNotEmpty)
                  Text(checkExpire ? '5 days' : translate('expired'), style: theme.textTheme.overline),
                if (disclaimer.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(description, style: theme.textTheme.bodyText2),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
