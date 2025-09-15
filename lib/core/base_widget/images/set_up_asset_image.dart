import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_network/image_network.dart';
import '../../utils/color_resources.dart';

class SetUpAssetImage extends StatelessWidget {
  final String urlImage;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final FilterQuality? filterQuality;
  final bool? gaplessPlayback;
  final ImageErrorWidgetBuilder? errorBuilder;
  final bool enableMemoryCache;
  final int? memCacheWidth;
  final int? memCacheHeight;

  const SetUpAssetImage(
      this.urlImage, {
        super.key,
        this.width,
        this.height,
        this.fit,
        this.color,
        this.filterQuality,
        this.gaplessPlayback,
        this.errorBuilder,
        this.enableMemoryCache = true,
        this.memCacheWidth,
        this.memCacheHeight,
      });

  @override
  Widget build(BuildContext context) {
    if (_isNetworkImage(urlImage)) {
      // Web => ImageNetwork
      if (kIsWeb) {
        return ImageNetwork(
          image: urlImage,
          height: height ?? 120,
          width: width ?? 120,
          duration: 800,
          curve: Curves.easeInOut,
          onPointer: true,
          debugPrint: false,
          backgroundColor: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          fitWeb: _mapToBoxFitWeb(fit ?? BoxFit.contain),
          onLoading: _buildLoadingPlaceholder(),
          onError: _buildErrorPlaceholder(),
          onTap: () {
            debugPrint("Image tapped: $urlImage");
          },
        );
      }

      // Mobile => CachedNetworkImage
      return CachedNetworkImage(
        imageUrl: urlImage,
        fit: fit ?? BoxFit.contain,
        height: height,
        width: width,
        color: color,
        memCacheWidth: _getSafeIntValue(width, memCacheWidth),
        memCacheHeight: _getSafeIntValue(height, memCacheHeight),
        placeholder: (context, url) => _buildLoadingPlaceholder(),
        errorWidget: (context, url, error) => _buildErrorPlaceholder(),
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 200),
        maxWidthDiskCache: 1920,
        maxHeightDiskCache: 1920,
      );
    }

    // SVG asset
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

    // Local file (mobile only)
    if (!kIsWeb && _isLocalFile(urlImage)) {
      final file = File(urlImage);
      return Image.file(
        file,
        height: height,
        width: width,
        fit: fit ?? BoxFit.contain,
        filterQuality: filterQuality ?? FilterQuality.medium,
        gaplessPlayback: gaplessPlayback ?? true,
        errorBuilder:
        errorBuilder ?? (context, error, stackTrace) => _buildErrorPlaceholder(),
        cacheWidth: _getSafeIntValue(width, memCacheWidth),
        cacheHeight: _getSafeIntValue(height, memCacheHeight),
      );
    }

    // Default asset
    return Image.asset(
      urlImage,
      height: height,
      width: width,
      fit: fit ?? BoxFit.contain,
      color: color,
      filterQuality: filterQuality ?? FilterQuality.medium,
      cacheWidth: _getSafeIntValue(width, memCacheWidth),
      cacheHeight: _getSafeIntValue(height, memCacheHeight),
      errorBuilder:
      errorBuilder ?? (context, error, stackTrace) => _buildErrorPlaceholder(),
    );
  }

  int? _getSafeIntValue(double? value, int? fallback) {
    if (fallback != null) return fallback;
    if (value == null) return null;
    if (value.isInfinite || value.isNaN) return null;
    if (value < 0) return null;
    return value.toInt();
  }

  bool _isSvg(String url) => url.toLowerCase().endsWith('.svg');
  bool _isNetworkImage(String url) =>
      url.startsWith('http://') || url.startsWith('https://');
  bool _isLocalFile(String url) =>
      url.startsWith('/') || url.startsWith('file://');

  /// Map BoxFit to BoxFitWeb
  BoxFitWeb _mapToBoxFitWeb(BoxFit fit) {
    switch (fit) {
      case BoxFit.cover:
        return BoxFitWeb.cover;
      case BoxFit.fill:
        return BoxFitWeb.fill;
      case BoxFit.contain:
        return BoxFitWeb.contain;
      default:
        return BoxFitWeb.contain;
    }
  }

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
    return Container(
      height: height ?? 100,
      width: width ?? 100,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            color: Colors.grey[400],
            size: (height ?? 100) * 0.3,
          ),
          const SizedBox(height: 4),
          Text(
            'Lỗi tải ảnh',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
