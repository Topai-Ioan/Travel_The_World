import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/UI/profile/widgets/profile_form_widget.dart';
import 'package:travel_the_world/UI/shared_items/button_container_widget.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';
import 'package:travel_the_world/services/store_service.dart';

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

  List<String> imageTags = [];
  List<double> tagsConfidence = [];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
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
    imageTags.clear();
    tagsConfidence.clear();

    final inputImage = InputImage.fromFilePath(image.path);
    ImageLabeler imageLabeler =
        ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.5));
    try {
      List<ImageLabel> labels = await imageLabeler.processImage(inputImage);

      for (ImageLabel imgLabel in labels) {
        imageTags.add(imgLabel.label);
        tagsConfidence
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

      XFile? file = XFile(croppedFile.path);
      setState(() {
        _croppedFile = file;
      });
    }
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
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text("Post Page"),
        backgroundColor: appBarColor,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _body()),
        ],
      ),
    );
  }

  Widget _body() {
    if (_croppedFile != null || _pickedFile != null) {
      return _imageCard();
    } else {
      return _uploaderCard();
    }
  }

  Widget _imageCard() {
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
                  child: _image(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProfileFormWidget(
                title: "Description",
                controller: _descriptionController,
                hintText: "Write your description...",
                fillColor: Colors.grey[850],
              ),
            ),
            const SizedBox(height: 24.0),
            _menu(),
          ],
        ),
      ),
    );
  }

  Widget _image() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (_croppedFile != null) {
      final path = _croppedFile!.path;
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 0.8 * screenWidth,
            maxHeight: 0.7 * screenHeight,
          ),
          child: Image.file(File(path)),
        ),
      );
    } else if (_pickedFile != null) {
      final path = _pickedFile!.path;
      return Container(
        color: Colors.red,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 0.8 * screenWidth,
            maxHeight: 0.7 * screenHeight,
          ),
          child: Image.file(File(path)),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _menu() {
    var deleteButton = FloatingActionButton(
      onPressed: () {
        _clear();
      },
      backgroundColor: Colors.red,
      tooltip: 'Delete',
      child: const Icon(Icons.delete),
    );
    var cropButton = FloatingActionButton(
      onPressed: () {
        _cropImage();
      },
      backgroundColor: const Color(0xFFBC764A),
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
            if (_croppedFile == null) ...[
              cropButton,
              _uploadButon(_pickedFile),
            ] else
              _uploadButon(_croppedFile),
          ],
        ),
      ),
      if (_isUploading.value)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: LinearProgressIndicator(
            color: Colors.green[700],
            borderRadius: BorderRadius.circular(8.0),
            backgroundColor: Colors.green[900],
          ),
        ),
    ]);
  }

  Widget _uploaderCard() {
    return Center(
      child: SingleChildScrollView(
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            color: Colors.black,
            child: SizedBox(
              width: 320.0,
              height: 300.0,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DottedBorder(
                        radius: const Radius.circular(12.0),
                        borderType: BorderType.RRect,
                        dashPattern: const [8, 4],
                        color:
                            Theme.of(context).highlightColor.withOpacity(0.4),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                color: Theme.of(context).highlightColor,
                                size: 80.0,
                              ),
                              const SizedBox(height: 24.0),
                              Text(
                                'Select an image to start',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color:
                                            Theme.of(context).highlightColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ButtonContainerWidget(
                              text: "Select Image",
                              onTapListener: () {
                                _pickImage(ImageSource.gallery);
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ButtonContainerWidget(
                              onTapListener: () {
                                _pickImage(ImageSource.camera);
                              },
                              text: 'Take Photo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _uploadButon(XFile? file) {
    if (_isUploading.value) {
      return IgnorePointer(
          ignoring: true,
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.green[900],
            tooltip: 'Upload',
            child: const Icon(Icons.upload),
          ));
    }

    return FloatingActionButton(
      onPressed: () {
        _submitPost(file);
      },
      backgroundColor: Colors.green,
      tooltip: 'Upload',
      child: const Icon(Icons.upload),
    );
  }

  _submitPost(XFile? file) async {
    setState(() {
      _isUploading.value = true;
    });
    if (file == null) return;

    Map<String, String> imageInfo =
        await StoreService().uploadImagePost(File(file.path), "Posts");

    String imageUrl = imageInfo["imageUrl"]!;
    String imageId = imageInfo["imageId"]!;

    _createPost(imageUrl: imageUrl, imageId: imageId);
    Future.delayed(const Duration(seconds: 2), () {});
  }

  _createPost({required String imageUrl, required String imageId}) {
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
      tags: imageTags,
      tagsConfidence: tagsConfidence,
    ))
        .then((value) {
      BlocProvider.of<PostCubit>(context).addTags(
          post: PostModel(
              postId: imageId,
              tags: imageTags,
              tagsConfidence: tagsConfidence));
      _clear();
    });
    return;
  }
}
