import 'dart:developer';
import 'dart:io';

import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_the_world/UI/post/post/upload/get_location_response_model.dart';
import 'package:travel_the_world/UI/post/post/upload/menu_buttons.dart';
import 'package:travel_the_world/UI/post/post/upload/uploader_card.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/UI/profile/widgets/profile_form_widget.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';
import 'package:travel_the_world/services/store_service.dart';
import 'package:travel_the_world/themes/app_colors.dart';
import 'package:travel_the_world/themes/app_fonts.dart';

class UploadPostMainWidget extends StatefulWidget {
  final UserModel currentUser;
  const UploadPostMainWidget({super.key, required this.currentUser});

  @override
  State<UploadPostMainWidget> createState() => _UploadPostMainWidgetState();
}

class _UploadPostMainWidgetState extends State<UploadPostMainWidget> {
  XFile? _pickedFile;
  XFile? _croppedFile;
  final TextEditingController _descriptionController = TextEditingController();
  final ValueNotifier<bool> _isUploading = ValueNotifier<bool>(false);

  List<String> imageCategory = [];
  List<double> categoryConfidence = [];

  double _longitude = 0.0;
  double _latitude = 0.0;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _clear() {
    setState(() {
      _pickedFile = null;
      _croppedFile = null;
      _isUploading.value = false;
      _descriptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroundColor(context),
      appBar: const CustomAppBar(title: "Post Page"),
      body: Container(
        color: AppColors.black,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    if (_croppedFile != null || _pickedFile != null) {
      return ImageCard(
        croppedFile: _croppedFile,
        pickedFile: _pickedFile,
        descriptionController: _descriptionController,
        isUploading: _isUploading,
        clear: () => _clear(),
        cropImage: () => _cropImage(),
        submitPost: (XFile? file) => _submitPost(_pickedFile),
        latitude: _latitude,
        longitudine: _longitude,
      );
    } else {
      return UploaderCard(pickImage: _pickImage);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return;

    await getImageLabels(pickedFile);

    XFile? file = XFile(pickedFile.path);
    setState(() {
      _pickedFile = file;
    });
  }

  Future<void> getImageLabels(XFile image) async {
    imageCategory.clear();
    categoryConfidence.clear();

    final inputImage = InputImage.fromFilePath(image.path);
    ImageLabeler imageLabeler =
        ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.75));
    try {
      List<ImageLabel> labels = await imageLabeler.processImage(inputImage);

      for (ImageLabel imgLabel in labels) {
        imageCategory.add(imgLabel.label);
        categoryConfidence
            .add(double.parse(imgLabel.confidence.toStringAsFixed(2)));
      }
    } finally {
      imageLabeler.close();
    }
  }

  Future<void> _cropImage() async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.png,
        compressQuality: 100,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Edit',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
        ],
      );
      if (croppedFile == null) return;
      await getImageLabels(XFile(croppedFile.path));
      // check if need to call the getMedataData function here too
      XFile? file = XFile(croppedFile.path);
      setState(() {
        _croppedFile = file;
      });
    }
  }

  Future<GetLocationResponseModel> getLocation(XFile pickedFile) async {
    final fileBytes = await pickedFile.readAsBytes();
    final data = await readExifFromBytes(fileBytes, details: false);
    if (data.isEmpty) {
      return GetLocationResponseModel(
        country: "Unknown",
        city: "Unknown",
        lat: 0.0,
        lon: 0.0,
      );
    }
    final latitudeValue = data["GPS GPSLatitude"]?.values.toList();
    final latitudeSignal = data['GPS GPSLatitudeRef']?.printable;
    final longitudeValue = data['GPS GPSLongitude']?.values.toList();
    final longitudeSignal = data['GPS GPSLongitudeRef']?.printable;
    if (latitudeValue == null ||
        latitudeSignal == null ||
        longitudeValue == null ||
        longitudeSignal == null) {
      return GetLocationResponseModel(
        country: "Unknown",
        city: "Unknown",
        lat: 0.0,
        lon: 0.0,
      );
    }

    _latitude = convertRationalLatLon(latitudeValue, latitudeSignal);
    _longitude = convertRationalLatLon(longitudeValue, longitudeSignal);

    log("$_latitude : $_longitude");
    List<Placemark> placemarks =
        await placemarkFromCoordinates(_latitude, _longitude);
    return GetLocationResponseModel(
      country: placemarks[0].country.toString(),
      city: placemarks[0].locality.toString(),
      lat: _latitude,
      lon: _longitude,
    );
  }

  double convertRationalLatLon(List<dynamic> values, String ref) {
    double degrees = values[0].toDouble();
    double minutes = values[1].toDouble();
    double seconds = values[2].toDouble();

    double latLong = degrees + (minutes / 60) + (seconds / 3600);

    if (ref == 'S' || ref == 'W') {
      latLong = -latLong;
    }

    return latLong;
  }

  Future<void> _submitPost(XFile? file) async {
    setState(() {
      _isUploading.value = true;
    });
    if (file == null) return;

    ImageUploadResult imageInfo =
        await StoreService().uploadImagePost(File(file.path), "Posts");

    GetLocationResponseModel locationInfo = await getLocation(file);

    _createPost(
      imageUrl: imageInfo.imageUrl,
      imageId: imageInfo.imageId,
      height: imageInfo.height,
      width: imageInfo.width,
    );

    await File(file.path).delete();
    Future.delayed(const Duration(seconds: 2), () {});
  }

  Future<void> _createPost(
      {required String imageUrl,
      required String imageId,
      required double height,
      required double width}) {
    BlocProvider.of<PostCubit>(context)
        .createPost(
            post: PostModel(
      creatorUid: widget.currentUser.uid,
      likes: const [],
      postId: imageId,
      postImageUrl: imageUrl,
      totalComments: 0,
      username: widget.currentUser.username,
      userProfileUrl: widget.currentUser.profileUrl,
      description: _descriptionController.text,
      category: imageCategory,
      categoryConfidence: categoryConfidence,
    ))
        .then((value) {
      BlocProvider.of<PostCubit>(context).addCategoryAndDimensions(
        post: PostModel(
          postId: imageId,
          category: imageCategory,
          categoryConfidence: categoryConfidence,
          imageHeight: height,
          imageWidth: width,
        ),
      );
      _clear();
    });
    return Future<void>.value();
  }
}

