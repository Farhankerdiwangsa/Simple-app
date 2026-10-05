import 'package:flutter/material.dart';
import 'app_header.dart';
import 'bottom_nav.dart';
import 'dummy_pages.dart';
import 'feed_page.dart';
import 'theme.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'DongHuain',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true).copyWith(scaffoldBackgroundColor: kBg, colorScheme: const ColorScheme.dark(primary: kGreen)),
        home: const Shell(),
      );
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int i = 0;
  bool scrolled = false;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const FeedPage(endpoint: 'completed', title: 'All', accent: 'Donghua', tag: 'UPDATED'),
      const FeedPage(endpoint: 'ongoing', title: 'Latest', accent: 'Donghua', tag: 'ONGOING'),
      const SchedulePage(),
      const FeedPage(endpoint: 'latest', title: 'Popular', accent: 'Donghua', tag: 'POPULER'),
      const ProfilePage(),
    ];
    return Scaffold(
      extendBody: true,
      body: Stack(children: [
        NotificationListener<ScrollNotification>(
          onNotification: (n) {
            if (n.depth == 0) {
              final s = n.metrics.pixels > 60;
              if (s != scrolled) setState(() => scrolled = s);
            }
            return false;
          },
          child: IndexedStack(index: i, children: pages),
        ),
        Positioned(top: 0, left: 0, right: 0, child: AppHeader(scrolled: scrolled, onSearch: (q) => Navigator.push(context, MaterialPageRoute(builder: (_) => SearchPage(query: q))))),
        Positioned(bottom: 0, left: 0, right: 0, child: BottomNav(index: i, onTap: (v) => setState(() { i = v; scrolled = false; }))),
      ]),
    );
  }
}
