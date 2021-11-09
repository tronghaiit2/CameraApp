import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_capture/contances/colors.dart';
import 'package:image_picker/image_picker.dart';

class AddPhoto extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddPhoto();
  }
}

class _AddPhoto extends State<AddPhoto> {
  File imageFile = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double boundWidth = 0;
    if (screenWidth < 400)
      boundWidth = screenWidth * 0.9;
    else if (screenWidth < 600)
      boundWidth = screenWidth * 0.95;
    else
      boundWidth = screenWidth * 0.7;
    double paddingWidth = (screenWidth - boundWidth) / 2;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.sky,
          title: Text(
            "AddPhoto",
            textAlign: TextAlign.center,
          ),
        ),
        body: SafeArea(
          top: true,
          bottom: true,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      bottom: 10 + paddingWidth / 5,
                      left: paddingWidth,
                      right: paddingWidth),
                  width: boundWidth,
                  height: boundWidth * 1.2,
                  child: imageFile == null
                      ? Image.asset('images/cam.png')
                      : Image.file(imageFile),
                ),
                SizedBox(
                  height: 10.0,
                ),
                RaisedButton(
                    onPressed: () {
                      _settingModalBottomSheet(context);
                    },
                    child: Text("Take Photo")),
              ],
            ),
          ),
        ));
  }

  //********************** IMAGE PICKER
  Future imageSelector(BuildContext context, String pickerType) async {
    switch (pickerType) {
      case "gallery": // GALLERY IMAGE PICKER
        var pickedFile =
            await ImagePicker().getImage(source: ImageSource.gallery);
        if (pickedFile != null) imageFile = File(pickedFile.path);
        break;

      case "camera": // CAMERA CAPTURE CODE
        var pickedFile =
            await ImagePicker().getImage(source: ImageSource.camera);
        if (pickedFile != null) imageFile = File(pickedFile.path);
        break;
    }

    if (imageFile != null) {
      print("You selected  image : " + imageFile.path);
      setState(() {
        debugPrint("SELECTED IMAGE PICK   $imageFile");
      });
    } else {
      print("You have not taken image");
    }
  }

  // Image picker
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    title: new Text('Gallery'),
                    onTap: () => {
                          imageSelector(context, "gallery"),
                          Navigator.pop(context),
                        }),
                new ListTile(
                  title: new Text('Camera'),
                  onTap: () => {
                    imageSelector(context, "camera"),
                    Navigator.pop(context)
                  },
                ),
              ],
            ),
          );
        });
  }
}
