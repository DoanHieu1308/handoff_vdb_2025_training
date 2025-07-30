import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../enums/enums.dart';
import '../../utils/color_resources.dart';
import '../../utils/images_path.dart';

class SetUpAssetImage extends StatelessWidget {
  final String urlImage;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;

  const SetUpAssetImage(
      this.urlImage, {
        super.key,
        this.width,
        this.height,
        this.fit,
        this.color,
      });

  @override
  Widget build(BuildContext context) {
    if (_isNetworkImage(urlImage)) {
      return CachedNetworkImage(
        imageUrl: urlImage,
        fit: fit ?? BoxFit.contain,
        height: height,
        width: width,
        color: color,
        placeholder: (context, url) => _buildLoadingPlaceholder(),
        errorWidget: (context, url, error) => _buildErrorPlaceholder(),
      );
    }

    if (_isSvg(urlImage)) {
      return SvgPicture.asset(
        urlImage,
        height: height,
        width: width,
        fit: fit ?? BoxFit.contain,
        color: color,
        placeholderBuilder: (context) => _buildLoadingPlaceholder(),
      );
    }

    if (_isLocalFile(urlImage)) {
      final file = File(urlImage);
      return Image.file(
        file,
        height: height,
        width: width,
        fit: fit ?? BoxFit.contain,
        filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
      );
    }

    // Default fallback to asset
    return Image.asset(
      urlImage,
      height: height,
      width: width,
      fit: fit ?? BoxFit.contain,
      color: color,
      errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
    );
  }

  bool _isSvg(String url) => url.toLowerCase().endsWith('.svg');

  bool _isNetworkImage(String url) =>
      url.startsWith('http://') || url.startsWith('https://');

  bool _isLocalFile(String url) =>
      url.startsWith('/') || url.startsWith('file://');

  Widget _buildLoadingPlaceholder() {
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
  }

  Widget _buildErrorPlaceholder() {
    return Image.asset(
      ImagesPath.placeHolder,
      height: height ?? 100,
      width: width ?? 100,
      fit: fit ?? BoxFit.contain,
    );
  }
}
