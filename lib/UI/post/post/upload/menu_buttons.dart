import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_the_world/themes/app_colors.dart';

class MenuButtons extends StatelessWidget {
  final VoidCallback clear;
  final Future<void> Function() cropImage;
  final Future<void> Function(XFile?) submitPost;
  final XFile? croppedFile;
  final ValueNotifier<bool> isUploading;

  const MenuButtons({
    super.key,
    required this.clear,
    required this.cropImage,
    required this.submitPost,
    required this.croppedFile,
    required this.isUploading,
  });

  @override
  Widget build(BuildContext context) {
    var deleteButton = FloatingActionButton(
      onPressed: clear,
      backgroundColor: Colors.red,
      tooltip: 'Delete',
      child: const Icon(Icons.delete),
    );
    var cropButton = FloatingActionButton(
      onPressed: cropImage,
      backgroundColor: Colors.orange,
      tooltip: 'Crop',
      child: const Icon(Icons.crop),
    );
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            deleteButton,
            cropButton,
            UploadButton(
              isUploading: isUploading,
              submitPost: submitPost,
              croppedFile: croppedFile,
            ),
          ],
        ),
      ),
      if (isUploading.value)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: LinearProgressIndicator(
            color: Colors.green[700],
            borderRadius: BorderRadius.circular(8.0),
            backgroundColor: Colors.green,
          ),
        ),
    ]);
  }
}

class UploadButton extends StatelessWidget {
  final Future<void> Function(XFile?) submitPost;
  final XFile? croppedFile;
  final ValueNotifier<bool> isUploading;

  const UploadButton({
    super.key,
    required this.submitPost,
    required this.croppedFile,
    required this.isUploading,
  });

  @override
  Widget build(BuildContext context) {
    if (isUploading.value) {
      return IgnorePointer(
          ignoring: true,
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: AppColors.darkOlive,
            tooltip: 'Upload',
            child: const Icon(Icons.upload),
          ));
    }

    return FloatingActionButton(
      onPressed: () {
        submitPost(croppedFile);
      },
      backgroundColor: AppColors.darkOlive,
      tooltip: 'Upload',
      child: const Icon(Icons.upload),
    );
  }
}