class ImageCard extends StatelessWidget {
  final XFile? croppedFile;
  final XFile? pickedFile;
  final TextEditingController descriptionController;
  final ValueNotifier<bool> isUploading;
  final VoidCallback clear;
  final Future<void> Function() cropImage;
  final Future<void> Function(XFile?) submitPost;
  final double longitudine;
  final double latitude;

  const ImageCard({
    super.key,
    required this.croppedFile,
    required this.pickedFile,
    required this.descriptionController,
    required this.isUploading,
    required this.clear,
    required this.cropImage,
    required this.submitPost,
    required this.longitudine,
    required this.latitude,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ImageDisplay(
                      croppedFile: croppedFile, pickedFile: pickedFile),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProfileFormWidget(
                title: "Description",
                controller: descriptionController,
                hintText: "Write your description...",
                fillColor: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 24.0),
            MenuButtons(
              clear: clear,
              cropImage: cropImage,
              submitPost: submitPost,
              croppedFile: croppedFile,
              isUploading: isUploading,
            ),
          ],
        ),
      ),
    );
  }
}

class ImageDisplay extends StatelessWidget {
  final XFile? croppedFile;
  final XFile? pickedFile;

  const ImageDisplay(
      {super.key, required this.croppedFile, required this.pickedFile});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (croppedFile != null) {
      final path = croppedFile!.path;
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 0.9 * screenWidth,
            maxHeight: 0.9 * screenHeight,
          ),
          child: Image.file(File(path)),
        ),
      );
    } else if (pickedFile != null) {
      final path = pickedFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.9 * screenWidth,
          maxHeight: 0.9 * screenHeight,
        ),
        child: Image.file(File(path)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      title: Text(
        title,
        style: Fonts.f22w700(color: getTextColor(context)),
      ),
      backgroundColor: getBackgroundColor(context),
    );
  }
}
