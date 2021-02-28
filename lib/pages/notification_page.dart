import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roster_app/common/api_interface.dart';
import 'package:http/http.dart' as http;
import 'package:roster_app/common/common_methods.dart';
import 'package:roster_app/models/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget{
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage>{

  Future<String> getLoginToken()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.getString('user_token');
    return userToken;
  }

  Future<dynamic> getNotifData(String userToken)async{
    var mBody = {
      "remember_token": userToken,
    };
    final response = await http.post(ApiInterface.NOTIFICATION_LIST, body: mBody);
    print(response.body);
    if(response.statusCode == 200){
      NotificationModel notificationModel = notificationModelFromJson(response.body);
      List<SuccessNotif> dataList = notificationModel.success;
      return dataList;
    }
    else{
      return 'no_data_key';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: getLoginToken(),
          builder: (context, tokenSnap){
            if(tokenSnap.data == null){
              return Text('');
            }
            else{
              return FutureBuilder(
                future: getNotifData(tokenSnap.data),
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
                  else if(snapshot.data == 'no_data_key'){
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.notifications_off_outlined,
                            color: app_theme_dark_color,
                            size: 50.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'No Notification found for you',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: app_theme_dark_color
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  else{
                    return snapshot.data[0].massege==null?Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.notifications_off_outlined,
                            color: app_theme_dark_color,
                            size: 50.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'No Notification found for you',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: app_theme_dark_color
                              ),
                            ),
                          )
                        ],
                      ),
                    ):ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index){
                        List<SuccessNotif> itemList = snapshot.data;
                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      itemList[index].title.toString()==null?'No Data':itemList[index].title.toString()?.replaceFirst(r"Title.",""),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17.0,
                                        color: app_theme_dark_color
                                      ),
                                    ),
                                    Text(
                                        CommonMethods.convertDateTimeDisplay(itemList[index].createdAt.toString()),
                                    style: TextStyle(
                                      color: app_theme_dark_color
                                    ),),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    itemList[index].massege==null?'No Data':itemList[index].massege,
                                  style: TextStyle(
                                    color: app_theme_dark_color
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              );
            }
          },
        )
      ),
    );
  }

}