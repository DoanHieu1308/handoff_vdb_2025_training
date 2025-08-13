import 'package:flutter/material.dart';

import '../../core/base_widget/images/set_up_asset_image.dart';

class ShowImageWithUrl extends StatelessWidget {
  final String imageUrl;
  const ShowImageWithUrl({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: SetUpAssetImage(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.error, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
