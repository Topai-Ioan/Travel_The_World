import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget profileWidget({
  String? imageUrl,
  File? image,
  BoxFit boxFit = BoxFit.contain,
}) {
  if (image == null) {
    if (imageUrl == null || imageUrl == "") {
      return Image.asset(
        'assets/images/profile_default.png',
        fit: boxFit,
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: boxFit,
        progressIndicatorBuilder: (context, url, downloadProgress) {
          double progress = downloadProgress.progress ?? 0.0;
          return Center(
            child: CircularProgressIndicator(
              value: progress,
            ),
          );
        },
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/profile_default.png',
          fit: boxFit,
        ),
      );
    }
  } else {
    return Image.file(image, fit: boxFit);
  }
}
