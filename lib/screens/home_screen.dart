import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:signature_authentication/constants.dart';
import 'package:signature_authentication/screens/image_cropper.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:progress_indicators/progress_indicators.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File genuineImage;
  File toBeCheckedImage;

  bool _showProgressIndicator = false;

  String resultTitle = 'Success';

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Signature Authentication'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _showProgressIndicator
          ? _jumpingDotsProgressIndicator()
          : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              firstImage(context, screenHeight),
              SizedBox(
                height: 10.0,
              ),
              secondImage(context, screenHeight),
              authenticateButton(context, screenHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget firstImage(BuildContext context, double screenHeight) {
    return Container(
      height: screenHeight / 3,
      width: double.infinity,
      padding: EdgeInsets.all(10.0),
      child: Card(
        elevation: 5,
        shadowColor: primaryColor,
        child: Column(
          children: [
            Container(
              height: screenHeight / 15,
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Genuine Signature',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final result = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CropImage()))
                      as File;
                  setState(() {
                    genuineImage = result;
                  });
                },
                child: Container(
                  width: double.infinity,
                  color: primaryAccent,
                  child: genuineImage != null
                      ? Image.file(
                          genuineImage,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.add,
                          size: 80.0,
                          color: Colors.black54,
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget secondImage(BuildContext context, double screenHeight) {
    return Container(
      height: screenHeight / 3,
      width: double.infinity,
      padding: EdgeInsets.all(10.0),
      child: Card(
        elevation: 5,
        shadowColor: primaryColor,
        child: Column(
          children: [
            Container(
              height: screenHeight / 15,
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Signature to Authenticate',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final result = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CropImage()))
                      as File;
                  setState(() {
                    toBeCheckedImage = result;
                  });
                },
                child: Container(
                  width: double.infinity,
                  color: primaryAccent,
                  child: toBeCheckedImage != null
                      ? Image.file(toBeCheckedImage, fit: BoxFit.cover)
                      : Icon(
                          Icons.add,
                          size: 80.0,
                          color: Colors.black54,
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget authenticateButton(BuildContext context, double screenHeight) {
    return Container(
      height: screenHeight / 6,
      width: double.infinity,
      // color: secondaryColor,
      margin: EdgeInsets.symmetric(vertical: 20.0),
      padding: EdgeInsets.all(40.0),
      child: FlatButton(
        onPressed: () async {
          setState(() {
            _showProgressIndicator = true;
          });
          print('Authenticate...');
          Timer(Duration(seconds: 3), (){
            setState(() {
              _showProgressIndicator = false;
            });
            _showAlertBox();
          });
          // await _showAlertBox();
        },
        child: Text(
          'Authenticate',
          style: TextStyle(fontSize: 20, letterSpacing: 1.0),
        ),
        padding: EdgeInsets.all(10.0),
        color: primaryColor,
      ),
    );
  }

  Future _showAlertBox(){
    return animated_dialog_box.showScaleAlertBox(
      context: context,
      yourWidget: Container(
        child: Text(resultTitle == 'Success'? 'Signature is Authentic.' : 'Signature is Not Authentic.'),
      ),
      firstButton: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.5),
        ),
        color: primaryColor,
        child: Text('Ok'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      secondButton: Container(),
      icon: Icon(
        resultTitle == 'Success' ? Icons.check_circle : Icons.cancel,
        color: resultTitle == 'Success' ? primaryDarker : Colors.red,
        size: 50.0,
      ),
      title: Center(
        child: Text("$resultTitle."),
      ),
    );
  }

  Widget _jumpingDotsProgressIndicator(){
    return Container(
      height: MediaQuery.of(context).size.height/1.2,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Verifying ',
            style: TextStyle(
              fontSize: 20.0,
              letterSpacing: 0.5,
              color: primaryDarker,
            ),
          ),
          JumpingDotsProgressIndicator(
            color: primaryDarker,
            dotSpacing: 0.5,
            fontSize: 30.0,
            numberOfDots: 3,
          )
        ],
      ),
    );
  }
}
