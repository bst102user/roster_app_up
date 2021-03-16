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
  GetEntity selectedEntity;
  List<GetEntity> entityList;

  GetLocation selectedLocation;
  List<GetLocation> locationList;
  bool isEntityOne = false;
  @override
  void initState() {
    super.initState();
    getUserId().then((userId){
      getRestaurantData(userId).then((entityValue){
          if(entityValue != null){
            setState(() {
              entityList = entityValue;
              if(selectedEntity == null){
                selectedEntity = entityList[0];
                savePrefValue('user_entity', selectedEntity.entityId.toString());
              }
              getRestaurantLocations(userId, selectedEntity.entityId.toString()).then((locationValue){
                setState(() {
                  locationList = locationValue;
                });
              });
            });
          }
      });
    });
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

  Future<String> getEntity() async {
    SharedPreferences mPref = await SharedPreferences.getInstance();
    String entityStr = mPref.getString('user_entity_str');
    return entityStr;
  }

  Future<String> getLocation() async {
    SharedPreferences mPref = await SharedPreferences.getInstance();
    String locationStr = mPref.getString('user_location_str');
    return locationStr;
  }

  Future getRestaurantData(String userId) async {
    final response = await http.get(ApiInterface.ALL_RESTAURANT + userId);
    if (response.statusCode == 200) {
      final String restrntResponse = response.body;
      print(response.body);
      RestaurantModel restaurantModel = restaurantModelFromJson(
          restrntResponse);
      List<Entity> restrntList = restaurantModel.entity;
      if(restrntList.length == 1){
        isEntityOne = true;
      }
      if (restrntList.length != 0) {
        List<GetEntity> gtEnttList = [];
        for(int i=0;i<restrntList.length;i++){
          GetEntity getEntity = restrntList[i].getEntity[0];
          gtEnttList.add(getEntity);
        }
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
    CommonMethods.showAlertDialog(context);
    final response = await http.get(ApiInterface.ALL_REST_LOCATION + userId+'/'+entityId);
    if (response.statusCode == 200) {
      print(response.body);
      Navigator.pop(context);
      final String restrntLocationResponse = response.body;
      RestrntLocationModel locationModel = restrntLocationModelFromJson(restrntLocationResponse);
      List<Location> allLocations = locationModel.location;
      if(isEntityOne){
        if(allLocations.length == 1){
          SharedPreferences mPref = await SharedPreferences.getInstance();
          GetLocation getEntity = allLocations[0].getLocation[0];
          mPref.setBool("login_status", true);
          savePrefValue('user_entity', getEntity.entityId.toString());
          savePrefValue('user_location', getEntity.locationId.toString());
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
        }
      }
      if (allLocations.length != 0) {
        List<GetLocation> gtLocList = [];
        for(int i=0;i<allLocations.length;i++){
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
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: FutureBuilder(
                            future: getEntity(),
                            builder: (context,snapshot){
                              if(snapshot.data == null||snapshot.data == ''){
                                return Text('Select Entity');
                              }
                              else{
                                return Text('Select Entity ('+snapshot.data+')');
                              }
                            },
                          ),
                        ),
                        entityList==null?Center(
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
                  ):
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: app_theme_dark_color,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 50.0,vertical: 5),
                              child: DropdownButtonHideUnderline(
                                child: new DropdownButton<GetEntity>(
                                  value: selectedEntity,
                                  isDense: true,
                                  onChanged: (GetEntity newValue) {
                                    selectedLocation = null;
                                    setState(() {
                                      selectedEntity = newValue;
                                      savePrefValue('user_entity', selectedEntity.entityId.toString());
                                      savePrefValue('user_entity_str', newValue.entityName);
                                    });
                                    getUserId().then((value){
                                      getRestaurantLocations(value, selectedEntity.entityId.toString()).then((locationValue){
                                        setState(() {
                                          locationList = locationValue;
                                        });
                                      });
                                    });
                                    print(selectedEntity);
                                  },
                                  items: entityList.map((GetEntity map) {
                                    return new DropdownMenuItem<GetEntity>(
                                      value: map,
                                      child: new Text(map.entityName,
                                          style: new TextStyle(color: Colors.black)),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),

                        locationList==null?Center(
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
                        ):
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: FutureBuilder(
                                  future: getLocation(),
                                  builder: (context,snapshot){
                                    if(snapshot.data == null||snapshot.data == ''){
                                      return Text('Select Location');
                                    }
                                    else{
                                      return Text('Select Location ('+snapshot.data+')');
                                    }
                                  },
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: app_theme_dark_color,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 50.0,vertical: 5),
                                    child: DropdownButtonHideUnderline(
                                      child: new DropdownButton<GetLocation>(
                                        hint: Text('Select Location'),
                                        value: selectedLocation,
                                        isDense: true,
                                        onChanged: (GetLocation newValue) {
                                          setState(() {
                                            selectedLocation = newValue;
                                          });
                                          print(selectedLocation);
                                          savePrefValue('user_location', selectedLocation.locationId.toString());
                                          savePrefValue('user_location_str', selectedLocation.locationAddress);
                                        },
                                        items: locationList.map((GetLocation map) {
                                          return new DropdownMenuItem<GetLocation>(
                                            value: map,
                                            child: new Text(map.locationAddress,
                                                style: new TextStyle(color: Colors.black)),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: RaisedButton(
                              color:app_theme_dark_color,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              onPressed: ()async {
                                if(selectedLocation == null){
                                  CommonMethods.showToast('Please select entity and location');
                                }
                                else{
                                  SharedPreferences mPref = await SharedPreferences.getInstance();
                                  mPref.setBool("login_status", true);
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
                                }
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
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }

}