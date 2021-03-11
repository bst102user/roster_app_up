import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roster_app/common/api_interface.dart';
import 'package:roster_app/common/common_methods.dart';
import 'package:roster_app/models/rest_location_model.dart';
import 'package:roster_app/models/restaurant_model.dart';
import 'package:http/http.dart' as http;
import 'package:roster_app/pages/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowRestaurant extends StatefulWidget {
  ShowRestaurantState createState() => ShowRestaurantState();
}

class ShowRestaurantState extends State<ShowRestaurant> {
  GetEntity entityUser;
  GetLocation enttLocation;
  int selectedIndexForEntt = 0;
  int selectedIndexForLocation = 0;
  int mEntityId = 0;
  int mLocationId = 0;
  bool progressForEntity = true;
  bool progressForLocation = true;
  @override
  void initState() {
    super.initState();
  }

  savePrefValue(String key, String value)async{
    SharedPreferences mPref = await SharedPreferences.getInstance();
    mPref.setString(key, value);
  }

  Future<String> getUserId() async {
    SharedPreferences mPref = await SharedPreferences.getInstance();
    String userId = mPref.getString('user_id');
    return userId;
  }

  Future<dynamic> getRestaurantData(String userId) async {
    final response = await http.get(ApiInterface.ALL_RESTAURANT + userId);
    if (response.statusCode == 200) {
      if(!progressForEntity){
        Navigator.pop(context);
        progressForEntity = true;
      }
      final String restrntResponse = response.body;
      print(response.body);
      RestaurantModel restaurantModel = restaurantModelFromJson(
          restrntResponse);
      List<Entity> restrntList = restaurantModel.entity;
      if (restrntList.length != 0) {
        List<GetEntity> gtEnttList = [];
        for(int i=0;i<restrntList.length;i++){
          GetEntity getEntity = restrntList[i].getEntity[0];
          gtEnttList.add(getEntity);
        }
        mEntityId = gtEnttList[0].entityId;
        return gtEnttList;
      }
      else {
        return 'no_entity';
      }
    }
    else {
      return 'server_error';
    }
  }

  Future<dynamic> getRestaurantLocations(String userId, String entityId) async {
    final response = await http.get(ApiInterface.ALL_REST_LOCATION + userId+'/'+entityId);
    if (response.statusCode == 200) {
      if(!progressForLocation){
        Navigator.pop(context);
        progressForLocation = true;
      }
      final String restrntLocationResponse = response.body;
      RestrntLocationModel locationModel = restrntLocationModelFromJson(restrntLocationResponse);
      List<Location> allLocations = locationModel.location;
      if (allLocations.length != 0) {
        List<GetLocation> gtLocList = [];
        for(int i=0;i<allLocations.length;i++){
          enttLocation = allLocations[selectedIndexForLocation].getLocation[0];
          GetLocation getEntity = allLocations[i].getLocation[0];
          gtLocList.add(getEntity);
        }
        return gtLocList;
      }
      else {
        return 'no_entity';
      }
    }
    else {
      return 'server_error';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant and Location'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
              future: getUserId(),
              builder: (context, snapshot) {
                if(snapshot.data == null){
                  return Text('');
                }
                else{
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        FutureBuilder(
                          future: getRestaurantData(snapshot.data),
                          builder: (context, snapshotRes){
                            if(snapshotRes.data == null){
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
                            else if(snapshotRes.data == 'no_entity'){
                              return Text('No Restaurent Allocated for you');
                            }
                            else if(snapshotRes.data.length == 1){
                              return Text('Restaurent1');
                            }
                            else{
                              List<GetEntity> allRestList = snapshotRes.data;
                              entityUser = allRestList[selectedIndexForEntt];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5.0),
                                      child: Text('Select Entity'),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(20))
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                          child: DropdownButtonFormField<GetEntity>(
                                            items: allRestList.map((GetEntity user) {
                                              return new DropdownMenuItem<GetEntity>(
                                                value: user,
                                                child: new Text(
                                                  user.entityName,
                                                  style: new TextStyle(color: Colors.black),
                                                ),
                                              );
                                            }).toList(),
                                            decoration: InputDecoration(
                                                enabledBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.transparent))),
                                            hint: new Text("Select a user"),
                                            value:  entityUser,
                                            onChanged: (GetEntity newValue) {
                                              setState(() {
                                                entityUser = newValue;
                                                selectedIndexForEntt = allRestList.indexOf(newValue);
                                                mEntityId = newValue.entityId;
                                                savePrefValue('user_entity', mEntityId.toString());
                                                progressForEntity = false;
                                                CommonMethods.showAlertDialog(context);
                                              });
                                            },

                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top:20.0),
                                      child: FutureBuilder(
                                        future: getRestaurantLocations(snapshot.data, entityUser.entityId.toString()),
                                        builder: (context, locSnapshot){
                                          if(locSnapshot.data == null){
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
                                          else{
                                            List<GetLocation> locationList = locSnapshot.data;
                                            enttLocation = locationList[selectedIndexForLocation];
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 5.0),
                                                  child: Text('Select Location'),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                      ),
                                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                      child: DropdownButtonFormField<GetLocation>(
                                                        decoration: InputDecoration(
                                                            enabledBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.transparent))),
                                                        hint: new Text("Select a user"),
                                                        value:  enttLocation,
                                                        onChanged: (GetLocation newValue) {
                                                          setState(() {
                                                            enttLocation = newValue;
                                                            selectedIndexForLocation = locationList.indexOf(newValue);
                                                            mLocationId = newValue.locationId;
                                                            progressForLocation = false;
                                                            savePrefValue('user_location', mLocationId.toString());
                                                            CommonMethods.showAlertDialog(context);
                                                          });
                                                        },
                                                        items: locationList.map((GetLocation user) {
                                                          return new DropdownMenuItem<GetLocation>(
                                                            value: user,
                                                            child: Text(
                                                              user.locationAddress,
                                                              style:TextStyle(color: Colors.black),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 20.0),
                                                  child: Center(
                                                    child: RaisedButton(
                                                      color:app_theme_dark_color,
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                      onPressed: () {
                                                        Navigator.of(context).pushReplacement(
                                                            MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 8.0),
                                                        child: Text(
                                                          "Continue",
                                                          style: TextStyle(
                                                              color: Colors.white
                                                          ),),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }

}