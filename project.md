# DongHuain - project.md (BACA INI DULU, jangan baca semua file)

Flutter app donghua (UI dark + aksen hijau). Wajib update file ini setiap ada perubahan.

## Struktur
- lib/main.dart        : tema, Shell (IndexedStack 4 tab + bottom nav custom, tombol tengah SCHED)
- lib/api.dart         : class Donghua, Api.list(endpoint,page), Api.detail(slug). Parse generik (ambil List pertama dari JSON)
- lib/feed_page.dart   : FeedPage(endpoint) dipakai Home/Latest/Populer. Header, banner random, grid 2 kolom, infinite scroll
- lib/detail_page.dart : halaman detail (fetch /detail/:slug) - masih persiapan/best-effort
- lib/dummy_pages.dart : SchedulePage & ProfilePage (DUMMY, nanti Firebase)
- .github/workflows/build.yml : build APK (flutter create --platforms=android lalu build apk)

## API (base https://www.sankavollerei.web.id/anime/donghua)
- Home    : /completed/{page}  (key: completed_donghua)
- Latest  : /ongoing/{page}
- Populer : /latest/{page}
- Detail  : /detail/{slug}
Item: title, slug, poster, status, type, sub, href, anichinUrl
Banner = item random dari hasil fetch tiap tab.

## Status
- [x] UI Home/Latest/Populer + infinite scroll
- [x] Detail page dasar
- [ ] Detail page final (tunggu contoh response)
- [ ] Firebase (Profile) - tambah firebase_core/auth + google-services.json
- [ ] Schedule (dummy)

## Catatan
- Firebase BELUM ditambahkan supaya build CI tidak gagal tanpa google-services.json.
- Tab "Hot" diganti "Populer".
