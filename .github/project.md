# DongHuain - project.md (BACA INI DULU, jangan baca semua file)

Flutter app donghua (UI dark + aksen hijau). Wajib update file ini setiap ada perubahan.

## Struktur
- lib/theme.dart       : warna (kBg #050505, kGreen #12c471, kDark #0B7A45)
- lib/app_header.dart  : port Header.svelte (logo, search expand, back, judul saat scroll)
- lib/bottom_nav.dart  : port BottomNav.svelte (zigzag hijau, tombol SCHED bulat)
- lib/hero_slider.dart : port HeroSlider.svelte (auto 5s, reveal acak, banner random)
- lib/main.dart        : Shell (IndexedStack 5 halaman + header + nav, deteksi scroll)
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
- Release APK WAJIB permission INTERNET -> sudah ditambahkan otomatis di workflow (sed ke AndroidManifest).
- Referensi desain asli = file Svelte user (Header/BottomNav/HeroSlider). Samakan dengan itu.
- Search page masih placeholder (endpoint belum ada).
- Firebase BELUM ditambahkan supaya build CI tidak gagal tanpa google-services.json.
- Tab "Hot" diganti "Populer".
