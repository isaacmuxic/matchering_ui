import 'package:dio/dio.dart';

Future<List<int>> matchering(List<int> bytes, String name) async {
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
    Response response = await dio.post(
      'http://20.255.62.78/main-app/matchering',
      data: FormData.fromMap(
        {'song': MultipartFile.fromBytes(bytes, filename: name)},
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
