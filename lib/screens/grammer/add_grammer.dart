import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:haru_admin/api/grammer_data_services.dart';

class AddGrammerScreen extends StatefulWidget {
  const AddGrammerScreen({super.key});

  @override
  State<AddGrammerScreen> createState() => _AddGrammerScreenState();
}

class _AddGrammerScreenState extends State<AddGrammerScreen> {
  final GrammerDataRepository grammerRepository = GrammerDataRepository();

  String? _imageDataUrl;

  final List<dynamic> _datas = [];

  void getImageUrl(int index) async {
    if (_datas[index].title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('이미지 업로드 전, 단어를 입력해주세요.')),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
      return;
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['png', 'jpg', 'svg', 'jpeg']);

      if (result != null) {
        PlatformFile file = result.files.first;

        await grammerRepository
            .uploadFile(
          fileBytes: file.bytes!,
          fileName: _datas[index].title,
        )
            .then((value) {
          setState(() {
            _datas[index].imgUrl = value;
          });
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      throw Exception(e);
    }
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
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _imageDataUrl == null
              ? const Text('No image selected.')
              : Image.network(_imageDataUrl!, height: 150, width: 150),
          const SizedBox(height: 20),
          _imageDataUrl == null
              ? ElevatedButton(
                  onPressed: () {
                    getImageUrl(0);
                  },
                  child: const Text('Choose Image'),
                )
              : ElevatedButton(
                  onPressed: () {
                    getImageUrl(0);
                  },
                  child: const Text('Upload Image'),
                ),
        ],
      ),
    );
  }
}
