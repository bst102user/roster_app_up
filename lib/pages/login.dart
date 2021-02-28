import 'dart:convert';

import 'package:android_multiple_identifier/android_multiple_identifier.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:roster_app/common/api_interface.dart';
import 'package:roster_app/common/common_methods.dart';
import 'package:roster_app/models/LoginModel.dart';
import 'package:roster_app/models/location_model.dart';
import 'package:roster_app/pages/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import 'package:device_id/device_id.dart';

class Login extends StatefulWidget {
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  String fcmTokenStr;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Location location = Location();
  String _platformVersion = 'Unknown';
  String _imei = 'Unknown';
  String _serial = 'Unknown';
  String _androidID = 'Unknown';
  Map _idMap = Map();

  goToMainPage() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Dashboard()),
        (Route<dynamic> route) => false);
  }

  Future<bool> openLocationSetting() async {
    bool serviceStatus = await location.serviceEnabled();
    return serviceStatus;
  }

  Future<String> getFcmToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String fcmTokenStr = prefs.getString('firebase_token');
    return fcmTokenStr;
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    String imei;
    String serial;
    String androidID;
    Map idMap;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await AndroidMultipleIdentifier.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    bool requestResponse = await AndroidMultipleIdentifier.requestPermission();
    print("NEVER ASK AGAIN SET TO: ${AndroidMultipleIdentifier.neverAskAgain}");

    try {
      // imei = await AndroidMultipleIdentifier.imeiCode;
      // serial = await AndroidMultipleIdentifier.serialCode;
      // androidID = await AndroidMultipleIdentifier.androidID;

      idMap = await AndroidMultipleIdentifier.idMap;
    } catch (e) {
      idMap = Map();
      idMap["imei"] = 'Failed to get IMEI.';
      idMap["serial"] = 'Failed to get Serial Code.';
      idMap["androidId"] = 'Failed to get Android id.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _idMap = idMap;
      _imei = _idMap["imei"];
      _serial = _idMap["serial"];
      _androidID = _idMap["androidId"];
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    // getFcmToken();
  }



  loginUser(String username, String password) async {
    if (_formKey.currentState.validate()) {
      openLocationSetting().then((value) {
        if (value) {
          CommonMethods.showAlertDialog(context);
          CommonMethods.getId(context).then((value1){
            getFcmToken().then((value) async {
              var mBody = {
                "email": username,
                "password": password,
                "userToken": value,
                "device_id": value1
              };
              print(mBody.toString());
              final response =
              await http.post(ApiInterface.LOGIN_USER, body: mBody);
              print(response.body);
              if (response.statusCode == 200) {
                Navigator.pop(context);
                final String loginResponse = response.body;
                print(response.body);
                Map<String, dynamic> d = json.decode(loginResponse.trim());
                var status = d["status"];
                if (status != 'success') {
                  CommonMethods.showToast(d["massege"]);
                } else {
                  LoginModel loginModal = loginModelFromJson(response.body);
                  SharedPreferences mPref = await SharedPreferences.getInstance();
                  mPref.setBool("login_status", true);
                  CommonMethods.savePrefStr("user_token", loginModal.data);
                  mPref.setString(
                      "email_pref", loginModal.userDetails.userLoginEmail);
                  mPref.setString(
                      "f_name_pref", loginModal.userDetails.userFirstName);
                  mPref.setString(
                      "l_name_pref", loginModal.userDetails.userLastName);
                  mPref.setString(
                      "mobile_pref", loginModal.userDetails.userPhoneNo);
                  mPref.setString(
                      "address_pref", loginModal.userDetails.userAddress);
                  mPref.setString(
                      "user_id", loginModal.userDetails.userId.toString());
                  CommonMethods.showToast('Login Success');
                  // getLocationData(loginModal.data);
                  goToMainPage();
                }
                print(loginResponse);
              } else {
                Navigator.of(context).pop();
                CommonMethods.showToast(
                    'Opps! You have entered invalid credentials');
                return null;
              }
            });
          });
        } else {
          CommonMethods.showToast('Enable your device location');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Image.asset('assets/images/splash_icon.png'),
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            return val.isEmpty ? 'Please enter email' : null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                            controller: passController,
                            obscureText: true,
                            validator: (val) {
                              return val.isEmpty
                                  ? 'Please enter password'
                                  : null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: MaterialButton(
                      onPressed: () {
                        loginUser(emailController.text, passController.text);
                        // print('_platformImei:- '+_idMap.toString());
                      },
                      minWidth: double.infinity,
                      color: const Color(0xFF401461),
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
