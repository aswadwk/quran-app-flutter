import 'package:al_quran/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class BookmarkPage extends StatelessWidget {
  // const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Bookmark Page'),
      body: Text('Bookmark Page'),
    );
  }
}
