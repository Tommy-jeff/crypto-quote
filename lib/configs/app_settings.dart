

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier{
  late SharedPreferences _sharedPreferences;

  Map<String, String> locale = {
    "locale" : "pt_BR",
    "name" : "R\$",
  };

  AppSettings(){
    _startSettings();
  }

  _startSettings() async {
    await _startPreferences();
    await _readLocale();
  }

  Future<void> _startPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  _readLocale() async {
    final local = _sharedPreferences.getString("local") ?? "pt_BR";
    final name = _sharedPreferences.getString("name") ?? "R\$";

    locale = {
      "locale" : local,
      "name" : name,
    };
    notifyListeners();
  }

  setLocale(String local, String name) async {
    await _sharedPreferences.setString("local", local);
    await _sharedPreferences.setString("name", name);
    await _readLocale();
  }

}

