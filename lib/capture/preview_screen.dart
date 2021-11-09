import 'dart:io';
import 'dart:typed_data';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:image_capture/contances/colors.dart';
import 'package:image_capture/ultilities/apply_filters.dart';
import 'package:image_capture/ultilities/crop_image.dart';
import 'package:image_capture/ultilities/save_in_gallery.dart';
import 'package:image_capture/database/db_provider.dart';
import 'package:image_capture/database/cap_img.dart';

class PreviewScreen extends StatefulWidget {
  final int id;
  final File imgPath;

  PreviewScreen({this.id, this.imgPath});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  File imagePath;

  @override
  void initState() {
    super.initState();
    imagePath = widget.imgPath;
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
      boundWidth = screenWidth * 0.98;
    double paddingWidth = (screenWidth - boundWidth) / 2;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Preview Photo"),
        //centerTitle: true,
        backgroundColor: AppColors.sky,
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () async {
              if (imagePath != null) {
                await SaveImg(imagePath);
                CapImg capImg = CapImg(path: imagePath.path);
                print(imagePath);
                DBProvider.dbase.insertCapImg(capImg);
                Navigator.pop(context);
                // if (DBProvider.dbase.getInfoCapImg(capImg.path) == null)
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
              }
            },
            child: Text("Save"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: PhotoView(
                  imageProvider: FileImage(imagePath),
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                color: AppColors.sky,
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.crop_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        var _Ifile = await EditImg(
                            imagePath); // function called from EditImg.dart
                        if (_Ifile != null) {
                          setState(() {
                            imagePath = _Ifile;
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.filter_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        var _Ifile = await ApplyFilters(context,
                            imagePath); // function called from ApplyFilters.dart
                        if (_Ifile != null) {
                          setState(() {
                            imagePath = _Ifile;
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.share_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        getBytesFromFile().then((bytes) {
                          Share.file('Share via', basename(imagePath.path),
                              bytes.buffer.asUint8List(), 'image/path');
                        });
                      },
                    ),
                    if (widget.id != 0)
                      IconButton(
                        icon: Icon(
                          Icons.delete_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                                  title: Text("Delete image?"),
                                  content: Text(
                                      "Are you sure to delete this image?"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Yes'),
                                      onPressed: () {
                                        setState(() {
                                          DBProvider.dbase
                                              .deleteCapImg(widget.id);
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        });
                                      },
                                    ),
                                    TextButton(
                                      child: Text('No'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                )),
                      ),
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
    Uint8List bytes = imagePath.readAsBytesSync() as Uint8List;
    return ByteData.view(bytes.buffer);
  }
}
