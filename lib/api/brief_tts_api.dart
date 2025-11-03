import 'dio_client.dart';

class BriefTtsApi {
  static Future<dynamic> convert(String text) async {
    final res = await DioClient.dio.post(
      '/api/brief-tts/convert',
      data: {'text': text},
    );
    return res.data;
  }
}
