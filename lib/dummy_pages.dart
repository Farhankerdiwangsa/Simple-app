import 'package:flutter/material.dart';
import 'main.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});
  @override
  Widget build(BuildContext context) {
    const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    return SafeArea(
      child: ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 140), children: [
        const Text('Schedule', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        for (final d in days)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white10)),
            child: Row(children: [
              Text(d, style: const TextStyle(color: kGreen, fontWeight: FontWeight.w700, fontSize: 16)),
              const Spacer(),
              const Text('Dummy - belum ada data', style: TextStyle(color: Colors.white38)),
            ]),
          ),
      ]),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const CircleAvatar(radius: 48, backgroundColor: kCard, child: Icon(Icons.person, size: 48, color: kGreen)),
            const SizedBox(height: 16),
            const Text('Guest', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            const Text('Login Firebase menyusul', style: TextStyle(color: Colors.white38)),
            const SizedBox(height: 20),
            FilledButton(onPressed: null, style: FilledButton.styleFrom(backgroundColor: kGreen), child: const Text('Login (dummy)')),
          ]),
        ),
      );
}
