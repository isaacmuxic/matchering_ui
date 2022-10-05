import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'list_item.dart';
import '../Helpers/picker.dart';
import 'player.dart';
import '../API/upload.dart';

class LocalFile extends StatefulWidget {
  const LocalFile({super.key});

  @override
  State<LocalFile> createState() => _LocalFileState();
}

class _LocalFileState extends State<LocalFile> {
  Picker uploadPicker = Picker();
  Picker downloadPicker = Picker();
  bool startProcess = false;
  bool checkBypassEQ = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListItem(
              title: "Upload ", //AppLocalizations.of(context)!.onlyMP3,
              //errorMsg: errorMsg['song']!,
              //error: displayErrorMsg['song']!,
              onPress: () => pickFile(),
              child: uploadPicker.file.name.trim() == ''
                  ? const Icon(
                      Icons.cloud_upload,
                    )
                  : Text(
                      uploadPicker.file.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
            ),
          ),
        ),
        if (uploadPicker.file.size > 0) const Text("Original:"),
        if (uploadPicker.file.size > 0)
          FutureBuilder(
              future: uploadPicker.loadFile(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData && snapshot.data!) {
                  return Column(
                    children: [
                      Player(bytes: uploadPicker.fileByte),
                      SizedBox(
                        width: 300,
                        child: CheckboxListTile(
                            title: const Text("Bypass Auto EQ: "),
                            value: checkBypassEQ,
                            onChanged: (b) => {
                                  setState(() {
                                    checkBypassEQ = b!;
                                  })
                                }),
                      ),
                      ListItem(
                          onPress: () => _process(),
                          child: const Center(child: Text("Start process")))
                    ],
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(15),
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        if (uploadPicker.fileByte.isNotEmpty &&
            (startProcess || downloadPicker.fileByte.isNotEmpty))
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Processed:"),
          ),
        if (uploadPicker.fileByte.isNotEmpty &&
            (startProcess || downloadPicker.fileByte.isNotEmpty))
          FutureBuilder<List<int>>(
              future: startProcess
                  ? matchering(uploadPicker.fileByte, uploadPicker.fileName,
                      checkBypassEQ)
                  : null, // Future or null
              builder:
                  (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done ||
                    snapshot.connectionState == ConnectionState.none) {
                  downloadPicker.fileName = uploadPicker.fileName;
                  downloadPicker.fileByte = snapshot.data!;
                  startProcess = false;
                  return _downloader();
                } else if (snapshot.hasError) {
                  return Row(children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  ]);
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(15),
                    child: CircularProgressIndicator(),
                  )
                      //Padding(
                      //  padding: EdgeInsets.only(top: 16),
                      //  child: Text('Awaiting result...'),
                      //),
                      ;
                }
              }),
      ],
    );
  }

  Future<void> pickFile() async {
    setState(() {
      uploadPicker = Picker();
    });
    try {
      await uploadPicker.selectFile(
        context: context,
        ext: ['mp3', 'wav'],
        //message: AppLocalizations.of(context)!.selectBackFile,
      );

      setState(() {
        startProcess = false;
      });
    } catch (e) {
      print('Error in pickFile: $e');
    }
  }

  _process() {
    setState(() {
      downloadPicker = Picker();
      startProcess = true;
    });
  }

  Widget _downloader() {
    return Column(
      children: [
        Player(bytes: downloadPicker.fileByte),
        ListItem(
            title: "Download", //AppLocalizations.of(context)!
            onPress: () => downloadPicker.downloadFile(),
            child: const Icon(Icons.download))
      ],
    );
  }
}
