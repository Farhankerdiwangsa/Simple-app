import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'detail_page.dart';
import 'main.dart';

class FeedPage extends StatefulWidget {
  final String endpoint, title, accent, tag;
  const FeedPage({super.key, required this.endpoint, required this.title, required this.accent, required this.tag});
  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with AutomaticKeepAliveClientMixin {
  final items = <Donghua>[];
  final sc = ScrollController();
  Donghua? banner;
  int page = 1;
  bool loading = false, end = false;
  String? error;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    sc.addListener(() {
      if (sc.position.pixels > sc.position.maxScrollExtent - 600) load();
    });
    load();
  }

  @override
  void dispose() {
    sc.dispose();
    super.dispose();
  }

  Future<void> load() async {
    if (loading || end) return;
    setState(() { loading = true; error = null; });
    try {
      final r = await Api.list(widget.endpoint, page);
      if (r.isEmpty) {
        end = true;
      } else {
        items.addAll(r);
        banner ??= r[Random().nextInt(r.length)];
        page++;
      }
    } catch (e) {
      error = '$e';
    }
    if (mounted) setState(() => loading = false);
  }

  void open(Donghua d) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(d: d)));

  Widget img(String url) => CachedNetworkImage(
        imageUrl: url, fit: BoxFit.cover,
        placeholder: (_, __) => Container(color: kCard),
        errorWidget: (_, __, ___) => Container(color: kCard, child: const Icon(Icons.broken_image, color: Colors.white24)),
      );

  Widget badge(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(color: const Color(0xCC1A1A1A), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white12)),
        child: Text(t.toUpperCase(), style: const TextStyle(color: kGreen, fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 1)),
      );

  Widget header() => Container(
        height: 74,
        margin: const EdgeInsets.fromLTRB(0, 8, 0, 16),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(color: const Color(0xFF0B0B0B), borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white10)),
        child: Row(children: [
          const SizedBox(width: 48),
          const Expanded(
            child: Center(
              child: Text.rich(TextSpan(children: [
                TextSpan(text: 'Dong', style: TextStyle(color: Colors.white)),
                TextSpan(text: 'Huain', style: TextStyle(color: kGreen)),
              ]), style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
            ),
          ),
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white10)),
            child: const Icon(Icons.search, color: Colors.white70),
          ),
        ]),
      );

  Widget bannerW() {
    final b = banner;
    return GestureDetector(
      onTap: b == null ? null : () => open(b),
      child: Container(
        height: 622,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(26), border: Border.all(color: Colors.white10), color: kCard),
        clipBehavior: Clip.antiAlias,
        child: b == null
            ? const Center(child: CircularProgressIndicator(color: kGreen))
            : Stack(fit: StackFit.expand, children: [
                img(b.poster),
                const DecoratedBox(
                  decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0xDD000000)], stops: [.45, 1])),
                ),
                Positioned(
                  left: 22, right: 22, bottom: 30,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(color: const Color(0xAA0E3D2A), borderRadius: BorderRadius.circular(20), border: Border.all(color: kGreen.withOpacity(.5))),
                      child: const Text('Recommend', style: TextStyle(color: kGreen, fontWeight: FontWeight.w700, letterSpacing: 1)),
                    ),
                    const SizedBox(height: 16),
                    Text(b.title, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w700, height: 1.15)),
                  ]),
                ),
              ]),
      ),
    );
  }

  Widget sectionTitle() => Padding(
        padding: const EdgeInsets.fromLTRB(2, 34, 2, 22),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text.rich(TextSpan(children: [
            TextSpan(text: '${widget.title} ', style: const TextStyle(color: Colors.white)),
            TextSpan(text: widget.accent, style: const TextStyle(color: kGreen)),
          ]), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w500)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
            decoration: BoxDecoration(color: const Color(0xFF0B2A1D), borderRadius: BorderRadius.circular(20), border: Border.all(color: kGreen.withOpacity(.4))),
            child: Text(widget.tag, style: const TextStyle(color: kGreen, fontWeight: FontWeight.w700, letterSpacing: 1.2, fontSize: 13)),
          ),
        ]),
      );

  Widget card(Donghua d) => GestureDetector(
        onTap: () => open(d),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), color: kCard),
          clipBehavior: Clip.antiAlias,
          child: Stack(fit: StackFit.expand, children: [
            img(d.poster),
            const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0xEE000000)], stops: [.55, 1]))),
            Positioned(left: 14, top: 14, child: badge(d.type)),
            Positioned(left: 14, right: 14, bottom: 14, child: Text(d.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15))),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        color: kGreen,
        onRefresh: () async {
          items.clear(); banner = null; page = 1; end = false;
          await load();
        },
        child: CustomScrollView(
          controller: sc,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              sliver: SliverList(delegate: SliverChildListDelegate([header(), bannerW(), sectionTitle()])),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((_, i) => card(items[i]), childCount: items.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: .72),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 140),
                child: Center(
                  child: error != null
                      ? TextButton(onPressed: load, child: Text('Gagal memuat, ketuk untuk ulang', style: TextStyle(color: Colors.red.shade300)))
                      : loading
                          ? const CircularProgressIndicator(color: kGreen)
                          : end ? const Text('Sudah habis', style: TextStyle(color: Colors.white38)) : const SizedBox(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
