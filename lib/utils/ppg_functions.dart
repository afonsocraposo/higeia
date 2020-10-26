part of 'fire_functions.dart';

class PPGFunctions {
  static Future<bool> uploadPPGFile(File file) async {
    String path = "ppg/" + file.path.split("/").last;
    return await FireFunctions.uploadFile(file, path);
  }
}
