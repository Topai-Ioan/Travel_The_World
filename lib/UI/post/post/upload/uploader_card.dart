import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_the_world/UI/shared_items/button_container_widget.dart';
import 'package:travel_the_world/themes/app_colors.dart';
import 'package:travel_the_world/themes/app_fonts.dart';

class UploaderCard extends StatelessWidget {
  final Future<void> Function(ImageSource) pickImage;

  const UploaderCard({super.key, required this.pickImage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            color: AppColors.olive,
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
                        color: AppColors.black,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                color: getThemeColor(context,
                                    AppColors.darkOlive, AppColors.darkOlive),
                                size: 80.0,
                              ),
                              const SizedBox(height: 24.0),
                              Text(
                                'Select an image to start',
                                style: Fonts.f16w400(color: AppColors.black),
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
                              backgroundColor: AppColors.darkOlive,
                              textStyle: Fonts.f16w400(
                                color: AppColors.black,
                              ),
                              onTapListener: () {
                                pickImage(ImageSource.gallery);
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ButtonContainerWidget(
                              textStyle: Fonts.f16w400(
                                color: AppColors.black,
                              ),
                              backgroundColor: AppColors.darkOlive,
                              onTapListener: () {
                                pickImage(ImageSource.camera);
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
}
