import 'package:flutter/material.dart';

import '../../core/base_widget/images/set_up_asset_image.dart';
import '../../core/helper/app_text.dart';
import '../../core/helper/size_util.dart';

class ItemSetting extends StatelessWidget {
  final String icon;
  final String describe;
  final VoidCallback onTap;
  final bool enabled;
  const ItemSetting({super.key, required this.icon, required this.describe, required this.onTap, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(8),
          splashColor: Colors.grey.withValues(alpha: 0.2),
          highlightColor: Colors.grey.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: SizedBox(
              height: 45,
              width: SizeUtil.getMaxWidth(),
              child: Center(
                child: Row(
                  children: [
                    SetUpAssetImage(icon, height: 28, width: 28),
                    const SizedBox(width: 15),
                    Text(describe, style: AppText.text14_Inter),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
