import 'dart:io';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:haru_admin/api/grammer_data_services.dart';
import 'package:haru_admin/model/grammer_data_model.dart';
import 'package:haru_admin/utils/add_chapter_model.dart';

class AddGrammerScreen extends StatefulWidget {
  const AddGrammerScreen({super.key});

  @override
  State<AddGrammerScreen> createState() => _AddGrammerScreenState();
}

class _AddGrammerScreenState extends State<AddGrammerScreen> {
  final GrammerDataRepository grammerRepository = GrammerDataRepository();

  String? _imageDataUrl;

  Future<void> _getImage() async {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.accept = 'image/*';
    input.click();

    input.onChange.listen((e) {
      final html.File file = input.files!.first;
      final reader = html.FileReader();

      reader.onLoadEnd.listen((e) {
        setState(() {
          _imageDataUrl = reader.result as String?;
        });
      });

      reader.readAsDataUrl(file);
    });
  }

  @override
  void initState() {
    super.initState();
    // grammerRepository
    //     .addToGrammerDataList(

    // )
    //     .then((value) {
    //   setState(() {
    //     print(value);
    //   });
    // });

    grammerRepository.getGrammerDataList().then((value) {
      setState(() {
        print(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _imageDataUrl == null
              ? Text('No image selected.')
              : Image.network(_imageDataUrl!, height: 150, width: 150),
          SizedBox(height: 20),
          _imageDataUrl == null
              ? ElevatedButton(
                  onPressed: _getImage,
                  child: Text('Choose Image'),
                )
              : ElevatedButton(
                  onPressed: () async {
                    grammerRepository
                        .addToGrammerFile(_imageDataUrl!)
                        .then((value) {
                      setState(() {
                        print(value);
                      });
                    });
                  },
                  child: Text('Upload Image'),
                ),
        ],
      ),
    );
  }
}
