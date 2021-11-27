import 'dart:convert';
import 'dart:io';
import 'package:carli_message/models/message.dart';
import 'package:path_provider/path_provider.dart';

/// Now I didn't want to use an actual database to do this because it kinda [seemed overkill](https://i.kym-cdn.com/photos/images/newsfeed/001/449/433/3cb.jpg)
///
/// So I've got a dead simple map in map out json file type database.
///
/// ...if you can even call it a database
class SaveData {
  SaveData(this.appDocDir);

  static const fileName = "messages.json";

  final Directory appDocDir;

  static Future<SaveData> withDocumentDirectory() async {
    final appDocDir = await getApplicationDocumentsDirectory();

    return SaveData(appDocDir);
  }

  bool _fileExists = false;

  bool get fileExists => _fileExists || File("${appDocDir.path}/$fileName").existsSync();

  /// Only saves response
  Future<void> saveSingleMessage(Message message) async {
    DateTime start = DateTime.now();
    File file = File("${appDocDir.path}/$fileName");

    if (fileExists) {
      String data = await file.readAsString();

      List<Map> returnData = new List<Map>.from(jsonDecode(data));
      final index = returnData.indexWhere((element) => element["message"] == message.message);

      returnData[index]["response"] = message.response;

      await file.writeAsString(jsonEncode(returnData));
    } else {
      await file.create();
      await file.writeAsString(jsonEncode([message.toSaveData()]));
    }
    print("Save single message took: ${DateTime.now().difference(start)}");
  }

  Future<void> saveAllMessages(List<Message> messages) async {
    File file = File("${appDocDir.path}/$fileName");

    if (fileExists) {
      await file.writeAsString(jsonEncode(messages.map((e) => e.toSaveData()).toList()));
    } else {
      await file.create();
      await file.writeAsString(jsonEncode(messages.map((e) => e.toSaveData()).toList()));
    }
  }

  Future<List<Message>> loadAllMessages() async {
    File file = File("${appDocDir.path}/$fileName");

    if (fileExists) {
      String data = await file.readAsString();

      List<Map> returnData = new List<Map>.from(jsonDecode(data));

      print(returnData);

      return returnData.map((e) => Message(message: e["message"]!, response: e["response"]!)).toList();
    } else {
      await file.create();
      return [];
    }
  }
}
