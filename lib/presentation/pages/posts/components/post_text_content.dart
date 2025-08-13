import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/helper/app_text.dart';

class PostTextContent extends StatelessWidget {
  final String text;
  final void Function(String hashtag)? onTapHashtag;

  const PostTextContent({
    super.key,
    required this.text,
    this.onTapHashtag,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: RichText(
        text: TextSpan(
          style: AppText.text16.copyWith(color: Colors.black),
          children: _buildTextSpans(text),
        ),
      ),
    );
  }

  List<TextSpan> _buildTextSpans(String input) {
    final List<TextSpan> spans = [];
    final matches = <MatchData>[];

    // Tìm hashtag và link theo thứ tự xuất hiện
    for (final m in StringExtension.hashtagRegExp.allMatches(input)) {
      matches.add(MatchData(start: m.start, end: m.end, text: m.group(0)!, type: MatchType.hashtag));
    }
    for (final m in StringExtension.linkRegex.allMatches(input)) {
      matches.add(MatchData(start: m.start, end: m.end, text: m.group(0)!, type: MatchType.link));
    }

    // Sắp xếp theo thứ tự xuất hiện trong đoạn text
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
              try {
                final url = match.text.trim();
                print("Attempting to launch URL: $url");
                
                // Thử parse URL trực tiếp
                Uri? uri = Uri.tryParse(url);
                
                // Nếu không có scheme, thêm https://
                if (uri == null || uri.scheme.isEmpty) {
                  final urlWithScheme = url.startsWith('http') ? url : 'https://$url';
                  uri = Uri.tryParse(urlWithScheme);
                }
                
                if (uri != null) {
                  print("Parsed URI: $uri");

                  final canLaunch = await canLaunchUrl(uri);
                  print("Can launch URL: $canLaunch");
                  
                  if (canLaunch) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                    print("Successfully launched URL");
                  } else {
                    try {
                      await launchUrl(uri, mode: LaunchMode.platformDefault);
                      print("Launched with platform default mode");
                    } catch (e) {
                      print("Failed to launch URL with platform default: $e");
                      try {
                        await launchUrl(uri, mode: LaunchMode.inAppWebView);
                        print("Launched with inAppWebView mode");
                      } catch (e2) {
                        print("Failed to launch URL with inAppWebView: $e2");
                        print("Cannot launch: $url");
                      }
                    }
                  }
                } else {
                  print("Failed to parse URL: $url");
                }
              } catch (e) {
                print("Error launching URL: $e");
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
              onTapHashtag?.call(tag);
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