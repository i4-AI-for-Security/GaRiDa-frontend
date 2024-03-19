import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Page/1.PageOne.dart';

void main() async {
  runApp(const GaRiDa());
}

class GaRiDa extends StatelessWidget {
  const GaRiDa({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: PageOne(),
    );
  }
}
