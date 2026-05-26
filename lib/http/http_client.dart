import 'package:http/http.dart';

class HttpClient
{
  final client = Client();

  Future<Response> get({required String url, Map<String, String>? headers})
  {
    return client.get(Uri.parse(url), headers: headers);
  }

  Future<Response> post({required String url, Map<String, String>? headers, Map<String, String>? body})
  {
    return client.post(Uri.parse(url), headers: headers, body: body);
  }
}