import 'dart:convert';

import 'package:al_quran/data/api/detail_surah_service.dart';
import 'package:al_quran/data/models/ayat_model.dart';
import 'package:al_quran/data/models/surah_model.dart';
import 'package:al_quran/common/global_thme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailSurahPage extends StatefulWidget {
  final int noSurat;

  const DetailSurahPage({super.key, required this.noSurat});

  @override
  State<DetailSurahPage> createState() => _DetailSurahPageState();
}

Future<Surah> getDetailSurah({required int noSurat}) async {
  var response = await Dio().get('https://equran.id/api/v2/surat/${noSurat}');

  if (response.statusCode != 200) throw Exception('Failed to load data');

  return Surah.fromJson(jsonDecode(response.toString())['data']);
}

class _DetailSurahPageState extends State<DetailSurahPage> {
  late Future<Surah> _detailSurah;

  @override
  void initState() {
    super.initState();
    _detailSurah = DetailSurahService().getDetailSurah(noSurat: widget.noSurat);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _detailSurah,
      initialData: null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Failed to load data'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        }
        Surah surah = snapshot.data!;
        print(surah.ayat![0].audio);
        return Scaffold(
          // child: Text('${noSurat}'),
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: _appBar(context, surah: surah),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: _headerDetailSurah(context, surah: surah),
              )
            ],
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: ListView.separated(
                itemBuilder: (context, index) => _ayatItem(
                  context,
                  ayat: surah.ayat![index],
                ),
                separatorBuilder: (context, index) =>
                    Padding(padding: EdgeInsets.only(top: 10)),
                itemCount: surah.jumlahAyat,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _ayatItem(BuildContext context, {required Ayat ayat}) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 27,
                    height: 27,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13.5),
                      color:
                          Theme.of(context).colorScheme.primary.withOpacity(.2),
                    ),
                    child: Center(child: Text(ayat.nomorAyat.toString())),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.play_arrow_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.share_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.bookmark_border_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            Text(
              ayat.teksArab,
              style: GoogleFonts.amiri(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                height: 2.2,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 16),
            Text(
              ayat.teksIndonesia,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.left,
            ),
            Text(ayat.audio[01].toString())
          ],
        ),
      );

  Widget _headerDetailSurah(BuildContext context, {required Surah surah}) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Stack(children: [
            Container(
              height: 257,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(colors: [
                  Color(0xFFDF98FA),
                  Color(0xFF9055FF),
                ]),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Opacity(
                  opacity: .2,
                  child: SvgPicture.asset(
                    'assets/svgs/banner_icon.svg',
                    width: 324 - 55,
                  )),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    surah.namaLatin,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    surah.arti,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Divider(
                    color: Colors.white30.withOpacity(.35),
                    thickness: 2,
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        surah.tempatTurun.name,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: text,
                          ),
                        ),
                      ),
                      Text(
                        '${surah.jumlahAyat} Ayat',
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SvgPicture.asset('assets/svgs/bismillah_icon.svg'),
                ],
              ),
            )
          ]),
        ),
      );

  AppBar _appBar(BuildContext context, {required Surah surah}) => AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: (() => Navigator.of(context).pop()),
              icon: const Icon(Icons.arrow_back),
            ),
            Text(
              surah.namaLatin,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/svgs/search_icon.svg'),
            ),
          ],
        ),
      );
}
