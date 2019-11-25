import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //comes along with the multiple image picker plugin
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:multi_image_picker/multi_image_picker.dart';
//import 'package:image_picker_modern/image_picker_modern.dart';
import 'button_submit.dart';
import 'dart:io';


void main() => runApp(CitizenReport());
class CitizenReport extends StatefulWidget {
  @override
  _CitizenReportState createState() => _CitizenReportState();
}

class AppImagePicker extends StatelessWidget {

  final double maxImageWidth;
  final double maxImageHeight;
  final Function(File) onImageSelected;

  const AppImagePicker(
      {Key key,
        this.maxImageWidth,
        this.maxImageHeight,
        @required this.onImageSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton( //main source code from: http://stacksecrets.com/flutter/build-an-image-picker-wrapper-widget-in-flutter
      icon: Icon(Icons.camera_alt),
      onPressed: (){
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                  title: Text("Camera/Gallery"),
                  children: <Widget>[
                    SimpleDialogOption(
                      child: const Text('Pick From Gallery'),
                      onPressed: () async{ //sample from: http://stacksecrets.com/flutter/build-an-image-picker-wrapper-widget-in-flutter
                        Navigator.pop(context);
                        _getImage(ImageSource.gallery);
                      },
                      //onPressed: () => Navigator.pop(context, ImageSource.camera), //source URL from https://dev.to/pedromassango/let-s-pick-some-images-with-flutter-575b
                      //child: const Text('Take A New Picture'),
                      //onPressed: _getImage(ImageSource.camera),
                    ),
                    SimpleDialogOption(
                        child: const Text('Capture image from Camera'),
                        onPressed: () async { //sample from: http://stacksecrets.com/flutter/build-an-image-picker-wrapper-widget-in-flutter
                          Navigator.pop(context);
                          _getImage(ImageSource.camera);
                        }
                      //onPressed: () => Navigator.pop(context, ImageSource.gallery), ////source URL from https://dev.to/pedromassango/let-s-pick-some-images-with-flutter-575b
                      //child: const Text('Pick From Gallery'),
                      //onPressed: _getImage(ImageSource.gallery),
                    )
                  ]);
            });
      },
    );
  }

  _getImage(ImageSource src) async {
    var img = await ImagePicker.pickImage(
        source: src, maxHeight: maxImageHeight, maxWidth: maxImageWidth);
    if(onImageSelected != null) {
      onImageSelected(img);
    }
  }

}

class _CitizenReportState extends State<CitizenReport> {

  var _reports = [
    'Medical Emergencies',
    'Vehicular Accidents',
    'Natural Disasters',
    'Others'
  ];
  var _currentItemSelected = 'Medical Emergencies';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: GradientAppBar(
            title: Text('CITIZEN REPORTING', textAlign: TextAlign.center),
            gradient: LinearGradient(
                colors: [Colors.blue, Colors.purpleAccent]
            ),
          ),
          body: Center( //basis: https://api.flutter.dev/flutter/material/IconButton-class.html
              child: Column(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6.0),
                            boxShadow: [BoxShadow(color: Colors.blueAccent)]),
                        //padding: EdgeInsets.all(MediaQuery.of(context).size.width/10),
                        child: AppImagePicker()
                    ),
                    new Container( //source code here for Container solution on TextFormField width issue: https://stackoverflow.com/questions/50400529/how-to-update-flutter-textfields-height-and-width
                        width: 250.0,
                        child: TextFormField(
                            textAlign: TextAlign.center,
                            textCapitalization: TextCapitalization.characters, //source  https://medium.com/flutter-community/a-deep-dive-into-flutter-textfields-f0e676aaab7a
                            decoration: new InputDecoration(
                              icon: Icon(Icons.report),
                              labelText: 'Insert Report Title Here',
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20
                              ),
                            ),
                            validator: (val){ //used for checking if the input has a value or contains something
                              if (val.length==0){
                                return "Report field cannot be empty.";
                              }
                              else{
                                return null;
                              }
                            }
                        )
                    ),
                    DropdownButton<String>(
                      items: _reports.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      onChanged: (String newValueSelected) {
                        _onDropDownItemSelected(newValueSelected);
                      },
                      value: _currentItemSelected,
                    ),
                    new Container( //source code here for Container solution on TextFormField width issue: https://stackoverflow.com/questions/50400529/how-to-update-flutter-textfields-height-and-width
                        width: 250.0,
                        child: TextFormField(
                            textAlign: TextAlign.center,
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: 7,
                            decoration: new InputDecoration(
                              labelText: 'Insert Report Details here',
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10
                              ),
                            ),
                            validator: (val){ //used for checking if the input has a value or contains something
                              if (val.length==0){
                                return "Report field cannot be empty.";
                              }
                              else{
                                return null;
                              }
                            }
                        )
                    ),
                    CustomButton (
                      title: 'SUBMIT REPORT',
                      onPressed: (){

                      }
                    ),
                  ]
              )
          )
      ),
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

}