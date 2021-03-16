import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Now I didn't want to use an actual database to do this because it kinda [seemed overkill](https://i.kym-cdn.com/photos/images/newsfeed/001/449/433/3cb.jpg)
/// 
/// So I've got a dead simple map in map out json file type database.
/// 
/// ...if you can even call it a database
class SaveData {
  static Future<void> save(Map data) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File file = File("${appDocDir.path}/messageData.json");

    if (await file.exists()) {
      await file.writeAsString(jsonEncode(data));
    } else {
      await file.create();
      await file.writeAsString(jsonEncode(data));
    }
  }

  static Future<Map<String, String>> load() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File file = File("${appDocDir.path}/messageData.json");

    if (await file.exists()) {
      String data = await file.readAsString();

      Map<String, String> returnData = new Map<String, String>.from(jsonDecode(data));

      print(returnData);

      return returnData;
    } else {
      await file.create();
      return {};
    }
  }
}
