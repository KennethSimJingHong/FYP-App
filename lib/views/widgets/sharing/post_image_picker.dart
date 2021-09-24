import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';
import 'package:image_picker/image_picker.dart';

class PostImagePicker extends StatefulWidget {
  final Function(File pickedImage) imagePickFn;
  final String imageText;
  PostImagePicker(this.imagePickFn, this.imageText);
  @override
  _PostImagePickerState createState() => _PostImagePickerState();
}

class _PostImagePickerState extends State<PostImagePicker> {
  File _pickedImage;

  Future _pickImage() async{
    _pickedImage = null;
    final picker = ImagePicker();
    final pickImage = await picker.getImage(source: ImageSource.gallery, maxWidth: 150,);
      if(pickImage != null){
        final pickedImageFile = File(pickImage.path);
        setState(() {
          _pickedImage = pickedImageFile;
        });
        widget.imagePickFn(pickedImageFile);
      }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width:250,
          height:150,
          decoration: BoxDecoration(border:Border.all(color:Colors.black38)),
          child: _pickedImage != null ? FittedBox(fit: BoxFit.fill ,child: Image.file(_pickedImage)) : Center(child: Text(widget.imageText),),
        ),

        TextButton.icon(
          icon: Icon(Icons.image),
          label: Text("Add Image"),
          style: TextButton.styleFrom(
            primary: kGreenColor,
          ),
          onPressed: _pickImage,
        ),
      ],
    );
  }
}