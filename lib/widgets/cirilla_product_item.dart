import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/cart_mixin.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/mixins/product_mixin.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/models/product/product_type.dart';
import 'package:cirilla/screens/product/product.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/ui.dart';
import 'package:url_launcher/url_launcher.dart';

class CirillaProductItem extends StatefulWidget {
  final Product product;

  // Product item template
  final String template;

  final double width;

  final double height;

  final Map<String, dynamic> dataTemplate;

  final Color background;
  final Color textColor;
  final Color subTextColor;
  final Color priceColor;
  final Color salePriceColor;
  final Color regularPriceColor;
  final Color wishlistColor;

  final Color labelNewColor;
  final Color labelNewTextColor;
  final double labelNewRadius;

  final Color labelSaleColor;
  final Color labelSaleTextColor;
  final double labelSaleRadius;

  final IconData iconAddCart;
  final double radiusAddCart;
  final bool outlineAddCart;

  final double radius;
  final double radiusImage;

  final List<BoxShadow> boxShadow;

  final Border border;
  final EdgeInsetsGeometry padding;

  const CirillaProductItem({
    Key key,
    this.product,
    this.template = Strings.productItemContained,
    this.width = 160,
    this.height = 190,
    this.dataTemplate = const {},
    this.background,
    this.textColor,
    this.subTextColor,
    this.priceColor,
    this.salePriceColor,
    this.regularPriceColor,
    this.wishlistColor,
    this.labelNewColor,
    this.labelNewTextColor,
    this.labelNewRadius = 10,
    this.labelSaleColor,
    this.labelSaleTextColor,
    this.labelSaleRadius = 10,
    this.radius = 0,
    this.radiusImage = 10,
    this.boxShadow,
    this.border,
    this.iconAddCart,
    this.outlineAddCart,
    this.radiusAddCart,
    this.padding,
  }) : super(key: key);

  @override
  _CirillaProductItemState createState() => _CirillaProductItemState();
}

