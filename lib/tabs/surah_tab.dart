import 'package:al_quran/models/surah_model.dart';
import 'package:al_quran/pages/detail_surah_page.dart';
import 'package:al_quran/themes/global_thme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SurahTab extends StatelessWidget {
  const SurahTab({super.key});

  @override
  Widget build(BuildContext context) {
    Future<List<Surah>> _getListSurah() async {
      String data = await rootBundle.loadString('assets/datas/list_surah.json');
      print(surahFromJson(data));
      return surahFromJson(data);
    }

    return FutureBuilder(
      future: _getListSurah(),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return ListView.separated(
          itemBuilder: (context, index) => _surahItem(
            context,
            surah: snapshot.data!.elementAt(index),
          ),
          separatorBuilder: (context, index) => Divider(
            color: const Color(0xFFAAAAAAA).withOpacity(0.35),
          ),
          itemCount: snapshot.data!.length,
        );
      }),
    );

    // return Container(
    //   child: Text('Surah'),
    // );
  }
}

Widget _surahItem(BuildContext context, {required Surah surah}) =>
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DetailSurahPage(
            noSurat: surah.nomor,
          ),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Stack(
              children: [
                SvgPicture.asset('assets/svgs/nomor_surah_icon.svg'),
                SizedBox(
                  height: 36,
                  width: 36,
                  child: Center(child: Text('${surah.nomor}')),
                )
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(surah.namaLatin),
                  const SizedBox(width: 4),
                  Row(
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
                  )
                ],
              ),
            ),
            Text(
              surah.nama,
              style: GoogleFonts.amiri(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
