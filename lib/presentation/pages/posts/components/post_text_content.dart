import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/helper/app_text.dart';

class PostTextContent extends StatefulWidget {
  final String text;
  final void Function(String hashtag)? onTapHashtag;

  const PostTextContent({
    super.key,
    required this.text,
    this.onTapHashtag,
  });

  @override
  State<PostTextContent> createState() => _PostTextContentState();
}

class _PostTextContentState extends State<PostTextContent> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textSpan = TextSpan(
            style: AppText.text16.copyWith(color: Colors.black),
            children: _buildTextSpans(widget.text),
          );

          // Đo chiều cao để kiểm tra có quá 10 dòng không
          final tp = TextPainter(
            text: textSpan,
            maxLines: _expanded ? null : 10,
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: constraints.maxWidth);

          final exceedsMaxLines = tp.didExceedMaxLines;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: AppText.text16.copyWith(color: Colors.black),
                  children: _buildTextSpans(widget.text),
                ),
                maxLines: _expanded ? null : 10,
                overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
              if (!_expanded && exceedsMaxLines)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _expanded = true;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "xem thêm",
                      style: AppText.text14.copyWith(color: Colors.blue),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  List<TextSpan> _buildTextSpans(String input) {
    final List<TextSpan> spans = [];
    final matches = <MatchData>[];

    for (final m in StringExtension.hashtagRegExp.allMatches(input)) {
      matches.add(MatchData(
          start: m.start,
          end: m.end,
          text: m.group(0)!,
          type: MatchType.hashtag));
    }
    for (final m in StringExtension.linkRegex.allMatches(input)) {
      matches.add(MatchData(
          start: m.start,
          end: m.end,
          text: m.group(0)!,
          type: MatchType.link));
    }

    matches.sort((a, b) => a.start.compareTo(b.start));

    int currentIndex = 0;
    for (final match in matches) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(
          text: input.substring(currentIndex, match.start),
          style: AppText.text16.copyWith(color: Colors.black),
        ));
      }

      if (match.type == MatchType.link) {
        spans.add(TextSpan(
          text: match.text,
          style: AppText.text16.copyWith(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              final url = match.text.trim();
              Uri? uri = Uri.tryParse(
                  url.startsWith('http') ? url : 'https://$url');
              if (uri != null) {
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri,
                      mode: LaunchMode.externalApplication);
                }
              }
            },
        ));
      } else if (match.type == MatchType.hashtag) {
        final tag = match.text.replaceFirst('#', '');
        spans.add(TextSpan(
          text: match.text,
          style: AppText.text16.copyWith(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              widget.onTapHashtag?.call(tag);
            },
        ));
      }
      currentIndex = match.end;
    }

    if (currentIndex < input.length) {
      spans.add(TextSpan(
        text: input.substring(currentIndex),
        style: AppText.text16.copyWith(color: Colors.black),
      ));
    }

    return spans;
  }
}

class MatchData {
  final int start;
  final int end;
  final String text;
  final MatchType type;

  MatchData({
    required this.start,
    required this.end,
    required this.text,
    required this.type,
  });
}
