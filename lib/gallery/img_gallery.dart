import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_capture/contances/colors.dart';
import 'package:image_capture/capture/preview_screen.dart';
import 'package:image_capture/database/cap_img.dart';
import 'package:image_capture/database/db_provider.dart';

class ImgGallery extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ImgGallery();
  }
}

class _ImgGallery extends State<ImgGallery> {
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
      boundWidth = screenWidth * 0.98;
    double paddingWidth = (screenWidth - boundWidth) / 2;
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                        title: Text("Clear Gallery?"),
                        content: Text("Are you sure to delete all image?"),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () {
                              setState(() {
                                DBProvider.dbase.deleteAll();
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
              child: Text("Clear"),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
          backgroundColor: AppColors.sky,
          title: Text(
            "Image Gallery",
            textAlign: TextAlign.center,
          ),
        ),
        body: Container(
            margin: EdgeInsets.only(
                top: 10 + paddingWidth / 10,
                bottom: 10 + paddingWidth / 10,
                left: paddingWidth,
                right: paddingWidth),
            child: FutureBuilder<List<CapImg>>(
                future: DBProvider.dbase.getAllCapImgs(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<CapImg>> snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      itemCount: snapshot.data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              (orientation == Orientation.portrait) ? 3 : 6),
                      itemBuilder: (BuildContext context, int index) {
                        CapImg item = snapshot.data[index];
                        return Container(
                            margin: EdgeInsets.only(
                                top: 5 + paddingWidth / 10,
                                bottom: 5 + paddingWidth / 10,
                                left: 5,
                                right: 5),
                            child: InkWell(
                              child: Image.file(
                                File(item.path),
                                fit: BoxFit.fitWidth,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PreviewScreen(
                                            id: item.id,
                                            imgPath: File(item.path),
                                          )),
                                );
                              },
                            ));
                      },
                    );
                  }
                  return Container(
                    margin: EdgeInsets.only(
                        top: 1 + paddingWidth / 10,
                        bottom: 1 + paddingWidth / 10,
                        left: paddingWidth,
                        right: paddingWidth),
                  );
                })));
  }
}
