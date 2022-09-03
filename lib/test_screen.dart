// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart';
// import 'package:get/get.dart';
// import 'package:psychic_helper/display_text.dart';
// import 'package:psychic_helper/helper/cache_storage.dart';
// import 'package:psychic_helper/helper/constants.dart';

// class TestScreen extends StatefulWidget {
//   TestScreen({Key? key}) : super(key: key);

//   @override
//   _TestScreenState createState() => _TestScreenState();
// }

// class _TestScreenState extends State<TestScreen> {
//   @override
//   Widget build(BuildContext context) {
//     QuillController _controller = QuillController.basic();

//     return Scaffold(
//       appBar: AppBar(
//           // title: Text("data")
//           ),
//       body: Column(
//         children: [
//           QuillToolbar.basic(
//             controller: _controller,
//             showBackgroundColorButton: false,
//             showAlignmentButtons: false,
//             showCameraButton: false,
//             showCenterAlignment: false,
//             showFontFamily: false,
//             showUnderLineButton: false,
//             showImageButton: false,
//             showLeftAlignment: false,
//             showLink: false,
//             showVideoButton: false,
//             showFontSize: false,
//             showCodeBlock: false,
//             showColorButton: false,
//             showStrikeThrough: false,
//             showDividers: false,
//             showSmallButton: false,
//             showInlineCode: false,
//             showFormulaButton: false,
//             locale: Locale("ar"),
//           ),
//           Expanded(
//             child: Container(
//               child: QuillEditor.basic(
//                 controller: _controller,
//                 readOnly: false, // true for view only mode
//                 locale: Locale("ar"),
//               ),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               ElevatedButton(
//                 onPressed: () async {
//                   var json = jsonEncode(_controller.document.toDelta());

//                   await CacheStorage.save(TEXT_KEY, json);

//                   log(json);
//                 },
//                 child: Icon(Icons.save),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Get.to(() => DisplayText());
//                 },
//                 child: Icon(Icons.navigate_before),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
