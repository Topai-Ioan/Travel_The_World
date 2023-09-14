import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget profileWidget({
  String? imageUrl,
  File? image,
  BoxFit boxFit = BoxFit.contain, // Provide a default value
}) {
  if (image == null) {
    if (imageUrl == null || imageUrl == "") {
      return Image.asset(
        'assets/images/profile_default.png',
        fit: boxFit, // Use the provided BoxFit directly
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: boxFit, // Use the provided BoxFit directly
        progressIndicatorBuilder: (context, url, downloadProgress) {
          return const CircularProgressIndicator();
        },
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/profile_default.png',
          fit: boxFit, // Use the provided BoxFit directly
        ),
      );
    }
  } else {
    return Image.file(image, fit: boxFit); // Use the provided BoxFit directly
  }
}
