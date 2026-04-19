import 'package:flutter/material.dart';
import '../main.dart';
import 'detail.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<String> aracIsimleri = const [
    "Şişme Bot (BSE MARINE)",
    "Fiber Tekne",
    "Yelkenli Tekne",
    "Jet Ski",
    "Kano",
    "Yat",
  ];

  final List<String> aracResimleri = const [
    "assets/1.png",
    "assets/2.png",
    "assets/3.png",
    "assets/4.png",
    "assets/5.png",
    "assets/6.png",
  ];

  final List<String> aracEkipmanlari = const [
    "Yüksek Basınçlı Pompa, Alüminyum Kürek, Can Yeleği, Tamir Kiti",
    "Can Simidi, Dıştan Takma Motor, Yangın Tüpü, Bağlama Halatları",
    "Navigasyon Cihazı, Yelken Tamir Takımı, Telsiz, Can Salı",
    "Can Yeleği (Zorunlu), Güvenlik Anahtarı, Sintine Pompası",
    "Çift Kürek, Su Geçirmez Çanta, Can Yeleği, Kask",
    "Radar Sistemi, Navigasyon Cihazı, Can Salı, Yangın Tüpü, VHF Telsiz",
  ];

  final List<String> hizmetNoktalari = const [
    "Derin Mavi Bot Tamir (Sanayi Sitesi) - Bot yama ve valf değişimi",
    "Kaptan Denizcilik (Merkez Marina) - Motor bakımı ve fiber tamiri",
    "Yelken Dünyası (Kuzey Barınağı) - Arma ve yelken bakımı",
    "Hızlı Servis (Güney Koyu) - Jet Ski motor ve jet pompa bakımı",
    "Doğa Spor Merkezi (Nehir Kenarı) - Kano bakımı ve kürek değişimi",
    "Lüks Marina Servisi (Merkez Liman) - Yat bakımı, boya ve teknik servis",
  ];

  // Her kart için ikon
  final List<IconData> aracIkonlari = const [
    Icons.directions_boat_rounded,
    Icons.directions_boat_filled_rounded,
    Icons.sailing_rounded,
    Icons.electric_bolt_rounded,
    Icons.kayaking_rounded,
    Icons.anchor_rounded,
  ];

  // Her kart için vurgu rengi
  final List<Color> aracRenkleri = const [
    AppColors.accent,
    AppColors.safe,
    AppColors.warning,
    AppColors.danger,
    const Color(0xFF9B5DE5), // mor — Kano
    const Color(0xFFFFD166), // altın — Yat
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Her liste öğesi için staggered animasyon hesaplar
  Animation<double> _itemFade(int index) {
    final start = (index * 0.15).clamp(0.0, 0.7);
    final end = (start + 0.40).clamp(0.0, 1.0);
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );
  }

  Animation<Offset> _itemSlide(int index) {
    final start = (index * 0.15).clamp(0.0, 0.7);
    final end = (start + 0.40).clamp(0.0, 1.0);
    return Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.accent,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.anchor, color: AppColors.accent, size: 20),
            SizedBox(width: 8),
            Text("Deniz Araçları Rehberi"),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
        itemCount: aracIsimleri.length,
        itemBuilder: (context, index) {
          final color = aracRenkleri[index];
          return FadeTransition(
            opacity: _itemFade(index),
            child: SlideTransition(
              position: _itemSlide(index),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildListCard(context, index, color),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListCard(BuildContext context, int index, Color color) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => DetailPage(
              isim: aracIsimleri[index],
              resimUrl: aracResimleri[index],
              ekipman: aracEkipmanlari[index],
              hizmet: hizmetNoktalari[index],
            ),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.10),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // Sol resim + hero animasyonu
              Hero(
                tag: aracResimleri[index],
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(18),
                  ),
                  child: SizedBox(
                    width: 130,
                    height: 120,
                    child: Image.asset(
                      aracResimleri[index],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.surfaceLight,
                        child: Icon(
                          aracIkonlari[index],
                          color: color,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Sağ metin alanı
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Renkli ikon + başlık
                      Row(
                        children: [
                          Icon(aracIkonlari[index], color: color, size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              aracIsimleri[index],
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Ekipman ve servis noktaları için incele",
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: color.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Text(
                          "Detayları Gör →",
                          style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
