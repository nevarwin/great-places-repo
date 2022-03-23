import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  late File _storedImage;

  // Capture a photo
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePicture() async {
    final imageFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    setState(() {
      // updating the _storedImage
      _storedImage = File(imageFile!.path);
    });

    // this access the app directory
    final appDir = await syspaths.getApplicationDocumentsDirectory();

    // this gets the image file name
    final fileName = path.basename(imageFile!.path);

    // copy the file into appDir and keep the file name
    // we need to enter the path in which we want to copy to,
    // and that is appDir.path/fileName
    final fileFormatImage = File(imageFile.path);
    final savedImage = await fileFormatImage.copy('${appDir.path}/$fileName');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 150,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          alignment: Alignment.center,
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.contain,
                  width: double.infinity,
                )
              : const Text(
                  'No image taken',
                  textAlign: TextAlign.center,
                ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
            textColor: Theme.of(context).primaryColor,
            onPressed: _takePicture,
            label: const Text('Take Picture'),
            icon: const Icon(
              Icons.camera,
            ),
          ),
        ),
      ],
    );
  }
}
