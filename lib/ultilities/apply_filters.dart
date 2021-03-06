import 'package:photofilters/photofilters.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:image_capture/contances/colors.dart';
import 'package:image/image.dart' as imageLib;

ApplyFilters(context, _image) async {
  var image = imageLib.decodeImage(_image.readAsBytesSync());
  image = imageLib.copyResize(image, width: 600);
  String fileName = basename(_image.path);
  Map imagefile = await Navigator.push(
    context,
    new MaterialPageRoute(
      builder: (context) => new PhotoFilterSelector(
        title: Text("Image Filters"),
        image: image,
        appBarColor: AppColors.sky,
        filters: presetFiltersList,
        filename: fileName,
        loader: Center(child: CircularProgressIndicator()),
        fit: BoxFit.contain,
      ),
    ),
  );
  if (imagefile != null && imagefile.containsKey('image_filtered')) {
    _image = imagefile['image_filtered'];
    return _image;
  } else {
    return null;
  }
}
