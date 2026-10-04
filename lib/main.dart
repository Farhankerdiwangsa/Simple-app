import 'package:flutter/material.dart';
import 'feed_page.dart';
import 'dummy_pages.dart';

const kBg = Color(0xFF050505);
const kGreen = Color(0xFF1DB87A);
const kCard = Color(0xFF111111);

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'DongHuain',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: kBg,
          colorScheme: const ColorScheme.dark(primary: kGreen),
        ),
        home: const Shell(),
      );
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int i = 0; // 0 home,1 latest,2 sched,3 populer,4 profile

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
        IndexedStack(index: i, children: pages),
        Positioned(left: 16, right: 16, bottom: 14, child: _nav()),
      ]),
    );
  }

  Widget _item(int idx, IconData ic, String label) {
    final on = i == idx;
    final c = on ? kGreen : Colors.white54;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => i = idx),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(on ? ic : ic, color: c, size: 28),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1)),
        ]),
      ),
    );
  }

  Widget _nav() {
    final on = i == 2;
    return SizedBox(
      height: 112,
      child: Stack(alignment: Alignment.bottomCenter, children: [
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xF2080C0A),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: kGreen.withOpacity(.35)),
          ),
          child: Row(children: [
            _item(0, Icons.home_outlined, 'HOME'),
            _item(1, Icons.schedule, 'LATEST'),
            const Expanded(child: SizedBox()),
            _item(3, Icons.local_fire_department_outlined, 'POPULER'),
            _item(4, Icons.person_outline, 'PROFILE'),
          ]),
        ),
        Positioned(
          top: 0,
          child: GestureDetector(
            onTap: () => setState(() => i = 2),
            child: Column(children: [
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [Color(0xFF22C784), Color(0xFF0E8F5A)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  border: Border.all(color: kBg, width: 5),
                  boxShadow: [BoxShadow(color: kGreen.withOpacity(.5), blurRadius: 18)],
                ),
                child: const Icon(Icons.calendar_month_outlined, size: 36, color: Colors.white),
              ),
            ]),
          ),
        ),
        Positioned(
          bottom: 10,
          child: Text('SCHED', style: TextStyle(color: on ? kGreen : kGreen, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1)),
        ),
      ]),
    );
  }
}
