import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart';

class Picker {
  PlatformFile file = PlatformFile(name: '', size: 0);
  String filePath = '';
  String fileName = '';
  List<int> fileByte = [];

  Future<void> selectFolder({
    required BuildContext context,
    String? message,
  }) async {
    final String? temp =
        await FilePicker.platform.getDirectoryPath(dialogTitle: message);
    filePath = (temp == '/' || temp == null) ? '' : temp;
  }

  Future<void> selectFile(
      {required BuildContext context,
      required List<String> ext,
      String? message}) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ext,
      dialogTitle: message,
      withData: false,
      withReadStream: true,
    );

    if (result != null) {
      file = result.files.first;
    }
  }

  Future<bool> loadFile() async {
    if (fileByte.isNotEmpty) return true;
    if (file.size > 0) {
      if (!kIsWeb) filePath = file.path!;
      fileName = file.name;
      await ByteStream(file.readStream!).forEach((element) {
        fileByte.addAll(element);
      });
      return true;
    }
    return false;
  }

  downloadFile() {
    // prepare
    final blob = html.Blob([fileByte]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = fileName;
    html.document.body!.children.add(anchor);

// download
    anchor.click();

// cleanup
    html.document.body!.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}
