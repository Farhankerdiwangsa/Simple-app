import 'dart:convert';
import 'package:http/http.dart' as http;

const kBase = 'https://www.sankavollerei.web.id/anime/donghua';
const kHeaders = {
  'User-Agent': 'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 Chrome/120 Mobile Safari/537.36',
  'Accept': 'application/json',
};
const kImgHeaders = {'Referer': 'https://anichin.moe/', 'User-Agent': 'Mozilla/5.0 (Linux; Android 13) Chrome/120 Mobile'};

class Donghua {
  final String title, slug, poster, type, status, sub;
  Donghua(this.title, this.slug, this.poster, this.type, this.status, this.sub);
  factory Donghua.fromJson(Map<String, dynamic> j) => Donghua(
        '${j['title'] ?? ''}', '${j['slug'] ?? ''}', '${j['poster'] ?? ''}',
        '${j['type'] ?? 'Donghua'}', '${j['status'] ?? ''}', '${j['sub'] ?? ''}');
}

List? _findList(dynamic d) {
  if (d is List && d.isNotEmpty && d.first is Map) return d;
  if (d is Map) {
    for (final v in d.values) {
      final r = _findList(v);
      if (r != null) return r;
    }
  }
  return null;
}

class Api {
  static Future<List<Donghua>> list(String endpoint, int page) async {
    final r = await http.get(Uri.parse('$kBase/$endpoint/$page'), headers: kHeaders).timeout(const Duration(seconds: 20));
    if (r.statusCode != 200) throw Exception('HTTP ${r.statusCode}');
    final l = _findList(jsonDecode(r.body));
    if (l == null) return [];
    return l.whereType<Map>().map((e) => Donghua.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  static Future<Map<String, dynamic>> detail(String slug) async {
    final r = await http.get(Uri.parse('$kBase/detail/$slug'), headers: kHeaders).timeout(const Duration(seconds: 20));
    if (r.statusCode != 200) throw Exception('HTTP ${r.statusCode}');
    return Map<String, dynamic>.from(jsonDecode(r.body));
  }
}
