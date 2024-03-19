import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_the_world/UI/post/post/upload/face_painter.dart';
import 'package:travel_the_world/UI/post/post/upload/get_location_response_model.dart';
import 'package:travel_the_world/UI/post/post/upload/menu_buttons.dart';
import 'package:travel_the_world/UI/post/post/upload/uploader_card.dart';
import 'package:travel_the_world/constants.dart';
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
      appBar: const CustomAppBar(),
      body: Container(
        color: getBackgroundColor(context),
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

    _latitude = convertRationalLatLon(latitudeValue, latitudeSignal);
    _longitude = convertRationalLatLon(longitudeValue, longitudeSignal);
    if (_latitude.isNaN || _longitude.isNaN) {
      return GetLocationResponseModel(
        country: "",
        city: "",
        lat: 0.0,
        lon: 0.0,
      );
    }

    List<Placemark> placemarks =
        await placemarkFromCoordinates(_latitude, _longitude);
    String country = '';
    String city = '';

    for (var placemark in placemarks) {
      if (placemark.country != null && placemark.country!.isNotEmpty) {
        country = placemark.country!;
      }
      if (placemark.locality != null && placemark.locality!.isNotEmpty) {
        city = placemark.locality!;
      }
      if (country.isNotEmpty && city.isNotEmpty) {
        break;
      }
    }

    return GetLocationResponseModel(
      country: country,
      city: city,
      lat: _latitude,
      lon: _longitude,
    );
  }

  double convertRationalLatLon(List<dynamic>? values, String? ref) {
    if (values == null || ref == null) {
      return -1;
    }

    double degrees = values[0].toDouble();
    double minutes = values[1].toDouble();
    double seconds = values[2].toDouble();

    double latLong = degrees + (minutes / 60) + (seconds / 3600);
    latLong = double.parse(latLong.toStringAsFixed(6));

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
      locationInfo: locationInfo,
    );
    await File(file.path).delete();
  }

  Future<void> _createPost(
      {required String imageUrl,
      required String imageId,
      required GetLocationResponseModel locationInfo}) {
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
            country: locationInfo.country,
            city: locationInfo.city,
            latitude: locationInfo.lat,
            longitude: locationInfo.lon,
          ),
        )
        .then((value) => _clear());
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
  Future<List<Face>> getFaces(XFile inputImage) async {
    final image = InputImage.fromFilePath(inputImage.path);
    final options = FaceDetectorOptions(
        enableContours: true, performanceMode: FaceDetectorMode.accurate);
    final faceDetector = FaceDetector(options: options);
    final List<Face> faces = await faceDetector.processImage(image);

    faceDetector.close();
    return faces;
  }

  Widget buildImageWithFaces() {
    return FutureBuilder<List<Face>>(
      future: getFaces(pickedFile!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final faces = snapshot.data!;
          final imageFile = File(pickedFile!.path);
          return FutureBuilder<ui.Image>(
            future: _loadImage(imageFile),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final img = snapshot.data!;
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final widgetSize =
                        Size(constraints.maxWidth, constraints.maxHeight);
                    final imageSize =
                        Size(img.width.toDouble(), img.height.toDouble());
                    var scale = min(widgetSize.width / imageSize.width,
                        widgetSize.height / imageSize.height);
                    final fittedSize =
                        Size(imageSize.width * scale, imageSize.height * scale);
                    final scaleX = fittedSize.width / img.width;
                    final scaleY = fittedSize.height / img.height;
                    return Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: img.width / img.height,
                          child: Image.file(
                            imageFile,
                            fit: BoxFit.contain,
                          ),
                        ),
                        ...faces.map((face) => FaceWidget(
                              rect: face.boundingBox,
                              scaleX: scaleX,
                              scaleY: scaleY,
                            ))
                      ],
                    );
                  },
                );
              }
            },
          );
        }
      },
    );
  }

  Future<ui.Image> _loadImage(File file) async {
    final data = await file.readAsBytes();
    return await decodeImageFromList(data);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (croppedFile != null) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 0.9 * screenWidth,
            maxHeight: 0.9 * screenHeight,
          ),
          child: buildImageWithFaces(),
        ),
      );
    } else if (pickedFile != null) {
      return SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 0.9 * screenWidth,
              maxHeight: 0.9 * screenHeight,
            ),
            child: buildImageWithFaces(),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/logo.png",
            height: 30,
          ),
          Text(
            "Travel the world",
            style: Fonts.f20w700(color: getTextColor(context)),
          ),
          sizeVertical(15),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
