import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import '../../helper/size_util.dart';
import '../../helper/validate.dart';
import '../../utils/color_resources.dart';
import '../../utils/images_path.dart';

class LoadingApp extends StatelessWidget {
  const LoadingApp({
    Key? key,
    this.titleLoading,
    this.titleStyle,
    this.useLoadingLogo = true,
    this.titleColor,
    this.size,
    this.sizeLogo,
    this.colorCircularProgressIndicator,
    this.useLoadingProgressIndicator = true,
  }) : super(key: key);

  final String? titleLoading;
  final TextStyle? titleStyle;
  final bool? useLoadingLogo;
  final bool? useLoadingProgressIndicator;
  final Color? titleColor;
  final double? size;
  final double? sizeLogo;
  final Color? colorCircularProgressIndicator;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (useLoadingLogo!)
          SizedBox(
            width: size ?? SizeUtil.setSize(percent: .14),
            height: size ?? SizeUtil.setSize(percent: .14),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipOval(
                  child: SetUpAssetImage(
                    ImagesPath.icScan,
                    width: sizeLogo ?? SizeUtil.setSize(percent: .1),
                  ),
                ),
                if (useLoadingProgressIndicator!)
                  SizedBox(
                    width: size ?? SizeUtil.setSize(percent: .14),
                    height: size ?? SizeUtil.setSize(percent: .14),
                    child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(colorCircularProgressIndicator ?? ColorResources.PRIMARY_1),
                      strokeWidth: 3,
                    ),
                  ),
              ],
            ),
          ),
        if (!Validate.nullOrEmpty(titleLoading))
          Padding(
            padding: SizeUtil.setEdgeInsetsOnly(top: 10),
            child: Text(
              titleLoading!,
              style: titleStyle ??
                  Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: titleColor ?? ColorResources.BLACK,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
