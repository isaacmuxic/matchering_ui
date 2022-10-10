import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

Future<List<int>> matchering(
    BuildContext context, List<int> bytes, String name, bool noEQ) async {
  final dio = Dio(BaseOptions(
    //baseUrl: '',
    headers: {
      'Accept': '*',
      'Access-Control-Allow-Origin': '*/*',
      'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept',
      'Content-Type': 'multipart/form-data',
    },
  ));
  try {
    final jsonString =
        await DefaultAssetBundle.of(context).loadString('assets/config.json');
    final dynamic jsonMap = jsonDecode(jsonString);
    Response response = await dio.post(
      jsonMap['url'],
      data: FormData.fromMap(
        {'song': MultipartFile.fromBytes(bytes, filename: name), 'noEQ': noEQ},
      ),
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data!; // as List<int>;
  } on DioError catch (e) {
    throw Exception(e.response!.data != null
        ? String.fromCharCodes(e.response!.data)
        : e.response!.statusCode);
  }
}
