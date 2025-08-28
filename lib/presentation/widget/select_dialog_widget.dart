import 'package:flutter/material.dart';

import '../../core/helper/app_tap_animation.dart';
import '../../core/helper/app_text.dart';

class SelectDialogWidget extends StatelessWidget {
  final String titleText;
  final String option1Text;
  final String option2Text;
  final VoidCallback onOption1Tap;
  final VoidCallback onOption2Tap;
  final bool showIcon;

  const SelectDialogWidget({
    super.key,
    required this.titleText,
    required this.option1Text,
    required this.option2Text,
    required this.onOption1Tap,
    required this.onOption2Tap,
    required this.showIcon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        titleText,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTapAnimation(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 45),
              leading: showIcon ? const Icon(Icons.image, color: Colors.blue) : null,
              title: Text(option1Text),
              onTap: () {
                Navigator.pop(context);
                onOption1Tap();
              },
            ),
          ),
          const Divider(height: 1),
          Text("Or", style: AppText.text12.copyWith(color: Colors.grey.shade500)),
          const Divider(height: 1),
          AppTapAnimation(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 45),
              leading: showIcon ? const Icon(Icons.videocam, color: Colors.red) : null,
              title: Text(option2Text),
              onTap: () {
                Navigator.pop(context);
                onOption2Tap();
              },
            ),
          ),
        ],
      ),
    );
  }
}
