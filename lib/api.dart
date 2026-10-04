import 'dart:convert';
import 'package:http/http.dart' as http;

const kBase = 'https://www.sankavollerei.web.id/anime/donghua';

class Donghua {
  final String title, slug, poster, type, status, sub;
  Donghua(this.title, this.slug, this.poster, this.type, this.status, this.sub);
  factory Donghua.fromJson(Map<String, dynamic> j) => Donghua(
        '${j['title'] ?? ''}',
        '${j['slug'] ?? ''}',
        '${j['poster'] ?? ''}',
        '${j['type'] ?? 'Donghua'}',
        '${j['status'] ?? ''}',
        '${j['sub'] ?? ''}',
      );
}

class Api {
  static Future<List<Donghua>> list(String endpoint, int page) async {
    final r = await http.get(Uri.parse('$kBase/$endpoint/$page'));
    if (r.statusCode != 200) throw Exception('HTTP ${r.statusCode}');
    final data = jsonDecode(r.body);
    if (data is Map) {
      for (final v in data.values) {
        if (v is List) {
          return v
              .whereType<Map>()
              .map((e) => Donghua.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }
      }
    }
    return [];
  }

  static Future<Map<String, dynamic>> detail(String slug) async {
    final r = await http.get(Uri.parse('$kBase/detail/$slug'));
    if (r.statusCode != 200) throw Exception('HTTP ${r.statusCode}');
    return Map<String, dynamic>.from(jsonDecode(r.body));
  }
}
