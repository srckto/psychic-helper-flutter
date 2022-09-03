import 'package:get/get.dart';
import 'package:psychic_helper/models/post_model.dart';
import 'package:psychic_helper/network/firestore_service.dart';

class HomeController extends GetxController {
  late bool isLoading;
  late List<PostModel> posts;

  @override
  void onInit() async {
    super.onInit();
    isLoading = true;
    posts = [];
    update();

    await getPosts();

    isLoading = false;
    update();
  }

  Future<void> getPosts() async {
    try {
      posts = [];
      var querySnapshot = await FirestoreService.instance.getPosts();
      querySnapshot.docs.forEach((element) {
        posts.add(PostModel.fromMap(element.data()));
      });
      update();
    } catch (e) {
      print("Error in getPosts function");
      throw e;
    }
  }
}
