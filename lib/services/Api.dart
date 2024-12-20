import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api {
  static const baseUrl = "http://192.168.1.12:3000/api";
  
  static addUser(Map userData) async{
    print("user data -->" + userData.toString());
    var url = Uri.parse(baseUrl + "/add-user");
    print("url -->" + url.toString());
    try{
      print("masuk 111");
      final res = await http.post(url, body: userData);
      print("masuk 11122");
      if(res.statusCode == 200){
        var data = jsonDecode(res.body.toString());
        print("data server -->" + data);
      }else{
        print("failed to upload dataadada");
      }
    }
    catch (e){
      print("failed-----");
      debugPrint(e.toString());
    }
  }
}