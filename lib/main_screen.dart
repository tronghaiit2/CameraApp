import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_capture/contances/colors.dart';
import 'package:image_capture/edit/edit_image.dart';
import 'package:image_capture/capture/camera_screen.dart';
import 'package:image_capture/capture/add_photo.dart';
import 'package:image_capture/gallery/img_gallery.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

// SingleTickerProviderStateMixin is used for animation
class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // Create a tab controller
  TabController controller;

  @override
  void initState() {
    super.initState();

    // Initialize the Tab Controller
    controller = TabController(length: 3, vsync: this);
    //Start with camera tab
    controller.animateTo(1);
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the TabBar view as the body of the Scaffold
      body: TabBarView(
        // Add tabs as widgets
        children: <Widget>[EditImage(), CameraScreen(), ImgGallery()],
        // set the controller
        controller: controller,
      ),
      // Set the bottom navigation bar
      bottomNavigationBar: Material(
        // set the color of the bottom navigation bar
        color: AppColors.sky,
        // set the tab bar as the child of bottom navigation bar
        child: TabBar(
          tabs: <Tab>[
            Tab(
              // set icon to the tab
              icon: Icon(Icons.create_rounded),
            ),
            Tab(
              icon: Icon(Icons.add_a_photo_rounded),
            ),
            Tab(
              icon: Icon(Icons.image_rounded),
            ),
          ],
          // setup the controller
          controller: controller,
        ),
      ),
    );
  }
}
