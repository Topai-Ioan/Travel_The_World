import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:travel_the_world/services/cache_manager.dart';

Widget profileWidget({
  String? imageUrl,
  File? image,
  BoxFit boxFit = BoxFit.contain,
}) {
  if (image != null) {
    return Image.file(image, fit: boxFit);
  } else if (imageUrl != null && imageUrl.isNotEmpty) {
    return CachedNetworkImage(
      cacheManager: CustomCacheManager(),
      imageUrl: imageUrl,
      fit: boxFit,
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return Center(
          child: CircularProgressIndicator(
            value: downloadProgress.progress ?? 0.0,
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Image.asset(
          'assets/images/profile_default.png',
          fit: boxFit,
        );
      },
    );
  } else {
    return Image.asset(
      'assets/images/profile_default.png',
      fit: boxFit,
    );
  }
}
