// 이미지 업로드 첫 화면
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './5.PageFive.dart';
import 'dart:typed_data';

class PageFour extends StatefulWidget {
  final File imageFile;

  const PageFour({Key? key, required this.imageFile}) : super(key: key);
  @override
  _PageFourState createState() => _PageFourState();
}

class _PageFourState extends State<PageFour> {
  void _handleMaskingButtonPressed(BuildContext context) async {
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(widget.imageFile.path),
      });

      Response response = await dio.post(
        'http://10.0.2.2:8080/api/masking',
        data: formData,
      );

      if (response.statusCode == 200) {
        // 서버 응답 데이터 확인
        print('API 응답 데이터: ${response.data}');

        // Base64로 인코딩된 이미지 데이터 디코딩
        String base64Image = response.data['response']['body'];
        Uint8List decodedBytes = base64Decode(base64Image);

        // 디코딩된 이미지를 화면에 표시
        setState(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PageFive(maskingImageBytes: decodedBytes),
            ),
          );
        });
      } else {
        print('API 호출 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
  }

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
          mainAxisAlignment: MainAxisAlignment.start, // 사진을 위로 정렬
          crossAxisAlignment: CrossAxisAlignment.center, // 가로 중앙 정렬
          children: [
            const SizedBox(height: 70.0),
            Image.file(widget.imageFile,
                width: 400.0, height: 400.0, fit: BoxFit.cover),
            const SizedBox(
              height: 40.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0), // 좌우 여백 설정
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // 버튼을 가로로 균등하게 배치
                children: [
                  // 첫 번째 버튼
                  CupertinoButton(
                    onPressed: () {
                      _handleMaskingButtonPressed(context);
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 80.0, // 버튼의 크기를 조절합니다
                          height: 80.0,
                          decoration: BoxDecoration(
                            color: CupertinoColors.white, // 배경색 설정
                            border: Border.all(
                              color: Colors.grey, // 테두리 색상 설정
                              width: 1.0, // 테두리 두께 설정
                            ),
                            borderRadius:
                                BorderRadius.circular(40.0), // 동그라미 모양으로 설정
                          ),
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.eye_slash, // Cupertino 스타일 아이콘
                              color: CupertinoColors.black, // 아이콘 색상 설정
                              size: 40.0, // 아이콘 크기 조절
                            ),
                          ),
                        ),
                        const SizedBox(height: 4.0), // 텍스트와 버튼 사이에 간격 추가
                        const Text(
                          "얼굴 가리기", // 첫 번째 버튼 위에 텍스트 추가
                          style: TextStyle(
                              fontSize: 13.0, color: Colors.black // 텍스트 크기 조절
                              ),
                        ),
                      ],
                    ),
                  ),

                  // 두 번째 버튼
                  CupertinoButton(
                    onPressed: () {
                      // 이동하려는 페이지로 이동하기 위해 Navigator를 사용
                      //Navigator.of(context).push(
                      //MaterialPageRoute(
                      //builder: (context) {
                      // 이미지 경로를 전달하면서 NextPage 위젯을 생성
                      //return PageTwelve(twelveimagePath: imagePath);
                      //},
                      //),
                      //);
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 80.0, // 버튼의 크기를 조절합니다
                          height: 80.0,
                          decoration: BoxDecoration(
                            color: CupertinoColors.white, // 배경색 설정
                            border: Border.all(
                              color: Colors.grey, // 테두리 색상 설정
                              width: 1.0, // 테두리 두께 설정
                            ),
                            borderRadius:
                                BorderRadius.circular(40.0), // 동그라미 모양으로 설정
                          ),
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.smoke, // Cupertino 스타일 아이콘
                              color: CupertinoColors.black, // 아이콘 색상 설정
                              size: 40.0, // 아이콘 크기 조절
                            ),
                          ),
                        ),
                        const SizedBox(height: 4.0), // 텍스트와 버튼 사이에 간격 추가
                        const Text(
                          "배경 흐리게", // 두 번째 버튼 위에 텍스트 추가
                          style: TextStyle(
                              fontSize: 13.0, color: Colors.black // 텍스트 크기 조절
                              ),
                        ),
                      ],
                    ),
                  ),

                  // 세 번째 버튼
                  CupertinoButton(
                    onPressed: () {
                      // 이동하려는 페이지로 이동하기 위해 Navigator를 사용
                      //Navigator.of(context).push(
                      //MaterialPageRoute(
                      //builder: (context) {
                      // 이미지 경로를 전달하면서 NextPage 위젯을 생성
                      //return PageFourteen(fourteenimagePath: imagePath);
                      //},
                      //),
                      //);
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 80.0, // 버튼의 크기를 조절합니다
                          height: 80.0,
                          decoration: BoxDecoration(
                            color: CupertinoColors.white, // 배경색 설정
                            border: Border.all(
                              color: Colors.grey, // 테두리 색상 설정
                              width: 1.0, // 테두리 두께 설정
                            ),
                            borderRadius:
                                BorderRadius.circular(40.0), // 동그라미 모양으로 설정
                          ),
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.tag, // Cupertino 스타일 아이콘
                              color: CupertinoColors.black, // 아이콘 색상 설정
                              size: 35.0, // 아이콘 크기 조절
                            ),
                          ),
                        ),
                        const SizedBox(height: 4.0), // 텍스트와 버튼 사이에 간격 추가
                        const Text(
                          "옷 입히기", // 세 번째 버튼 위에 텍스트 추가
                          style: TextStyle(
                              fontSize: 13.0, color: Colors.black // 텍스트 크기 조절
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
