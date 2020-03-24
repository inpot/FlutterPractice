import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class SimplePref {
  Map<String, dynamic> content;
  File prefFile;
  static var defaltEncoding = Encoding.getByName("utf-8");

  SimplePref(this.content, this.prefFile);

  static Future<SimplePref> getPref(String prefName) async {
    var prefDir = await getApplicationSupportDirectory();
    var path = "${prefDir.path}${Platform.pathSeparator}$prefName";
    var file = File(path);
    Map<String, dynamic> content = Map();
    if (!await file.exists()) {
      await file.create(recursive: true);
    } else {
      var contentStr = await file.readAsString(encoding: defaltEncoding);
      if (contentStr.isNotEmpty) {
        content = jsonDecode(contentStr);
      }
    }
    return SimplePref(content, file);
  }

  void putInt(String key, int value) async {
    content[key] = value;
    _save();
  }

  void putDouble(String key, double value) async {
    content[key] = value;
    _save();
  }

  void putString(String key, String value) async {
    content[key] = value;
    _save();
  }

  void _save() async {
  //  Map<String, dynamic> jsonData = {"name":"vishwajit"};
//print(JsonEncoder().convert(jsonData));
    var str = jsonEncode( content); 
    print(str); 
     await prefFile.writeAsString(str);
  }

  int getInt(String key, int defaultValue) {
    if (content.containsKey(key)) {
      return content[key];
    } else {
      return defaultValue;
    }
  }

  double getDouble(String key, double defaultValue) {
    if (content.containsKey(key)) {
      return content[key];
    } else {
      return defaultValue;
    }
  }

  String getString(String key, String defaultValue) {
    if (content.containsKey(key)) {
      return content[key];
    } else {
      return defaultValue;
    }
  }
}
