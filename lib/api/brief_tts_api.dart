import 'dio_client.dart';

class BriefTtsApi {
  static Future<dynamic> convert({
    required String anchorName,
    required String text,
  }) async {
    final res = await DioClient.dio.post(
      '/api/brief-tts/convert',
      data: {'anchorName': anchorName, 'text': text},
    );
    return res.data;
  }
}
