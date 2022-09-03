import 'package:get/get.dart';
import 'package:psychic_helper/helper/main_user.dart';
import 'package:psychic_helper/models/user_model.dart';
import 'package:psychic_helper/network/firestore_service.dart';

class ResultExploreController extends GetxController {
  late List<UserModel> users;
  late bool isLoading;

  @override
  void onInit() async {
    super.onInit();
    users = [];
    isLoading = true;
    update();

    await getUsers();

    isLoading = false;
    update();
  }

  Future<void> getUsers() async {
    try {
      var querySnapshot = await FirestoreService.instance.getUsers();
      querySnapshot.docs.forEach((element) {
        if (element.data()["isPerson"] == false && element.data()["uId"] != MainUser.model!.uId) {
          users.add(UserModel.fromMap(element.data()));
        }
      });
    } catch (e) {
      throw e;
    }
  }
}
