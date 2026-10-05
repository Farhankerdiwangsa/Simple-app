import 'package:flutter/material.dart';
import 'theme.dart';

/// Port dari Header.svelte
class AppHeader extends StatefulWidget {
  final String title;
  final bool showTitle, scrolled, showBack;
  final ValueChanged<String>? onSearch;
  const AppHeader({super.key, this.title = '', this.showTitle = false, this.scrolled = false, this.showBack = false, this.onSearch});
  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  bool searching = false;
  final ctl = TextEditingController();
  final focus = FocusNode();

  void open() {
    setState(() => searching = true);
    Future.delayed(const Duration(milliseconds: 180), () => focus.requestFocus());
  }

  void close() {
    ctl.clear();
    focus.unfocus();
    setState(() => searching = false);
  }

  void submit(String v) {
    if (v.trim().isEmpty) return;
    widget.onSearch?.call(v.trim());
    close();
  }

  Widget sq({required Widget child, required VoidCallback onTap, Color? bg, Color? border}) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6), border: border == null ? null : Border.all(color: border)),
          child: child,
        ),
      );

  Widget normal() {
    final showT = widget.showTitle && widget.scrolled;
    return Padding(
      key: const ValueKey('n'),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(children: [
        widget.showBack
            ? sq(onTap: () => Navigator.maybePop(context), child: const Icon(Icons.chevron_left, color: Colors.white54, size: 22))
            : const SizedBox(width: 36),
        Expanded(
          child: Center(
            child: showT
                ? Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFE5E7EB)))
                : const Text.rich(TextSpan(children: [
                    TextSpan(text: 'Dong', style: TextStyle(color: Colors.white)),
                    TextSpan(text: 'Huain', style: TextStyle(color: kGreen)),
                  ]), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: .4)),
          ),
        ),
        sq(onTap: open, bg: op(Colors.white, .05), border: op(Colors.white, .05), child: const Icon(Icons.search, size: 16, color: Color(0xFFD1D5DB))),
      ]),
    );
  }

  Widget searchRow() => Padding(
        key: const ValueKey('s'),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: ctl, focusNode: focus, onSubmitted: submit,
              style: const TextStyle(fontSize: 12, color: Colors.white),
              decoration: InputDecoration(
                isDense: true, hintText: 'Search donghua...', hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.fromLTRB(16, 11, 40, 11),
                suffixIcon: const Icon(Icons.search, size: 16, color: kGreen),
                filled: true, fillColor: op(kBg, .95),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: op(kDark, .4))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kGreen)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          sq(onTap: close, bg: op(Colors.red, .1), border: op(Colors.red, .2), child: Icon(Icons.close, size: 16, color: Colors.red.shade300)),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.fromLTRB(16, top + 16, 16, 12),
      decoration: BoxDecoration(
        color: widget.scrolled ? op(kBg, .92) : null,
        gradient: widget.scrolled ? null : LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [op(Colors.black, .8), Colors.transparent]),
        border: Border(bottom: BorderSide(color: widget.scrolled ? op(Colors.white, .05) : Colors.transparent)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 448),
          child: Container(
            height: 44,
            decoration: BoxDecoration(color: op(Colors.white, .02), borderRadius: BorderRadius.circular(12), border: Border.all(color: op(Colors.white, .05))),
            child: AnimatedSwitcher(duration: const Duration(milliseconds: 200), child: searching ? searchRow() : normal()),
          ),
        ),
      ),
    );
  }
}

double headerHeight(BuildContext c) => MediaQuery.of(c).padding.top + 16 + 44 + 12;
