import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

import 'package:psychic_helper/models/post_model.dart';

class PostDetailsController extends GetxController {
  final PostModel postModel;

  PostDetailsController({
    required this.postModel,
  });

  QuillController? quillController;

  String? body;

  @override
  void dispose() {
    quillController?.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    _handleBodyString();
    super.onInit();
  }

  void _handleBodyString() {
    if (postModel.jsonDescription == null && postModel.stringDescription == null) {
      body = "لا يوجد وصف";
      return;
    }
    if (postModel.jsonDescription == null && postModel.stringDescription != null) {
      body = postModel.stringDescription;
      return;
    }
    if (postModel.jsonDescription != null) {
      try {
        var myJSON = jsonDecode(postModel.jsonDescription ?? "");
        quillController = QuillController(
          document: Document.fromJson(myJSON),
          selection: TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        debugPrint(e.toString());
        body = "لا يوجد وصف";
      }
    }
  }
}
