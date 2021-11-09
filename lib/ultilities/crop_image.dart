import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_capture/contances/colors.dart';

EditImg(_image) async {
  var CroppedImg = await ImageCropper.cropImage(
      sourcePath: _image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          activeControlsWidgetColor: AppColors.sky,
          dimmedLayerColor: AppColors.gray,
          cropFrameColor: Colors.white,
          toolbarColor: AppColors.sky,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ));
  if (CroppedImg != null) {
    _image = CroppedImg;
    print("$_image");
    return _image;
  } else
    return null;
}
