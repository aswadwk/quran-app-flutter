import 'package:al_quran/common/global_thme.dart';
import 'package:al_quran/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrayPage extends StatelessWidget {
  // const PrayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Pray Page'),
      body: Text('Pray Page'),
    );
  }
}
