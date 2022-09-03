import 'package:get/get.dart';
import 'package:psychic_helper/helper/main_user.dart';
import 'package:psychic_helper/models/post_model.dart';
import 'package:psychic_helper/network/firestore_service.dart';

class ManagePostsController extends GetxController {
  late bool isLoading;
  late List<PostModel> posts;
  @override
  void onInit() async {
    super.onInit();
    isLoading = true;
    posts = [];
    update();

    await getPostsOfUser();

    isLoading = false;
    update();
  }

  Future<void> getPostsOfUser() async {
    try {
      posts = [];
      var querySnapshot = await FirestoreService.instance.getPosts();
      querySnapshot.docs.forEach((element) {
        String? postedBy = element.data()["postedBy"];
        if (postedBy != null && postedBy == MainUser.model!.uId) {
          posts.add(PostModel.fromMap(element.data()));
        }
      });
      
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}

