// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart';
// import 'package:psychic_helper/helper/cache_storage.dart';
// import 'package:psychic_helper/helper/constants.dart';

// class DisplayText extends StatefulWidget {
//   DisplayText({Key? key}) : super(key: key);

//   @override
//   _DisplayTextState createState() => _DisplayTextState();
// }

// class _DisplayTextState extends State<DisplayText> {
//   late final String text;
//   late QuillController _controller;
//   @override
//   void initState() {
//     super.initState();
//     text = CacheStorage.get(TEXT_KEY) ?? "Not Found a text";

//     _controller = QuillController(
//       document: Document.fromJson(jsonDecode(text)),
//       selection: const TextSelection.collapsed(offset: 0),
//     );

//     print(text);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: [
          
//           QuillEditor.basic(
//             controller: _controller,
//             readOnly: true, // true for view only mode
//           ),
//         ],
//       ),
//     );
//   }
// }
