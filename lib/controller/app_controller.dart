import 'package:get/get.dart';

class AppController extends GetxController {
  //read
  RxBool morning = true.obs;
  RxBool evening = false.obs;
  //time
  RxBool weekdays = false.obs;
  RxBool weekends = false.obs;
  //timetable
  RxBool yes = false.obs;
  RxBool no = false.obs;

  changeToMorning() {
    morning.value = true;
    evening.value = false;
  }

  changeToEvening() {
    evening.value = true;
    morning.value = false;
  }

  changeToWeekdays() {
    weekdays.value = true;
    weekends.value = false;
  }

  changeToWeekends() {
    weekends.value = true;
    weekdays.value = false;
  }

  changeToYes() {
    yes.value = true;
    no.value = false;
  }
  changeToNo() {
    no.value = true;
    yes.value = false;
    
  }
}
