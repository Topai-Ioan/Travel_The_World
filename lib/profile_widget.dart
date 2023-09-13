import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget profileWidget({String? imageUrl, File? image}) {
  if (image == null) {
    if (imageUrl == null || imageUrl == "") {
      return Image.asset(
        'assets/images/profile_default.png',
        fit: BoxFit.contain,
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.contain,
        progressIndicatorBuilder: (context, url, downloadProgress) {
          return const CircularProgressIndicator();
        },
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/profile_default.png',
          fit: BoxFit.contain,
        ),
      );
    }
  } else {
    return Image.file(image, fit: BoxFit.cover);
  }
}
