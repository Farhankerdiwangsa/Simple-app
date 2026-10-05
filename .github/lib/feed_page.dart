import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'app_header.dart';
import 'detail_page.dart';
import 'hero_slider.dart';
import 'theme.dart';

class FeedPage extends StatefulWidget {
  final String endpoint, title, accent, tag;
  const FeedPage({super.key, required this.endpoint, required this.title, required this.accent, required this.tag});
  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with AutomaticKeepAliveClientMixin {
  final items = <Donghua>[];
  List<Donghua> hero = [];
  final sc = ScrollController();
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
        if (hero.isEmpty) hero = ([...r]..shuffle(Random())).take(5).toList(); // banner random dari API
        page++;
      }
    } catch (e) {
      error = '$e';
    }
    if (mounted) setState(() => loading = false);
  }

  void open(Donghua d) => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(d: d)));

  Widget img(String url) => CachedNetworkImage(
        imageUrl: url, httpHeaders: kImgHeaders, fit: BoxFit.cover,
        placeholder: (_, __) => Container(color: kCard),
        errorWidget: (_, __, ___) => Container(color: kCard, child: const Icon(Icons.broken_image, color: Colors.white24)),
      );

  Widget sectionTitle() => Padding(
        padding: const EdgeInsets.fromLTRB(2, 28, 2, 16),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text.rich(TextSpan(children: [
            TextSpan(text: '${widget.title} ', style: const TextStyle(color: Colors.white)),
            TextSpan(text: widget.accent, style: const TextStyle(color: kGreen)),
          ]), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(color: op(kDark, .2), borderRadius: BorderRadius.circular(20), border: Border.all(color: op(kGreen, .3))),
            child: Text(widget.tag, style: const TextStyle(color: kGreen, fontWeight: FontWeight.w700, letterSpacing: 1.2, fontSize: 10)),
          ),
        ]),
      );

  Widget card(Donghua d) => GestureDetector(
        onTap: () => open(d),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: kCard, border: Border.all(color: op(Colors.white, .05))),
          clipBehavior: Clip.antiAlias,
          child: Stack(fit: StackFit.expand, children: [
            img(d.poster),
            DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, op(kBg, .95)], stops: const [.5, 1]))),
            Positioned(
              left: 10, top: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: op(kBg, .8), borderRadius: BorderRadius.circular(8), border: Border.all(color: op(Colors.white, .1))),
                child: Text(d.type.toUpperCase(), style: const TextStyle(color: kGreen, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
              ),
            ),
            Positioned(left: 12, right: 12, bottom: 12, child: Text(d.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      color: kGreen,
      edgeOffset: headerHeight(context),
      onRefresh: () async {
        items.clear(); hero = []; page = 1; end = false;
        await load();
      },
      child: CustomScrollView(
        controller: sc,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16, headerHeight(context) + 8, 16, 0),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 448),
                  child: Column(children: [
                    SizedBox(height: 440, child: HeroSlider(items: hero, onTap: open)),
                    sectionTitle(),
                  ]),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((_, i) => card(items[i]), childCount: items.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .7),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 150),
              child: Center(
                child: error != null
                    ? Column(children: [
                        Text('Gagal memuat:\n$error', textAlign: TextAlign.center, style: TextStyle(color: Colors.red.shade300, fontSize: 12)),
                        TextButton(onPressed: load, child: const Text('Coba lagi', style: TextStyle(color: kGreen))),
                      ])
                    : loading
                        ? const CircularProgressIndicator(color: kGreen)
                        : end ? const Text('Sudah habis', style: TextStyle(color: Colors.white38)) : const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
