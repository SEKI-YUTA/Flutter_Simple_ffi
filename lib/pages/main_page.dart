import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ffi';

import 'package:my_ffi_app/theme.dart';

class MainPage extends StatefulWidget {
  const MainPage({ Key? key }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _result = 0;
  int sum(int num1, int num2) {
    var libraryPath = "";
    if(Platform.isIOS) {
      libraryPath = "sum.framework/sum";
    } else if(Platform.isMacOS) {
      libraryPath = "sum.framework/sum";
    } else if(Platform.isAndroid) {
      libraryPath = "libsum.so";
    } else if(Platform.isWindows) {
      libraryPath = "sum.dll";
    }

    if(libraryPath.isEmpty) {
      assert(false, "Dynamic library is not compatible with this platform.");
      return 0;
    }

    final dylib = DynamicLibrary.open(libraryPath);

    final pointer = dylib.lookup<NativeFunction<Int32 Function(Int32, Int32)>>("sum");

    final sum = pointer.asFunction<int Function(int, int)>();

    return sum(num1, num2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Sum 1 + 2", style: MyTheme.largeText,),
            Text("result: ${_result}", style: MyTheme.normalText,),
            ElevatedButton(onPressed: () {
              int result = sum(1, 2);
              setState(() {
                _result = result;
              });
            }, child: const Text("Sum")),
            ElevatedButton(onPressed: () {
              setState(() {
                _result = 0;
              });
            }, child: const Text("Reset"))
          ],
        ),
      ),
    );
  }
}