import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature_authentication/constants.dart';

class UploadProfilePicture extends StatefulWidget {
  @override
  _UploadProfilePictureState createState() => _UploadProfilePictureState();
}

class _UploadProfilePictureState extends State<UploadProfilePicture> {
  bool showBottom = false;
  File imageFile;
  final picker = ImagePicker();
  ValueNotifier value;
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Choose Profile Picture'),
      ),
      backgroundColor: secondaryColor,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    showBottom = false;
                  });
                  print('hello');
                },
                child: Container(
                  height: MediaQuery.of(context).size.height - 300,
                  width: double.infinity,
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          showBottom = true;
                        });
                        print('hello');
                      },
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: primaryColor),
                        child: imageFile == null
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo),
                            SizedBox(height: 15.0),
                            Text('Add Photo')
                          ],
                        )
                            : showImage(),
                        // : Image.file(
                        //     imageFile,
                        //     fit: BoxFit.cover,
                        //   ),
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedCrossFade(
                firstChild: firstChild(),
                secondChild: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.orange[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        child: FlatButton(
                          onPressed: () {
                            pickImageFromGallery(ImageSource.camera);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt),
                              SizedBox(height: 15.0),
                              Text('Camera'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        child: FlatButton(
                          onPressed: () {
                            pickImageFromGallery(ImageSource.gallery);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.photo),
                              SizedBox(height: 15.0),
                              Text('Gallery'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                crossFadeState: showBottom
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future pickImageFromGallery(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      imageFile = File(pickedFile.path);
      isLoading = false;
      showBottom = false;
    });
    print('imageFile');
  }

  Future pickImageFromCamera(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      imageFile = File(pickedFile.path);
      isLoading = false;
      showBottom = false;
    });
    print('imageFile');
  }

  Widget showImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.0),
      child: isLoading
          ? CircularProgressIndicator(
        strokeWidth: 5,
        valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
      )
          : Image(image: AssetImage(imageFile.path), fit: BoxFit.cover),
    );
  }

  Widget firstChild() {
    return imageFile == null
        ? Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
    )
        : Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: secondaryColor,
        ),
        child: Stack(
          children: [
            Container(
              height: 60,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: FlatButton(
                onPressed: setProfilePicture,
                child: Text('Set Profile Picture'),
                color: primaryColor,
              ),
            ),
          ],
        ));
  }

  setProfilePicture(){
    // Navigator.pop(context,imageFile.path);
  }
}
