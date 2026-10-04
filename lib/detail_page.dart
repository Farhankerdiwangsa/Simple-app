import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'main.dart';

/// Halaman detail: sementara best-effort (poster + judul + raw field teks).
/// TODO: rapikan setelah response /detail/:slug dikonfirmasi.
class DetailPage extends StatelessWidget {
  final Donghua d;
  const DetailPage({super.key, required this.d});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kBg, title: Text(d.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: FutureBuilder<Map<String, dynamic>>(
        future: Api.detail(d.slug),
        builder: (c, s) {
          return ListView(padding: const EdgeInsets.all(16), children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(aspectRatio: .75, child: CachedNetworkImage(imageUrl: d.poster, fit: BoxFit.cover)),
            ),
            const SizedBox(height: 16),
            Text(d.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('${d.type} • ${d.status} • ${d.sub}', style: const TextStyle(color: kGreen)),
            const SizedBox(height: 16),
            if (s.connectionState != ConnectionState.done)
              const Center(child: CircularProgressIndicator(color: kGreen))
            else if (s.hasError)
              Text('Gagal memuat detail: ${s.error}', style: TextStyle(color: Colors.red.shade300))
            else
              ..._fields(s.data!),
          ]);
        },
      ),
    );
  }

  List<Widget> _fields(Map<String, dynamic> m) {
    final src = m.values.firstWhere((v) => v is Map, orElse: () => m) as Map;
    return src.entries
        .where((e) => e.value is String && (e.value as String).isNotEmpty && !'${e.value}'.startsWith('http'))
        .map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text.rich(TextSpan(children: [
                TextSpan(text: '${e.key}: ', style: const TextStyle(color: kGreen, fontWeight: FontWeight.w600)),
                TextSpan(text: '${e.value}'),
              ])),
            ))
        .toList();
  }
}
