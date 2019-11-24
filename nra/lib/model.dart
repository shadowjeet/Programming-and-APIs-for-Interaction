import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';




class AccessTicketFile{
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
//    print(path);
    return File('$path/file.txt');
  }

  Future<String> readFileAsString() async {
    String contents = "";
    final file = await _localFile;
    if (file.existsSync()) {
      //Must check or error is thrown
//      debugPrint("File exists");
      contents = await file.readAsString();
    }
    return contents;
  }

  Future<Null> deleteFile() async {
    final file = await _localFile;
    file.writeAsString("");
  }

  Future<Null> appendFile(String text) async {
    final file = await _localFile;
    file.writeAsString('$text\n', mode: FileMode.APPEND);
  }
}
