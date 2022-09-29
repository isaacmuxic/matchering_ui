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
  Map<String, List<int>> file = {'': []};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListItem(
          //title: AppLocalizations.of(context)!.onlyMP3,
          //errorMsg: errorMsg['song']!,
          //error: displayErrorMsg['song']!,
          onPress: () => pickFile(),
          child: file.keys.first.trim() == ''
              ? const Icon(
                  Icons.cloud_upload,
                )
              : Text(
                  file.keys.first,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
        ),
        if (file.values.first.isNotEmpty) Player(bytes: file.values.first),
        if (file.values.first.isNotEmpty)
          FutureBuilder<List<int>>(
              future: matchering(
                  file.values.first,
                  file.keys
                      .first), // a previously-obtained Future<String> or null
              builder:
                  (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
                if (snapshot.hasData) {
                  return Player(bytes: snapshot.data!);
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
                  return const SizedBox(
                    width: 60,
                    height: 60,
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
      file = {'': []};
    });
    try {
      var result = await Picker.selectFile(
        context: context,
        ext: ['mp3'],
        //message: AppLocalizations.of(context)!.selectBackFile,
      );

      setState(() {
        file = result;
      });
    } catch (e) {
      print('Error in pickFile: $e');
    }
  }
}
