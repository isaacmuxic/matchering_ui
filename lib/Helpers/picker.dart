import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
class Picker {
  static Future<String> selectFolder({
    required BuildContext context,
    String? message,
  }) async {
    final String? temp =
        await FilePicker.platform.getDirectoryPath(dialogTitle: message);
    return (temp == '/' || temp == null) ? '' : temp;
  }

  static Future<Map<String, List<int>>> selectFile({
    required BuildContext context,
    required List<String> ext,
    String? message,
  }) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ext,
      dialogTitle: message,
    );

    if (result != null) {
      final List<int> fileBytes =
          result.files.first.bytes!.toList(growable: false);
      final String fileName = result.files.first.name;

      return {fileName: fileBytes};
    }
    return {'': []};
  }
}
