import 'package:cirilla/mixins/post_wishlist_mixin.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class PostAction extends StatefulWidget {
  final Post post;
  final Color color;
  final Axis axis;

  PostAction({Key key, this.post, this.color, this.axis = Axis.horizontal}) : super(key: key);

  @override
  _PostActionState createState() => _PostActionState();
}

class _PostActionState extends State<PostAction> with PostWishListMixin {
  ///
  /// Handle wishlist
  void _wishlist(BuildContext context) {
    if (widget.post == null || widget.post.id == null) return;
    addWishList(postId: widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    bool select = existWishList(postId: widget.post.id);
    if (widget.axis == Axis.vertical) {
      return Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              InkWell(
                onTap: () => {},
                child: Icon(FeatherIcons.messageCircle, size: 18, color: widget.color),
              ),
              SizedBox(height: 32),
              InkWell(
                onTap: () => _wishlist(context),
                child: Icon(!select ? Icons.bookmark_border : Icons.bookmark, size: 20, color: widget.color),
              ),
              SizedBox(height: 32),
              InkWell(
                onTap: () => Share.share(widget.post.link, subject: widget.post.postTitle),
                child: Icon(FeatherIcons.share2, size: 18, color: widget.color),
              ),
            ],
          ));
    }
    return Container(
      alignment: Alignment.centerLeft,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 32,
        children: [
          InkWell(
            onTap: () => {},
            child: Icon(FeatherIcons.messageCircle, size: 18, color: widget.color),
          ),
          InkWell(
            onTap: () => _wishlist(context),
            child: Icon(!select ? Icons.bookmark_border : Icons.bookmark, size: 20, color: widget.color),
          ),
          InkWell(
            onTap: () => Share.share(widget.post.link, subject: widget.post.postTitle),
            child: Icon(FeatherIcons.share2, size: 18, color: widget.color),
          ),
        ],
      ),
    );
  }
}
