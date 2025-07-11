import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../enums/enums.dart';
import '../../utils/color_resources.dart';
import '../../utils/images_path.dart';
import '../../utils/app_constants.dart';

/// [SetUpAssetImage] - use with 2 type of image.
///
/// 1. Image with png, jpeg, jpg.
///
/// 2. Image with svg.

class SetUpAssetImage extends StatelessWidget {
  const SetUpAssetImage(this.urlImage, {super.key, this.width, this.height, this.fit, this.color});

  /// [urlImage] Set the url.
  final String urlImage;

  /// [width] set width of image with url or file.
  final double? width;

  /// [height] set height of image with url or file.
  final double? height;

  /// [fit] set fit of image with url or file.
  final BoxFit? fit;

  /// [color] set color of image.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (_isNetworkImage(urlImage)) {
      return Image.network(
        urlImage,
        fit: fit ?? BoxFit.contain,
        height: height,
        width: width,
        color: color,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            height: height ?? 100,
            width: width ?? 100,
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(ColorResources.PRIMARY_TEXT),
                strokeWidth: 2,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Image.asset(
          ImagesPath.placeHolder,
          fit: fit ?? BoxFit.contain,
          height: height ?? 100,
          width: width ?? 100,
        ),
      );
    }

    final type = _getImageType(urlImage);

    if (type == AssetImageType.SVG) {
      return SvgPicture.asset(
        urlImage,
        fit: fit ?? BoxFit.contain,
        height: height,
        width: width,
        color: color,
        placeholderBuilder:
            (BuildContext context) => SizedBox(
          height: height ?? 100,
          width: width ?? 100,
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(ColorResources.PRIMARY_TEXT),
              strokeWidth: 2,
            ),
          ),
        ),
        errorBuilder:
            (context, error, stackTrace) => Image.asset(
          ImagesPath.placeHolder,
          fit: fit ?? BoxFit.contain,
          height: height ?? 100,
          width: width ?? 100,
        ),
      );
    }

    return Image.asset(
      urlImage,
      fit: fit ?? BoxFit.contain,
      height: height,
      width: width,
      color: color,
      errorBuilder:
          (context, error, stackTrace) => Image.asset(
        ImagesPath.placeHolder,
        fit: fit ?? BoxFit.contain,
        height: height ?? 100,
        width: width ?? 100,
      ),
    );
  }

  AssetImageType _getImageType(String url) {
    if (url.endsWith(checkImageWithExtSvg)) {
      return AssetImageType.SVG;
    }

    return AssetImageType.IMAGE;
  }

  bool _isNetworkImage(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }
}
