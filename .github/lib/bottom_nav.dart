import 'package:flutter/material.dart';
import 'theme.dart';

/// Port dari BottomNav.svelte. Index: 0 home, 1 latest, 2 sched, 3 populer, 4 profile
class BottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const BottomNav({super.key, required this.index, required this.onTap});

  Widget item(int i, IconData ic, String label) {
    final on = index == i;
    final c = on ? kGreen : const Color(0xFF9CA3AF);
    return Expanded(
      child: InkWell(
        onTap: () => onTap(i),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(ic, size: 22, color: c, shadows: on ? [Shadow(color: op(kGreen, .5), blurRadius: 6)] : null),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 9, letterSpacing: .9, color: c, fontWeight: on ? FontWeight.w600 : FontWeight.w500)),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 24 + bottom),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 448),
          child: SizedBox(
            height: 68,
            child: Stack(clipBehavior: Clip.none, children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: op(kBg, .95), borderRadius: BorderRadius.circular(16),
                    border: Border(top: BorderSide(color: op(kDark, .2)), left: BorderSide(color: op(Colors.white, .05)), right: BorderSide(color: op(Colors.white, .05))),
                    boxShadow: const [BoxShadow(color: Color(0xE6000000), blurRadius: 35, offset: Offset(0, -12))],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CustomPaint(painter: _ZigPainter(), size: Size.infinite),
                ),
              ),
              Row(children: [
                item(0, Icons.home_outlined, 'HOME'),
                item(1, Icons.access_time, 'LATEST'),
                Expanded(
                  child: Stack(clipBehavior: Clip.none, alignment: Alignment.topCenter, children: [
                    Positioned(
                      top: -28,
                      child: GestureDetector(
                        onTap: () => onTap(2),
                        child: Column(children: [
                          Container(
                            width: 56, height: 56, padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(color: kBg, shape: BoxShape.circle, border: Border.all(color: op(kDark, .2)),
                                boxShadow: const [BoxShadow(color: Color(0xB3000000), blurRadius: 20, offset: Offset(0, -6))]),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [kDark, kGreen]),
                                border: Border.all(color: op(const Color(0xFF20E086), .5)),
                                boxShadow: [BoxShadow(color: op(kGreen, .4), blurRadius: 12)],
                              ),
                              child: const Icon(Icons.calendar_today_outlined, size: 20, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text('SCHED', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: .9, color: kGreen)),
                        ]),
                      ),
                    ),
                  ]),
                ),
                item(3, Icons.local_fire_department_outlined, 'POPULER'),
                item(4, Icons.person_outline, 'PROFILE'),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}

class _ZigPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final sx = s.width / 400;
    Offset p(double x, double y) => Offset(x * sx, y);
    final main = Path()..moveTo(0, 0);
    for (final e in [[35, 0], [42, 5], [48, 0], [160, 0], [165, 6], [172, 0], [180, 0], [220, 0], [228, 0], [235, 5], [242, 0], [360, 0], [365, 4], [370, 0], [400, 0]]) {
      main.lineTo(p(e[0] * 1.0, e[1] * 1.0).dx, e[1] * 1.0);
    }
    canvas.drawPath(main, Paint()..style = PaintingStyle.stroke..strokeWidth = 1.2..color = op(kGreen, .8));
    final sub = Paint()..style = PaintingStyle.stroke..strokeWidth = .8..color = op(kDark, .5);
    for (final e in [[42, 5, 40, 11], [165, 6, 168, 12], [235, 5, 232, 10], [365, 4, 368, 9]]) {
      canvas.drawLine(p(e[0] * 1.0, e[1] * 1.0), p(e[2] * 1.0, e[3] * 1.0), sub);
    }
    canvas.drawRect(Rect.fromLTWH(0, 0, s.width, 32), Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [op(kDark, .05), Colors.transparent]).createShader(Rect.fromLTWH(0, 0, s.width, 32)));
  }

  @override
  bool shouldRepaint(_) => false;
}
