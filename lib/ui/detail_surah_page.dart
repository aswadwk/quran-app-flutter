import 'dart:convert';

import 'package:al_quran/data/models/ayat_model.dart';
import 'package:al_quran/data/models/surah_model.dart';
import 'package:al_quran/common/global_thme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailSurahPage extends StatelessWidget {
  final int noSurat;

  const DetailSurahPage({super.key, required this.noSurat});

  Future<Surah> _getDetailSurah() async {
    var response = await Dio().get('https://equran.id/api/v2/surat/${noSurat}');

    return Surah.fromJson(jsonDecode(response.toString())['data']);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getDetailSurah(),
      initialData: null,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        Surah surah = snapshot.data!;
        return Scaffold(
          // child: Text('${noSurat}'),
          backgroundColor: background,
          appBar: _appBar(context, surah: surah),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: _details(context, surah: surah),
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
                  color: gray, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Container(
                    width: 27,
                    height: 27,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13.5),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Center(child: Text(ayat.nomorAyat.toString())),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.share_outlined,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.play_arrow_outlined,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.bookmark_border_outlined,
                    color: Colors.black,
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
              ).copyWith(
                color: Colors.white70,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 16),
            Text(
              ayat.teksIndonesia,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white30),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      );

  Widget _details(BuildContext context, {required Surah surah}) => Padding(
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
        backgroundColor: gray,
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