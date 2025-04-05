import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/home_model.dart';

class HomeViewModel {
   String backgroundImageUrl = 'https://assets.nflxext.com/ffe/siteui/vlv3/9d3533b2-0e2b-40b2-95e0-ecd7979cc88b/a3873901-5b7c-46eb-b9fa-12ffd1dfe371/TR-tr-20240129-popsignuptwoweeks-perspective_alpha_website_medium.jpg';

  final String url = "https://www.apirequest.in/movie/api";

  Future<List<HomeModel>?> fetchMovie() async {
    Uri uri = Uri.parse(url);
    var res = await http.get(uri);

    if (res.statusCode == 200 || res.statusCode == 201) {
      List<dynamic> jsonBody = jsonDecode(res.body);
      return jsonBody.map((movie) => HomeModel.fromJson(movie)).toList();
    } else {
      print("Error: ${res.statusCode}");
    }
    return null;
  }
}