import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'app_header.dart';
import 'theme.dart';

/// Detail: best-effort sampai format response /detail/:slug dikonfirmasi.
class DetailPage extends StatefulWidget {
  final Donghua d;
  const DetailPage({super.key, required this.d});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final Future<Map<String, dynamic>> f = Api.detail(widget.d.slug);
  bool scrolled = false;

  List<Widget> fields(Map<String, dynamic> m) {
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

  @override
  Widget build(BuildContext context) {
    final d = widget.d;
    return Scaffold(
      body: Stack(children: [
        NotificationListener<ScrollNotification>(
          onNotification: (n) {
            final s = n.metrics.pixels > 60;
            if (s != scrolled) setState(() => scrolled = s);
            return false;
          },
          child: FutureBuilder<Map<String, dynamic>>(
            future: f,
            builder: (c, s) => ListView(padding: EdgeInsets.fromLTRB(16, headerHeight(context) + 8, 16, 40), children: [
              ClipRRect(borderRadius: BorderRadius.circular(16), child: AspectRatio(aspectRatio: .75, child: CachedNetworkImage(imageUrl: d.poster, httpHeaders: kImgHeaders, fit: BoxFit.cover))),
              const SizedBox(height: 16),
              Text(d.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text([d.type, d.status, d.sub].where((e) => e.isNotEmpty).join(' • '), style: const TextStyle(color: kGreen)),
              const SizedBox(height: 16),
              if (s.connectionState != ConnectionState.done)
                const Center(child: CircularProgressIndicator(color: kGreen))
              else if (s.hasError)
                Text('Gagal memuat detail: ${s.error}', style: TextStyle(color: Colors.red.shade300))
              else
                ...fields(s.data!),
            ]),
          ),
        ),
        Positioned(top: 0, left: 0, right: 0, child: AppHeader(title: d.title, showTitle: true, scrolled: scrolled, showBack: true)),
      ]),
    );
  }
}
