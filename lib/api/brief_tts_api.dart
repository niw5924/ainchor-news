import 'package:dio/dio.dart';
import 'dio_client.dart';

class BriefTtsApi {
  static Future<dynamic> summary({
    required String text,
    required int summaryCount,
  }) async {
    final res = await DioClient.dio.post(
      '/api/brief-tts/summary',
      data: {'text': text, 'summaryCount': summaryCount},
    );
    return res.data;
  }

  static Future<dynamic> tts({
    required String anchorName,
    required String summary,
  }) async {
    final res = await DioClient.dio.post(
      '/api/brief-tts/tts',
      data: {'anchorName': anchorName, 'summary': summary},
      options: Options(responseType: ResponseType.bytes),
    );
    return res.data;
  }
}
