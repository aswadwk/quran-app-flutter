import 'dart:convert';
import 'package:al_quran/data/models/surah_model.dart';
import 'package:dio/dio.dart';

class DetailSurahService {
  // final int noSurat;

  // DetailSurahService({required this.noSurat});

  Future<Surah> getDetailSurah({required int noSurat}) async {
    var response = await Dio().get('https://equran.id/api/v2/surat/${noSurat}');

    if (response.statusCode != 200) throw Exception('Failed to load data');

    return Surah.fromJson(jsonDecode(response.toString())['data']);
  }
}
