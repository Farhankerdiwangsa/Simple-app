import 'dart:async';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'theme.dart';

/// Port dari HeroSlider.svelte: auto-slide 5s, transisi reveal acak (kiri/atas/kanan/tengah)
class HeroSlider extends StatefulWidget {
  final List<Donghua> items;
  final ValueChanged<Donghua> onTap;
  const HeroSlider({super.key, required this.items, required this.onTap});
  @override
  State<HeroSlider> createState() => _HeroSliderState();
}

class _HeroSliderState extends State<HeroSlider> with SingleTickerProviderStateMixin {
  late final AnimationController c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
  int cur = 0, prev = -1, kind = 0;
  Timer? t;
  final rnd = Random();

  @override
  void initState() {
    super.initState();
    c.value = 1;
    t = Timer.periodic(const Duration(seconds: 5), (_) {
      if (widget.items.length < 2 || !mounted) return;
      setState(() {
        prev = cur;
        cur = (cur + 1) % widget.items.length;
        kind = rnd.nextInt(4);
      });
      c.forward(from: 0);
    });
  }

  @override
  void dispose() {
    t?.cancel();
    c.dispose();
    super.dispose();
  }

  Widget slide(Donghua d, double content) {
    final cv = Curves.easeOutQuart.transform(content);
    return GestureDetector(
      onTap: () => widget.onTap(d),
      child: Stack(fit: StackFit.expand, children: [
        CachedNetworkImage(imageUrl: d.poster, httpHeaders: kImgHeaders, fit: BoxFit.cover, color: const Color(0x73000000), colorBlendMode: BlendMode.darken,
            placeholder: (_, __) => Container(color: kCard), errorWidget: (_, __, ___) => Container(color: kCard)),
        DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [kBg, op(kBg, .4), Colors.transparent]))),
        Positioned(
          left: 24, right: 24, bottom: 24,
          child: Opacity(
            opacity: cv,
            child: Transform.translate(
              offset: Offset(0, 40 * (1 - cv)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: op(kDark, .2), borderRadius: BorderRadius.circular(20), border: Border.all(color: op(kGreen, .3))),
                  child: const Text('Recommend', style: TextStyle(color: kGreen, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1)),
                ),
                const SizedBox(height: 12),
                Text(d.title, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, height: 1.2, color: Colors.white)),
                const SizedBox(height: 8),
                Text([d.type, d.status, d.sub].where((e) => e.isNotEmpty).join(' • '), style: const TextStyle(fontSize: 12, color: Color(0xFFD1D5DB), fontWeight: FontWeight.w500, letterSpacing: .5)),
              ]),
            ),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: op(kDark, .2)), color: kCard,
          boxShadow: const [BoxShadow(color: Color(0xB3000000), blurRadius: 40, offset: Offset(0, 12))]),
      clipBehavior: Clip.antiAlias,
      child: widget.items.isEmpty
          ? const Center(child: SizedBox(width: 32, height: 32, child: CircularProgressIndicator(strokeWidth: 2, color: kGreen)))
          : AnimatedBuilder(
              animation: c,
              builder: (_, __) {
                final p = const Cubic(.76, 0, .24, 1).transform(c.value);
                final content = ((c.value - .43) / .57).clamp(0.0, 1.0);
                final prevOpacity = 1 - ((c.value * 1400 - 300) / 800).clamp(0.0, 1.0);
                return Stack(fit: StackFit.expand, children: [
                  if (prev >= 0 && c.value < 1) Opacity(opacity: prevOpacity, child: slide(widget.items[prev], 1)),
                  ClipRect(clipper: _Reveal(p, kind), child: slide(widget.items[cur], content)),
                ]);
              },
            ),
    );
  }
}

class _Reveal extends CustomClipper<Rect> {
  final double p;
  final int kind;
  _Reveal(this.p, this.kind);
  @override
  Rect getClip(Size s) {
    switch (kind) {
      case 0: return Rect.fromLTWH(0, 0, s.width * p, s.height);
      case 1: return Rect.fromLTWH(0, 0, s.width, s.height * p);
      case 2: return Rect.fromLTWH(s.width * (1 - p), 0, s.width * p, s.height);
      default: return Rect.fromCenter(center: s.center(Offset.zero), width: s.width * p, height: s.height * p);
    }
  }
  @override
  bool shouldReclip(_Reveal o) => o.p != p || o.kind != kind;
}
