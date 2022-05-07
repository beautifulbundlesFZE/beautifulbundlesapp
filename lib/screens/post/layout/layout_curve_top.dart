import 'dart:math' as math;
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/post/post.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/screens/post/widgets/post_action.dart';
import 'package:cirilla/screens/post/widgets/post_image.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/paths/curve_convex.dart';

import '../widgets/post_name.dart';
import '../widgets/post_category.dart';
import '../widgets/post_date.dart';
import '../widgets/post_author.dart';
import '../widgets/post_comment_count.dart';
import '../widgets/post_content.dart';
import '../widgets/post_tag.dart';
import '../widgets/post_comments.dart';

class LayoutCurveTop extends StatelessWidget with AppBarMixin {
  final Post post;
  final Map<String, dynamic> styles;

  LayoutCurveTop({
    Key key,
    this.post,
    this.styles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore?.themeModeKey ?? 'value';

    Color backgroundCategory =
        ConvertData.fromRGBA(get(styles, ['backgroundCategory', themeModeKey], {}), Color(0xFF21BA45));
    Color colorCategory = ConvertData.fromRGBA(get(styles, ['colorCategory', themeModeKey], {}), Colors.white);
    double radiusCategory = ConvertData.stringToDouble(get(styles, ['radiusCategory'], 19));

    return CustomScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        buildAppbar(context),
        SliverPadding(
          padding: EdgeInsets.only(left: layoutPadding, right: layoutPadding, top: 24, bottom: 16),
          sliver: SliverToBoxAdapter(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: PostCategory(
                  post: post,
                  background: backgroundCategory,
                  color: colorCategory,
                  radius: radiusCategory,
                )),
                PostAction(post: post),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(left: layoutPadding, right: layoutPadding, bottom: 16),
          sliver: SliverToBoxAdapter(child: PostName(post: post)),
        ),
        SliverPadding(
          padding: EdgeInsets.only(left: layoutPadding, right: layoutPadding, bottom: 32),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16,
                  children: [
                    PostAuthor(post: post),
                    PostCommentCount(post: post),
                    PostDate(post: post),
                  ],
                ),
                SizedBox(height: 24),
                Divider(height: 1, thickness: 1),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(left: layoutPadding, right: layoutPadding, bottom: 24),
          sliver: PostContent(post: post),
        ),
        SliverPadding(
          padding: EdgeInsets.only(bottom: 48),
          sliver: SliverToBoxAdapter(
            child: PostTagWidget(post: post, paddingHorizontal: layoutPadding),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(left: layoutPadding, right: layoutPadding, bottom: 24),
          sliver: PostComments(post: post),
        ),
      ],
    );
  }

  Widget buildAppbar(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double paddingTop = MediaQuery.of(context).padding.top;
    double height = (width * 292) / 376;

    return SliverAppBar(
      expandedHeight: height - paddingTop,
      stretch: true,
      leadingWidth: 58,
      leading: Padding(
        padding: EdgeInsetsDirectional.only(start: layoutPadding),
        child: leadingPined(),
      ),
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const <StretchMode>[
          StretchMode.zoomBackground,
        ],
        centerTitle: true,
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            PostImage(post: post, width: width, height: height),
            Positioned(
              child: Transform.rotate(
                angle: -math.pi,
                child: ClipPath(
                  clipper: CurveInConvex(),
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
              bottom: -1,
              left: 0,
              right: 0,
            ),
          ],
        ),
      ),
    );
  }
}
