// 얼굴 인식 확인 화면
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';

class PageFive extends StatelessWidget {
  final Uint8List maskingImageBytes;

  const PageFive({Key? key, required this.maskingImageBytes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: SizedBox(
          height: 100,
          child: CupertinoNavigationBar(
            border: const Border(bottom: BorderSide.none),
            middle: const Text('Image Editor'),
            leading: CupertinoButton(
                padding: const EdgeInsets.all(0.0),
                child: const Icon(Icons.arrow_back_ios_new,
                    color: CupertinoColors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 70.0),
            GestureDetector(
              onTap: () {
                // 이미지를 터치했을 때 알림창을 띄우기
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text('얼굴이 맞나요?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {},
                          child: const Text('예', selectionColor: Colors.blue),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('아니오', selectionColor: Colors.blue),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Image.memory(
                maskingImageBytes,
                width: 400.0,
                height: 400.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 85.0),
          ],
        ),
      ),
    );
  }
}
