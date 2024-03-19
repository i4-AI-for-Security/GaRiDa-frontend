import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class PageSix extends StatelessWidget {
  final File uploadedImageFile;

  const PageSix({Key? key, required this.uploadedImageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uploaded Image'),
      ),
      body: Center(
        child: Image.file(uploadedImageFile), // PageFour에서 전달받은 파일을 표시
      ),
    );
  }
}
