import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature_authentication/constants.dart';

class CropImage extends StatefulWidget {
  @override
  _CropImageState createState() => _CropImageState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _CropImageState extends State<CropImage> {
  AppState state;
  File imageFile;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Image'),
      ),
      body: Center(
        child: imageFile != null
            ? Image.file(imageFile)
            : Container(
                child: Text(
                  'Select an Image...',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 25.0,
                      letterSpacing: 0.5),
                ),
              ),
      ),
      floatingActionButton: bottomButtonTray(),
    );
  }

  Widget _buildButtonIcon() {
    if (state == AppState.free)
      return Icon(Icons.image);
    else if (state == AppState.picked)
      return Icon(Icons.crop);
    else if (state == AppState.cropped)
      return Icon(Icons.clear);
    else
      return Container();
  }

  Future<Null> _pickImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  Future<Null> _pickImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    imageFile = File(pickedFile.path);
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [CropAspectRatioPreset.ratio4x3]
          : [CropAspectRatioPreset.ratio4x3],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Image Cropper',
        toolbarColor: primaryColor,
        toolbarWidgetColor: Colors.black,
        initAspectRatio: CropAspectRatioPreset.ratio4x3,
        lockAspectRatio: false,
      ),
    );

    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }

  void _sendImageBack(){
    Navigator.pop(context, imageFile);
  }

  Widget bottomButtonTray(){
    return Stack(
      children: [
        Positioned(
          bottom: 10,
          right: 10,
          child: FloatingActionButton(
            heroTag: 'Gallery',
            onPressed: () {
              if (state == AppState.free)
                _pickImageFromGallery();
              else if (state == AppState.picked)
                _cropImage();
              else if (state == AppState.cropped) _clearImage();
            },
            child: _buildButtonIcon(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        imageFile != null
            ? Container()
            : Positioned(
          bottom: 10,
          right: 80.0,
          child: FloatingActionButton(
            heroTag: 'Camera',
            onPressed: () {
              _pickImageFromCamera();
            },
            child: Icon(Icons.camera_alt),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        imageFile == null || state == AppState.cropped
            ? Container()
            : Positioned(
          bottom: 10,
          right: 80.0,
          child: FloatingActionButton(
            heroTag: 'Clear',
            onPressed: () {
              _clearImage();
            },
            child: Icon(Icons.clear),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        imageFile == null
            ? Container()
            : Positioned(
          bottom: 10,
          right: 200.0,
          child: FlatButton(
            onPressed: () {
              print('Image selected.');
              _sendImageBack();
            },
            child: Text(
              'Select Image',
              style: TextStyle(letterSpacing: 1.0),
            ),
            padding: EdgeInsets.all(18.0),
            color: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ],
    );
  }
}
