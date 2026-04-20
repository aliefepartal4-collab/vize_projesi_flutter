import 'package:flutter/material.dart';
import '../main.dart';

class DetailPage extends StatefulWidget {
  final String isim;
  final String resimUrl;
  final String ekipman;
  final String hizmet;

  const DetailPage({
    Key? key,
    required this.isim,
    required this.resimUrl,
    required this.ekipman,
    required this.hizmet,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _contentFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Hero animasyonu bitmeden başlatma
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── SliverAppBar — Resim alanı ──────────────────────────────────────
          SliverAppBar(
            expandedHeight: 310,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.background,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.fadeTitle,
              ],
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: Text(
                widget.isim,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  shadows: [
                    Shadow(blurRadius: 8, color: Colors.black),
                    Shadow(blurRadius: 20, color: Colors.black),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Hero geçiş animasyonu
                  Hero(
                    tag: widget.resimUrl,
                    child: Image.asset(
                      widget.resimUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.surfaceLight,
                        child: const Icon(
                          Icons.directions_boat_rounded,
                          color: AppColors.accent,
                          size: 80,
                        ),
                      ),
                    ),
                  ),
                  // Altta koyu gradient — başlık okunurluğu için
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black87,
                        ],
                        stops: [0.0, 0.55, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── İçerik alanı — fade + slide up ───────────────────────────────────
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _contentFade,
              child: SlideTransition(
                position: _contentSlide,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Puanlama özeti
                      _buildRatingRow(),

                      Divider(color: AppColors.divider, height: 36),

                      // Ekipmanlar
                      _sectionTitle("⚓  Gerekli Ekipmanlar", AppColors.accent),
                      const SizedBox(height: 10),
                      _buildInfoBox(widget.ekipman, AppColors.accent),

                      const SizedBox(height: 24),

                      // Hizmet noktası
                      _sectionTitle(
                        "🛠️  Hizmet & Tamir Noktası",
                        AppColors.warning,
                      ),
                      const SizedBox(height: 10),
                      _buildInfoBox(widget.hizmet, AppColors.warning),

                      const SizedBox(height: 32),

                      // Yorumlar
                      _sectionTitle(
                        "💬  Kullanıcı Yorumları",
                        AppColors.textPrimary,
                      ),
                      const SizedBox(height: 16),

                      _buildComment(
                        "Kaptan Mazhar",
                        "Malzeme kalitesi beklediğimden çok daha iyi çıktı.",
                        5,
                      ),
                      _buildComment(
                        "Denizci123",
                        "Ekipman listesi eksiksiz, çok işime yaradı.",
                        4,
                      ),
                      _buildComment(
                        "Reis Bey",
                        "Servis noktası ilgiliydi, hızlıca hallettiler.",
                        5,
                      ),

                      const SizedBox(height: 36),

                      // Geri dön butonu
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          label: const Text("Listeye Geri Dön"),
                        ),
                      ),

                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Yardımcı Widget'lar ───────────────────────────────────────────────────────

  Widget _buildRatingRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: AppColors.warning, size: 26),
          const SizedBox(width: 6),
          const Text(
            "4.9",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "150+ Değerlendirme",
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.safe.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.safe.withValues(alpha: 0.4)),
            ),
            child: const Text(
              "Tavsiye Edilir",
              style: TextStyle(
                color: AppColors.safe,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color == AppColors.textPrimary
                ? AppColors.textPrimary
                : color,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox(String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          height: 1.6,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildComment(String user, String text, int star) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.accentDark.withValues(alpha: 0.3),
                radius: 16,
                child: Text(
                  user[0],
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                user,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    Icons.star_rounded,
                    size: 14,
                    color: i < star ? AppColors.warning : AppColors.divider,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
