import 'dart:convert';

import 'package:clean_swiper/clean_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roster_app/common/api_interface.dart';
import 'package:roster_app/common/common_methods.dart';
import 'package:roster_app/models/scheduler_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NextWeekPage extends StatelessWidget{
  int clockStatus;

  int getNumberOfDayOfWeek(){
    DateTime date = DateTime.now();
    print("weekday is ${date.weekday}");
    return date.weekday-1;
  }

  List<String> listOf7Days(){
    List<String> dayList = [];
    DateTime today = DateTime.now();
    for(int i=0;i<7;i++) {
      var _firstDayOfTheweek = today.subtract(
          new Duration(days: today.weekday - 8-i));
      var formatter = new DateFormat('yyyy-MM-dd');
      String formattedDate2 = formatter.format(_firstDayOfTheweek);
      dayList.add(formattedDate2);
    }
    return dayList;
  }

  Future<List<String>> getLoginToken()async{
    List<String> prefDataList = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.getString('user_token');
    String userEntity = prefs.getString('user_entity');
    String userLocation = prefs.getString('user_location');
    prefDataList.add(userToken);
    prefDataList.add(userEntity);
    prefDataList.add(userLocation);
    return prefDataList;
  }

  Future<dynamic>getCurrentWeekSchedular(String startDate, String endDate,String loginToken,String entityId, locationId)async{
    var mBody = {
      "remember_token": loginToken,
      "start_date": startDate,
      "last_date": endDate,
      "entityID":entityId,
      "locationID":locationId
    };
    final response = await http.post(ApiInterface.SCHEDULER, body: mBody);
    print(response.body);
    if (response.statusCode == 200) {
      final String loginResponse = response.body;
      print(response.body);
      Map<String, dynamic> d = json.decode(loginResponse.trim());
      var status = d["success"];
      // clockStatus = d["clock_status"];
      // attendanceIdInt = d["attendanceID"];
      // if(attendanceIdInt == null){
      //   attendanceIdInt = '0';
      // }
      if (status != 'success') {
        CommonMethods.showToast('We are experiencing a technical error. Please try again in sometime');
      } else {
        SchedulerModel schedulerModel = schedulerModelFromJson(response.body);
        List<Datum> userSchedule = schedulerModel.data;
        // for(int x=0;x<userSchedule.length;x++){
        //   String getTomorrowDate = getTomorrow();
        //   if(getTomorrowDate == userSchedule[x].scheduleDate){
        //     isScheduleTomorrow = true;
        //   }
        // }
        if(userSchedule.length == 0){
          return 'data_not_found';
        }
        else {
          List<Datum> testSchedule = [];
          List<String> myDates = listOf7Days();
          String mtFirstDate = myDates[0].substring(myDates[0].length - 2);
          int mtFirstDateInt = int.parse(mtFirstDate);
          int shouldLen = listOf7Days().length;
          for (int i = 0; i < shouldLen; i++) {
            if(i==userSchedule.length){
              testSchedule.add(new Datum(
                  scheduleDate: DateTime.parse(listOf7Days()[0]).toString(),
                  scheduleStartTime: 'not found',
                  scheduleEndTime: 'not found'));
              i--;
              shouldLen--;
            }
            else {
              int serverDate = int.parse(userSchedule[i].scheduleDate.split('-')[2]);
              String currentMonth = userSchedule[i].scheduleDate.split('-')[1];
              String currentYear = CommonMethods.getCurrentYear();
              int currentYearInt = int.parse(currentYear);
              if(currentMonth == '01'||currentMonth == '03'||currentMonth == '05'||currentMonth == '07'||currentMonth == '08'||currentMonth == '10'||currentMonth == '12'){
                if (mtFirstDateInt == 32) {
                  mtFirstDateInt = 1;
                }
              }
              else if(currentMonth == '04'||currentMonth == '06'||currentMonth == '09'||currentMonth == '11'){
                if (mtFirstDateInt == 32) {
                  mtFirstDateInt = 1;
                }
              }
              else{
                if (currentYearInt/4==0) {
                  if(mtFirstDateInt == 29) {
                    mtFirstDateInt = 1;
                  }
                }
                else{
                  if(mtFirstDateInt == 28) {
                    mtFirstDateInt = 1;
                  }
                }
              }
              if (mtFirstDateInt != serverDate) {
                testSchedule.add(new Datum(
                    scheduleDate: DateTime.parse(listOf7Days()[0]).toString(),
                    scheduleStartTime: 'not found',
                    scheduleEndTime: 'not found'));
                i--;
                shouldLen--;
              }
              else {
                testSchedule.add(userSchedule[i]);
              }
              mtFirstDateInt++;
            }
          }
          // rosterIdCurrentDay = testSchedule[getNumberOfDayOfWeek()].rosterId.toString();
          if (userSchedule.length == 0) {
            return 'data_not_found';
          }
          else {
            return testSchedule;
          }
        }
      }
      print(loginResponse);
    }
  }

  String getFirstDateOfNextWeek(int daysNum){
    DateTime today = DateTime.now();
    var _firstDayOfTheweek = today.subtract(new Duration(days: today.weekday-8-daysNum));
    var formatter = new DateFormat('dd MMM');
    String formattedDate2 = formatter.format(_firstDayOfTheweek);
    String day = DateFormat('EEEE').format(_firstDayOfTheweek);
    return formattedDate2+' ('+day+')';
  }

  Widget customPage(int pageNumber, Datum userSchedule){
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                getFirstDateOfNextWeek(pageNumber),
                style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: '.SF UI Display',
                    fontWeight: FontWeight.w800,
                    color: app_theme_dark_color
                ),
              ),
              userSchedule.scheduleStartTime == 'not found'?Padding(
                padding: const EdgeInsets.only(top: 200.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.speaker_notes_off_rounded,
                        size: 50.0,
                        color: app_theme_dark_color,
                      ),
                      Text(
                        'You are not scheduled on the Roster',
                        style: TextStyle(
                          color: app_theme_dark_color,

                        ),
                      ),
                    ],
                  ),
                ),
              ):Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Text(
                      'Start Time: '+userSchedule.scheduleStartTime,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: app_theme_dark_color
                      ),
                    ),
                  ),
                  userSchedule.scheduleEndTime != null?Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      'End Time: '+userSchedule.scheduleEndTime,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: app_theme_dark_color
                      ),
                    ),
                  ):Text(''),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  String anyDayOfWeek(int daysNum){
    DateTime today = DateTime.now();
    var _firstDayOfTheweek = today.subtract(new Duration(days: today.weekday-1-daysNum));
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate2 = formatter.format(_firstDayOfTheweek);
    return formattedDate2;
  }

  Widget getSchedulerView(bool isCurrentWeek,List<Datum> userSchedule){
    List<Widget> viewList = [];
    for(int i=0;i<userSchedule.length;i++){
      viewList.add(customPage(i,userSchedule[i]));
    }
    return CleanSwiper(children: viewList,
      initialPage: 0,
      viewportFraction: 0.9,);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: getLoginToken(),
      builder: (context,snapshot1){
        if(snapshot1.data == null){
          return Text('');
        }
        else{
          return FutureBuilder(
            future: getCurrentWeekSchedular(anyDayOfWeek(7),anyDayOfWeek(13),snapshot1.data[0],snapshot1.data[1],snapshot1.data[2]),
            builder: (context, snapshot){
              if(snapshot.data == null){
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
              else if(snapshot.data == 'data_not_found'){
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.speaker_notes_off_rounded,
                        size: 50.0,
                        color: app_theme_dark_color,
                      ),
                      Text(
                        'You are not scheduled on the Roster this week',
                        style: TextStyle(
                          color: app_theme_dark_color,

                        ),
                      ),
                    ],
                  ),
                );
              }
              else{
                return getSchedulerView(true,snapshot.data);
              }
            },
          );
        }
      },
    );

  }

}