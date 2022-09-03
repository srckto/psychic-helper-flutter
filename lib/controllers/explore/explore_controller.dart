import 'package:get/get.dart';

class ExploreController extends GetxController {
  late List<String> psychProblems;
  late int indexOfPsychProblem;

  @override
  void onInit() {
    super.onInit();
    psychProblems = [
      "مشاكل اسرية",
      "قلق",
      "اضطرابات",
      "توتر مستمر",
      "اخرى",
    ];
    indexOfPsychProblem = 0;
  }

  void onChangePsych(int newIndex) {
    indexOfPsychProblem = newIndex;
    update();
  }
}
