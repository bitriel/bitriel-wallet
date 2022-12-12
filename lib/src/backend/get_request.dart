

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as _http;
import 'package:wallet_apps/src/backend/backend.dart';

Future<_http.Response> getSelendraEndpoint() async {
  print("getSelendarEndpoint ${dotenv.get('SELENDRA_API')}");
  return await _http.get(Uri.parse(dotenv.get('SELENDRA_API')));
}

/* MetaDoers World */

Future<_http.Response> getAllEvent() async {
  print("getAllEvent ${dotenv.get('DOERS_API')}");
  return await _http.get(Uri.parse("${dotenv.get('DOERS_API')}events"));
}

Future<_http.Response> getTickets(String tk) async {

  return await _http.get(
    // Uri.parse("${dotenv.get('DOERS_API')}sessions/by-ticket-type"), // Old
    Uri.parse("${dotenv.get('DOERS_API')}tickets"),
    headers: conceteHeader(key: "Authorization", value: tk)
  );
}

Future<_http.Response> queryEventById(String evntId) async {

  return await _http.get(
    // Uri.parse("${dotenv.get('DOERS_API')}sessions/by-ticket-type"), // Old
    Uri.parse("${dotenv.get('DOERS_API')}events/$evntId"),
    headers: conceteHeader()
  );
}