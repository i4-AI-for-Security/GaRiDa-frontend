// 새 글 만들기 (3-1)
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:GaRiDa/database_helper.dart';
import 'package:image_picker/image_picker.dart';
import './4.PageFour.dart';

class PageThree extends StatefulWidget {
  final Map<String, dynamic>? itemData;

  const PageThree({Key? key, this.itemData}) : super(key: key);

  @override
  _PageThreeState createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();

    if (widget.itemData != null) {
      _titleController.text = widget.itemData!['title'] ?? '';
      _contentController.text = widget.itemData!['content'] ?? '';
      if (widget.itemData!['imagePath'] != null) {
        _image = File(widget.itemData!['imagePath']);
      }
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
            middle: _titleController.text.isNotEmpty
                ? Text(
                    _titleController.text,
                    style: const TextStyle(
                        fontFamily: 'NanumSquareNeo',
                        fontWeight: FontWeight.bold),
                  )
                : const Text('Title'),
            leading: CupertinoButton(
              padding: const EdgeInsets.all(0.0),
              child: const Icon(Icons.arrow_back_ios_new,
                  color: CupertinoColors.black),
              onPressed: () {
                // 이동하려는 페이지로 이동하기 위해 Navigator를 사용
                Navigator.of(context).pop();
              },
            ),
            trailing: CupertinoButton(
              padding: const EdgeInsets.all(0.0),
              child: const Icon(Icons.settings_outlined,
                  color: CupertinoColors.black),
              onPressed: () {
                // Add your onPressed logic here
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_image != null)
                  Image.file(
                    _image!,
                    height: 200.0,
                    width: 200.0,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0, right: 30.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            // Select image from gallery
                            final picker = ImagePicker();
                            XFile? pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);

                            if (pickedFile != null) {
                              setState(() {
                                _image = File(pickedFile.path);
                                print('Image Path: ${_image?.path}');
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffDCD4F7),
                          ),
                          child: const Text(
                            'Add',
                            style: TextStyle(
                                fontFamily: 'NanumSquareNeo',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_image != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PageFour(imageFile: _image!),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                                fontFamily: 'NanumSquareNeo',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _image = null;
                            });
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                                fontFamily: 'NanumSquareNeo',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: _titleController,
              maxLines: null,
              style: const TextStyle(
                  fontFamily: 'NanumSquareNeo', fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: 'Enter Title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: null,
              style: const TextStyle(
                  fontFamily: 'NanumSquareNeo', fontWeight: FontWeight.bold),
              decoration: const InputDecoration(labelText: 'Enter Content'),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_titleController.text.isNotEmpty &&
                        _contentController.text.isNotEmpty) {
                      if (widget.itemData != null) {
                        // Update existing item in the database
                        await DatabaseHelper.instance.update(
                          widget.itemData!['id'],
                          'your_table', // Replace with your actual table name
                          {
                            'title': _titleController.text,
                            'content': _contentController.text,
                            'imagePath':
                                _image?.path, // Update image path if it changed
                          },
                        );
                      } else {
                        // Insert a new item into the database
                        await DatabaseHelper.instance.insert({
                          'title': _titleController.text,
                          'content': _contentController.text,
                          'imagePath': _image?.path,
                        });
                      }

                      Navigator.pop(context);
                    } else {
                      // Show an error message if title or content is empty
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content:
                              const Text('Title and content cannot be empty.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                        fontFamily: 'NanumSquareNeo',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
