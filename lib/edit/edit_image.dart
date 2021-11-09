import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:image_capture/contances/colors.dart';
import 'package:image_capture/edit/get_image.dart';
import 'package:image_capture/ultilities/save_in_gallery.dart';
import 'package:image_capture/capture/preview_screen.dart';
import 'package:image_capture/database/db_provider.dart';
import 'package:image_capture/database/cap_img.dart';

class EditImage extends StatefulWidget {
  @override
  _EditImageState createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  bool _selected = false; //to check if a image is selected or not
  File _image; //here we will store the selected image and apply modifications

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

    double _ImageContainerWidth = boundWidth;
    double _ImageContainerHeight = boundWidth * 1.2;

    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        backgroundColor: AppColors.sky,
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () async {
              if (_image != null) {
                await SaveImg(_image);
                CapImg capImg = CapImg(path: _image.path);
                print(_image);
                DBProvider.dbase.insertCapImg(capImg);
                Navigator.pop(context);
                // if (DBProvider.dbase.getInfoCapImg(capImg.path) != null)
                //   DBProvider.dbase.insertCapImg(capImg);
                // else {
                //   Fluttertoast.showToast(
                //       msg: "Image saved in Image Gallery",
                //       toastLength: Toast.LENGTH_SHORT,
                //       gravity: ToastGravity.BOTTOM,
                //       timeInSecForIosWeb: 1,
                //       backgroundColor: Colors.green,
                //       textColor: Colors.white,
                //       fontSize: 16.0);
                // }
                // function called from SaveInGallery.dart
              } else {
                Fluttertoast.showToast(
                    msg: "Select a image first :-(",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            },
            child: Text("Save"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
        title: Text(
          'Edit Image',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: _image == null
                  ? Image.asset('images/cam.png')
                  : InkWell(
                      child: PhotoView(
                        imageProvider: FileImage(_image),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PreviewScreen(
                                    id: 0,
                                    imgPath: _image,
                                  )),
                        );
                      },
                    ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                color: AppColors.gray,
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                        onPressed: () async {
                          var _Ifile = await GetImage(
                              _image); // function called from GetImg.dart
                          if (_Ifile != null) {
                            setState(() {
                              _image = _Ifile;
                              _selected = true;
                            });

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PreviewScreen(
                                        id: 0,
                                        imgPath: _image,
                                      )),
                            );
                          }
                        },
                        child: Text("Change Image"))
                  ],
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<ByteData> getBytesFromFile() async {
    Uint8List bytes = _image.readAsBytesSync() as Uint8List;
    return ByteData.view(bytes.buffer);
  }
}
