import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';

import '../../../core/utils/color_resources.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeUtil.getMaxHeight(),
      width: SizeUtil.getMaxWidth(),
      color: ColorResources.DARK,
      child: const Center(
        child: CircularProgressIndicator(
          color: ColorResources.GREEN,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
