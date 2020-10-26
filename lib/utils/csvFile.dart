import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CSVFile {
  File file;
  IOSink sink;
  String filename;
  List<String> header;

  CSVFile(
    this.filename, {
    this.header,
  });

  Future<void> init() async {
    String path = (await getTemporaryDirectory()).path;
    //String path = (await getExternalStorageDirectory()).path;

    file = File('$path/$filename.csv');

    writeHeader();
  }

  void writeHeader() {
    sink = file.openWrite(mode: FileMode.append);
    if (header != null) {
      sink.write(this.header.join(",") + "\n");
    } else {
      sink.write("millisecondsSinceStart,values\n");
    }
  }

  Future<void> reset() async {
    await sink.close();
    await file.delete();
    await init();
  }

  void writeRow(List<dynamic> row) {
    //print(file);
    //print(sink);
    sink.write(row.map((dynamic value) => value.toString()).join(',') + "\n");
  }

  Future<String> closeFile() async {
    await sink.close();
    return file.path;
  }

  Future<void> delete() async {
    await file?.delete();
  }
}