class _CirillaProductItemState extends State<CirillaProductItem>
    with CartMixin, SnackMixin, ProductMixin, Utility, WishListMixin, LoadingMixin {
  bool _loading = false;
  SettingStore _settingStore;
  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    super.didChangeDependencies();
  }

  ///
  /// Handle add to cart
  Future<void> _handleAddToCart(BuildContext context) async {
    if (widget.product == null || widget.product.id == null) return;

    if (widget.product.type == ProductType.external) {
      await launch(widget.product.externalUrl);
      return;
    }

    if (widget.product.type == ProductType.variable || widget.product.type == ProductType.grouped) {
      _navigate(context);
      return;
    }

    setState(() {
      _loading = true;
    });
    try {
      await addToCart(productId: widget.product.id, qty: 1);
      showSuccess(context, AppLocalizations.of(context).translate('product_add_to_cart_success'));
      setState(() {
        _loading = false;
      });
    } catch (e) {
      showError(context, e);
      setState(() {
        _loading = false;
      });
    }
  }

  ///
  /// Handle navigate
  void _navigate(BuildContext context) {
    if (widget.product == null || widget.product.id == null) return;
    Navigator.pushNamed(context, ProductScreen.routeName, arguments: {'product': widget.product});
  }

  ///
  /// Handle wishlist
  void _wishlist(BuildContext context) {
    if (widget.product == null || widget.product.id == null) return;
    addWishList(productId: widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context).translate;

    String themeModeKey = _settingStore.themeModeKey;

    bool enableLabelNew = get(widget.dataTemplate, ['enableLabelNew'], true);
    bool enableLabelSale = get(widget.dataTemplate, ['enableLabelSale'], true);
    bool enableCategory = get(widget.dataTemplate, ['enableCategory'], true);
    bool enableRating = get(widget.dataTemplate, ['enableRating'], true);
    BoxFit fit = ConvertData.toBoxFit(get(widget.dataTemplate, ['imageSize'], 'cover'));

    TextStyle stylePrice = theme.textTheme.subtitle2.copyWith(color: widget.priceColor);
    TextStyle styleSale = theme.textTheme.subtitle2.copyWith(color: widget.salePriceColor ?? Color(0xFFF01F0E));
    TextStyle styleRegular =
        theme.textTheme.subtitle2.copyWith(color: widget.regularPriceColor, fontWeight: FontWeight.normal);
    TextStyle styleTextFrom = theme.textTheme.caption.copyWith(color: widget.subTextColor);
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth;
        switch (widget.template) {
          case Strings.productItemHorizontal:
            double widthImage = 86;
            double heightImage = (widthImage * widget.height) / widget.width;
            double widthView = widget?.width != null
                ? widget.width
                : maxWidth != double.infinity
                    ? maxWidth
                    : 335;
            return SizedBox(
              width: widthView,
              child: ProductHorizontalItem(
                image: buildImage(
                  context,
                  product: widget.product,
                  width: widthImage,
                  height: heightImage,
                  borderRadius: widget.radiusImage,
                  fit: fit,
                ),
                name: buildName(
                  context,
                  product: widget.product,
                  style: theme.textTheme.bodyText2.copyWith(color: widget.textColor),
                ),
                price: buildPrice(
                  context,
                  product: widget.product,
                  priceStyle: stylePrice,
                  saleStyle: styleSale,
                  regularStyle: styleRegular,
                  styleFrom: styleTextFrom,
                ),
                tagExtra: enableLabelNew || enableLabelSale
                    ? buildTagExtra(
                        context,
                        product: widget.product,
                        enableNew: enableLabelNew,
                        newColor: widget.labelNewColor,
                        newTextColor: widget.labelNewTextColor,
                        newRadius: widget.labelNewRadius,
                        enableSale: enableLabelSale,
                        saleColor: widget.labelSaleColor,
                        saleTextColor: widget.labelSaleTextColor,
                        saleRadius: widget.labelSaleRadius,
                      )
                    : null,
                addCard: _loading
                    ? _buildLoading(context)
                    : buildAddCart(
                        context,
                        product: widget.product,
                        onTap: () => _handleAddToCart(context),
                        icon: widget?.iconAddCart ?? FeatherIcons.plus,
                        radius: widget?.radiusAddCart ?? 8,
                        isButtonOutline: widget?.outlineAddCart ?? false,
                      ),
                rating: enableRating ? buildRating(context, product: widget.product, color: widget.subTextColor) : null,
                borderRadius: BorderRadius.circular(widget.radius),
                border: widget.border,
                boxShadow: widget.boxShadow,
                color: widget.background ?? Colors.transparent,
                onClick: () => _navigate(context),
                padding: widget?.padding ?? EdgeInsets.zero,
              ),
            );
          case Strings.productItemEmerge:
            return ProductEmergeItem(
              image: buildImage(
                context,
                product: widget.product,
                width: widget.width,
                height: widget.height,
                borderRadius: widget.radiusImage,
                fit: fit,
              ),
              name: buildName(
                context,
                product: widget.product,
                style: theme.textTheme.subtitle1.copyWith(color: widget.textColor),
              ),
              price: buildPrice(
                context,
                product: widget.product,
                priceStyle: stylePrice,
                saleStyle: styleSale,
                regularStyle: styleRegular,
                styleFrom: styleTextFrom,
              ),
              tagExtra: enableLabelNew || enableLabelSale
                  ? buildTagExtra(
                      context,
                      product: widget.product,
                      enableNew: enableLabelNew,
                      newColor: widget.labelNewColor,
                      newTextColor: widget.labelNewTextColor,
                      newRadius: widget.labelNewRadius,
                      enableSale: enableLabelSale,
                      saleColor: widget.labelSaleColor,
                      saleTextColor: widget.labelSaleTextColor,
                      saleRadius: widget.labelSaleRadius,
                    )
                  : null,
              addCart: _loading
                  ? _buildLoading(context)
                  : buildAddCart(
                      context,
                      product: widget.product,
                      onTap: () => _handleAddToCart(context),
                      icon: widget?.iconAddCart ?? FeatherIcons.plus,
                      radius: widget?.radiusAddCart ?? 34,
                      isButtonOutline: widget?.outlineAddCart ?? false,
                    ),
              rating: enableRating ? buildRating(context, product: widget.product, color: widget.subTextColor) : null,
              category:
                  enableCategory ? buildCategory(context, product: widget.product, color: widget.subTextColor) : null,
              wishlist: buildWishlist(
                context,
                product: widget.product,
                isSelected: existWishList(productId: widget.product.id),
                color: widget.wishlistColor,
                onTap: () => _wishlist(context),
              ),
              width: widget.width,
              borderRadius: BorderRadius.circular(widget.radius),
              border: widget.border,
              boxShadow: widget.boxShadow,
              color: widget.background,
              padding: widget.padding,
              onClick: () => _navigate(context),
            );
          case Strings.productItemVertical:
            return ProductVerticalItem(
              image: buildImage(
                context,
                product: widget.product,
                width: widget.width,
                height: widget.height,
                borderRadius: widget.radiusImage,
                fit: fit,
              ),
              name: buildName(
                context,
                product: widget.product,
                style: theme.textTheme.subtitle1.copyWith(color: widget.textColor),
              ),
              price: buildPrice(
                context,
                product: widget.product,
                priceStyle: stylePrice,
                saleStyle: styleSale,
                regularStyle: styleRegular,
                styleFrom: styleTextFrom,
              ),
              tagExtra: enableLabelNew || enableLabelSale
                  ? buildTagExtra(
                      context,
                      product: widget.product,
                      enableNew: enableLabelNew,
                      newColor: widget.labelNewColor,
                      newTextColor: widget.labelNewTextColor,
                      newRadius: widget.labelNewRadius,
                      enableSale: enableLabelSale,
                      saleColor: widget.labelSaleColor,
                      saleTextColor: widget.labelSaleTextColor,
                      saleRadius: widget.labelSaleRadius,
                    )
                  : null,
              addCard: _loading
                  ? _buildLoading(context)
                  : buildAddCart(
                      context,
                      product: widget.product,
                      icon: widget?.iconAddCart ?? FeatherIcons.plus,
                      radius: widget?.radiusAddCart ?? 34,
                      isButtonOutline: widget?.outlineAddCart ?? false,
                      onTap: () => _handleAddToCart(context),
                    ),
              rating: enableRating ? buildRating(context, product: widget.product, color: widget.subTextColor) : null,
              category:
                  enableCategory ? buildCategory(context, product: widget.product, color: widget.subTextColor) : null,
              wishlist: buildWishlist(
                context,
                product: widget.product,
                color: widget.wishlistColor,
                isSelected: existWishList(productId: widget.product.id),
                onTap: () => _wishlist(context),
              ),
              width: widget.width,
              borderRadius: BorderRadius.circular(widget.radius),
              border: widget.border,
              boxShadow: widget.boxShadow,
              color: widget.background,
              padding: widget.padding,
              onClick: () => _navigate(context),
            );
          case Strings.productItemVerticalCenter:
            return ProductVerticalItem(
              image: buildImage(
                context,
                product: widget.product,
                width: widget.width,
                height: widget.height,
                borderRadius: widget.radiusImage,
                fit: fit,
              ),
              name: buildName(
                context,
                product: widget.product,
                style: theme.textTheme.subtitle1.copyWith(color: widget.textColor),
              ),
              price: buildPrice(
                context,
                product: widget.product,
                priceStyle: stylePrice,
                saleStyle: styleSale,
                regularStyle: styleRegular,
                styleFrom: styleTextFrom,
              ),
              tagExtra: enableLabelNew || enableLabelSale
                  ? buildTagExtra(
                      context,
                      product: widget.product,
                      enableNew: enableLabelNew,
                      newColor: widget.labelNewColor,
                      newTextColor: widget.labelNewTextColor,
                      newRadius: widget.labelNewRadius,
                      enableSale: enableLabelSale,
                      saleColor: widget.labelSaleColor,
                      saleTextColor: widget.labelSaleTextColor,
                      saleRadius: widget.labelSaleRadius,
                    )
                  : null,
              addCard: _loading
                  ? _buildLoading(context)
                  : buildAddCart(
                      context,
                      product: widget.product,
                      icon: widget.iconAddCart,
                      text: translate('product_add_to_cart'),
                      isButtonOutline: widget?.outlineAddCart ?? true,
                      radius: widget?.radiusAddCart ?? 8,
                      onTap: () => _handleAddToCart(context),
                    ),
              rating: enableRating ? buildRating(context, product: widget.product, color: widget.subTextColor) : null,
              category:
                  enableCategory ? buildCategory(context, product: widget.product, color: widget.subTextColor) : false,
              wishlist: buildWishlist(
                context,
                product: widget.product,
                color: widget.wishlistColor,
                isSelected: existWishList(productId: widget.product.id),
                onTap: () => _wishlist(context),
              ),
              width: widget.width,
              type: ProductVerticalItemType.center,
              borderRadius: BorderRadius.circular(widget.radius),
              border: widget.border,
              boxShadow: widget.boxShadow,
              color: widget.background,
              padding: widget.padding,
              onClick: () => _navigate(context),
            );
          case Strings.productItemCardHorizontal:
            bool enablePrice = get(widget.dataTemplate, ['enablePrice'], false);
            double opacity = ConvertData.stringToDouble(get(widget.dataTemplate, ['opacity'], 0.6), 0.6);
            dynamic opacityColor = get(widget.dataTemplate, ['opacityColor'], Colors.black);
            Color colorOpacity = opacityColor is Color
                ? opacityColor
                : opacityColor is Map
                    ? ConvertData.fromRGBA(get(opacityColor, [themeModeKey], {}), Colors.black)
                    : Colors.black;

            return ProductCardHorizontalItem(
              image: buildImage(
                context,
                product: widget.product,
                width: widget.width,
                height: widget.height,
                borderRadius: widget.radiusImage,
                fit: fit,
              ),
              category: enableCategory
                  ? buildCategory(context, product: widget.product, color: widget.subTextColor ?? Colors.white)
                  : null,
              name: buildName(
                context,
                product: widget.product,
                style: theme.textTheme.subtitle2.copyWith(color: widget.textColor ?? Colors.white),
              ),
              price: enablePrice
                  ? buildPrice(
                      context,
                      product: widget.product,
                      priceStyle: stylePrice,
                      saleStyle: styleSale,
                      regularStyle: styleRegular,
                      styleFrom: styleTextFrom,
                    )
                  : null,
              tagExtra: enableLabelNew || enableLabelSale
                  ? buildTagExtra(
                      context,
                      product: widget.product,
                      enableNew: enableLabelNew,
                      newColor: widget.labelNewColor,
                      newTextColor: widget.labelNewTextColor,
                      newRadius: widget.labelNewRadius,
                      enableSale: enableLabelSale,
                      saleColor: widget.labelSaleColor,
                      saleTextColor: widget.labelSaleTextColor,
                      saleRadius: widget.labelSaleRadius,
                    )
                  : null,
              wishlist: buildWishlist(
                context,
                product: widget.product,
                color: widget.wishlistColor ?? Colors.black,
                isSelected: existWishList(productId: widget.product.id),
                onTap: () => _wishlist(context),
              ),
              addCart: _loading
                  ? _buildLoading(context)
                  : buildAddCart(
                      context,
                      product: widget.product,
                      icon: widget.iconAddCart,
                      text: translate('product_buy_product'),
                      radius: widget?.radiusAddCart ?? 8,
                      isButtonOutline: widget?.outlineAddCart ?? false,
                      onTap: () => _handleAddToCart(context),
                    ),
              width: widget.width,
              padding: widget.padding ?? EdgeInsets.all(16),
              borderRadius: BorderRadius.circular(widget.radius ?? 8),
              border: widget.border,
              boxShadow: widget.boxShadow,
              color: widget.background,
              opacity: opacity,
              colorOpacity: colorOpacity,
              onClick: () => _navigate(context),
            );
            break;
          case Strings.productItemCardVertical:
            return ProductCardVerticalItem(
              image: buildImage(
                context,
                product: widget.product,
                width: widget.width,
                height: widget.height,
                borderRadius: widget.radiusImage,
                fit: fit,
              ),
              category: enableCategory
                  ? buildCategory(context, product: widget.product, color: widget.subTextColor ?? Colors.white)
                  : null,
              name: buildName(
                context,
                product: widget.product,
                style: theme.textTheme.subtitle2.copyWith(color: widget.textColor ?? Colors.white),
              ),
              price: buildPrice(
                context,
                product: widget.product,
                priceStyle: stylePrice,
                saleStyle: styleSale,
                regularStyle: styleRegular,
                styleFrom: styleTextFrom,
              ),
              rating: enableRating ? buildRating(context, product: widget.product, color: widget.subTextColor) : null,
              wishlist: buildWishlist(
                context,
                product: widget.product,
                color: widget.wishlistColor ?? Colors.black,
                isSelected: existWishList(productId: widget.product.id),
                onTap: () => _wishlist(context),
              ),
              addCard: _loading
                  ? _buildLoading(context)
                  : SizedBox(
                      width: double.infinity,
                      child: buildAddCart(
                        context,
                        product: widget.product,
                        icon: widget.iconAddCart,
                        text: translate('product_buy_product'),
                        radius: widget?.radiusAddCart ?? 8,
                        isButtonOutline: widget?.outlineAddCart ?? false,
                        onTap: () => _handleAddToCart(context),
                      ),
                    ),
              borderRadius: BorderRadius.circular(widget.radius ?? 8),
              border: widget.border,
              color: widget.background,
              boxShadow: widget.boxShadow ?? initBoxShadow,
              padding: widget.padding ?? EdgeInsets.all(16),
              width: widget.width,
              onClick: () => _navigate(context),
            );
            break;
          default:
            return ProductContainedItem(
              image: buildImage(
                context,
                product: widget.product,
                width: widget.width,
                height: widget.height,
                borderRadius: widget.radiusImage,
                fit: fit,
              ),
              name: buildName(
                context,
                product: widget.product,
                style: theme.textTheme.bodyText2.copyWith(color: widget.textColor),
              ),
              price: buildPrice(
                context,
                product: widget.product,
                priceStyle: stylePrice,
                saleStyle: styleSale,
                regularStyle: styleRegular,
                styleFrom: styleTextFrom,
              ),
              tagExtra: enableLabelNew || enableLabelSale
                  ? buildTagExtra(
                      context,
                      product: widget.product,
                      enableNew: enableLabelNew,
                      newColor: widget.labelNewColor,
                      newTextColor: widget.labelNewTextColor,
                      newRadius: widget.labelNewRadius,
                      enableSale: enableLabelSale,
                      saleColor: widget.labelSaleColor,
                      saleTextColor: widget.labelSaleTextColor,
                      saleRadius: widget.labelSaleRadius,
                    )
                  : null,
              wishlist: buildWishlist(
                context,
                product: widget.product,
                color: widget.wishlistColor ?? Colors.black,
                isSelected: existWishList(productId: widget.product.id),
                onTap: () => _wishlist(context),
              ),
              addCard: _loading
                  ? _buildLoading(context)
                  : buildAddCart(
                      context,
                      product: widget.product,
                      icon: widget?.iconAddCart ?? FeatherIcons.plus,
                      radius: widget?.radiusAddCart ?? 8,
                      isButtonOutline: widget?.outlineAddCart ?? false,
                      onTap: () => _handleAddToCart(context),
                    ),
              rating: enableRating ? buildRating(context, product: widget.product, color: widget.subTextColor) : null,
              width: widget.width,
              borderRadius: BorderRadius.circular(widget.radius),
              border: widget.border,
              boxShadow: widget.boxShadow,
              color: widget.background ?? Colors.transparent,
              padding: widget.padding,
              onClick: () => _navigate(context),
            );
        }
      },
    );
  }

  _buildLoading(BuildContext context) {
    return Container(child: Center(child: entryLoading(context)), width: 32, height: 32);
  }
}
