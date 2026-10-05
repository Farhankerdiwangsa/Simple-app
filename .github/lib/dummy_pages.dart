import 'package:flutter/material.dart';
import 'app_header.dart';
import 'theme.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});
  @override
  Widget build(BuildContext context) {
    const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    return ListView(padding: EdgeInsets.fromLTRB(16, headerHeight(context) + 8, 16, 150), children: [
      const Text('Schedule', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
      const SizedBox(height: 16),
      for (final d in days)
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: op(Colors.white, .05))),
          child: Row(children: [
            Text(d, style: const TextStyle(color: kGreen, fontWeight: FontWeight.w700)),
            const Spacer(),
            const Text('Dummy - belum ada data', style: TextStyle(color: Colors.white38, fontSize: 12)),
          ]),
        ),
    ]);
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const CircleAvatar(radius: 44, backgroundColor: kCard, child: Icon(Icons.person, size: 44, color: kGreen)),
          const SizedBox(height: 16),
          const Text('Guest', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text('Login Firebase menyusul', style: TextStyle(color: Colors.white38)),
        ]),
      );
}

/// Placeholder: endpoint search belum diberikan.
class SearchPage extends StatelessWidget {
  final String query;
  const SearchPage({super.key, required this.query});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(children: [
          Center(child: Text('Hasil pencarian "$query"\n(API search belum diset)', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white54))),
          const Positioned(top: 0, left: 0, right: 0, child: AppHeader(showBack: true)),
        ]),
      );
}
