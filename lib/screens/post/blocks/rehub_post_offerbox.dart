import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/post/post.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:flutter/material.dart';

class PostOfferbox extends StatelessWidget with Utility {
  final Map<String, dynamic> block;

  const PostOfferbox({Key key, this.block}) : super(key: key);

  void goDetail(BuildContext context, dynamic postId) {
    Navigator.of(context).pushNamed(PostScreen.routeName, arguments: {
      'id': ConvertData.stringToInt(postId),
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context).translate;

    Map attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};
    dynamic postId = get(attrs, ['selectedPost'], null);
    String name = get(attrs, ['name'], '');
    String image = get(attrs, ['thumbnail', 'url'], '');
    String buttonText = get(attrs, ['button', 'text'], translate('post_detail_offerbox_button'));
    if (postId == null) {
      return Container();
    }
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        double widthImage = (width - 16) / 2;
        double heightImage = (widthImage * 202) / 360;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CirillaCacheImage(image, width: widthImage, height: heightImage),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: theme.textTheme.subtitle1),
                  ElevatedButton(onPressed: () => goDetail(context, postId), child: Text(buttonText)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
