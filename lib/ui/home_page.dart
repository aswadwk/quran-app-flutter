import 'package:al_quran/ui/bookmark_page.dart';
import 'package:al_quran/ui/doa_page.dart';
import 'package:al_quran/ui/pray_page.dart';
import 'package:al_quran/ui/tips_page.dart';
import 'package:al_quran/widgets/tabs/hijb_tab.dart';
import 'package:al_quran/widgets/tabs/page_tab.dart';
import 'package:al_quran/widgets/tabs/para_tab.dart';
import 'package:al_quran/widgets/tabs/surah_tab.dart';
import 'package:al_quran/common/global_thme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedNavbar = 0;
  String _pageTitle = "Quran App";

  void _changeSelectedNavBar(int index) {
    print(index);

    setState(() {
      _selectedNavbar = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [
      _homePage(),
      TipsPage(),
      PrayPage(),
      DoaPage(),
      BookmarkPage(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: _bottomNavigationBar(context),
      body: _children[_selectedNavbar],
    );
  }

  Widget _homePage() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/svgs/menu_icon.svg'),
            ),
            Text(
              'Quran App',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/svgs/search_icon.svg'),
            ),
          ],
        ),
      ),
      body: DefaultTabController(
        length: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: _greeting(context),
              ),
              SliverAppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.background,
                pinned: true,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: _tabBar(),
                ),
              )
            ],
            body: const TabBarView(
              children: [SurahTab(), ParaTab(), PageTab(), HijbTab()],
            ),
          ),
        ),
      ),
    );
  }

  TabBar _tabBar() {
    return TabBar(tabs: [
      _tabBarItem(label: 'Surah'),
      _tabBarItem(label: 'Ayat'),
      _tabBarItem(label: 'Surah'),
      _tabBarItem(label: 'Surah'),
    ]);
  }

  Tab _tabBarItem({required String label}) {
    return Tab(
      child: Text(label),
    );
  }

  Column _greeting(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Assalamualaikum',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          'Hajar Aswad',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        _banner(context)
      ],
    );
  }

  Stack _banner(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 131,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.onBackground,
            ]),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: SvgPicture.asset('assets/svgs/banner_icon.svg'),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/svgs/read_icon.svg'),
                  const SizedBox(width: 10),
                  Text('Last Read'),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Al-Fatihah',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Ayah No: 1',
                style: Theme.of(context).textTheme.labelSmall,
              )
            ],
          ),
        )
      ],
    );
  }

  BottomNavigationBar _bottomNavigationBar(BuildContext context) =>
      BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.background,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedNavbar,
        onTap: _changeSelectedNavBar,
        items: [
          _bottomNavigationBarItem(
            icon: 'assets/svgs/home_icon.svg',
            label: 'Home',
          ),
          _bottomNavigationBarItem(
            icon: 'assets/svgs/lapm_icon.svg',
            label: 'Tips',
          ),
          _bottomNavigationBarItem(
            icon: 'assets/svgs/pray_icon.svg',
            label: 'Pray',
          ),
          _bottomNavigationBarItem(
            icon: 'assets/svgs/doa_icon.svg',
            label: 'Doa',
          ),
          _bottomNavigationBarItem(
            icon: 'assets/svgs/bookmark_icon.svg',
            label: 'Bookmark',
          ),
        ],
      );

  BottomNavigationBarItem _bottomNavigationBarItem(
          {required String icon, required String label}) =>
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          icon,
          color: text,
        ),
        label: label,
        activeIcon: SvgPicture.asset(
          icon,
          color: primary,
        ),
      );

  AppBar _appBar(BuildContext context, {required String pageTitle}) => AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/svgs/menu_icon.svg'),
            ),
            Text(
              pageTitle,
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
