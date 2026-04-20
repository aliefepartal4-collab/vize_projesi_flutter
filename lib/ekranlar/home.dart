import 'package:flutter/material.dart';
import '../main.dart';
import 'list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;

  // Staggered animasyonlar
  late Animation<double> _welcomeFade;
  late Animation<Offset> _welcomeSlide;
  late Animation<double> _weatherFade;
  late Animation<Offset> _weatherSlide;
  late Animation<double> _infoFade;
  late Animation<Offset> _infoSlide;
  late Animation<double> _bottomFade;
  late Animation<Offset> _bottomSlide;

  // SOS puls animasyonu
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    // Ana giriş animasyonu — 1.8 saniye
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    // SOS puls animasyonu — sonsuz döngü
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // ── Karşılama kartı (0%–35%) ──────────────────────────────────────────────
    _welcomeFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.00, 0.35, curve: Curves.easeOut),
      ),
    );
    _welcomeSlide =
        Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.00, 0.35, curve: Curves.easeOut),
          ),
        );

    // ── Hava durumu (25%–60%) ─────────────────────────────────────────────────
    _weatherFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.25, 0.60, curve: Curves.easeOut),
      ),
    );
    _weatherSlide = Tween<Offset>(begin: const Offset(0.4, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.25, 0.60, curve: Curves.easeOut),
          ),
        );

    // ── Bölgesel bilgi kartları (50%–80%) ────────────────────────────────────
    _infoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.50, 0.80, curve: Curves.easeOut),
      ),
    );
    _infoSlide = Tween<Offset>(begin: const Offset(-0.4, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.50, 0.80, curve: Curves.easeOut),
          ),
        );

    // ── Alt buton ve reklam (70%–100%) ───────────────────────────────────────
    _bottomFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.70, 1.00, curve: Curves.easeOut),
      ),
    );
    _bottomSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.70, 1.00, curve: Curves.easeOut),
          ),
        );

    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // ── SOS Diyalogu ─────────────────────────────────────────────────────────────
  void _showSOSDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: AppColors.danger,
                  size: 42,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "ACİL DURUM (SOS)",
                style: TextStyle(
                  color: AppColors.danger,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Acil durumda aşağıdaki kanalları kullanın:",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              _sosRow(
                Icons.phone_rounded,
                "Sahil Güvenlik",
                "158",
                AppColors.safe,
              ),
              const SizedBox(height: 12),
              _sosRow(
                Icons.radio_rounded,
                "Telsiz Kanalı",
                "Kanal 16",
                AppColors.accent,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    backgroundColor: AppColors.surfaceLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("KAPAT"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sosRow(IconData icon, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.anchor, color: AppColors.accent, size: 22),
            SizedBox(width: 8),
            Text("Marine Rehber"),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),

      // ── Pulsing SOS FAB ─────────────────────────────────────────────────────
      floatingActionButton: ScaleTransition(
        scale: _pulse,
        child: FloatingActionButton(
          backgroundColor: AppColors.danger,
          elevation: 8,
          onPressed: () => _showSOSDialog(context),
          child: const Icon(Icons.sos_rounded, color: Colors.white, size: 32),
        ),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Karşılama Kartı — fade + slide yukarıdan
              FadeTransition(
                opacity: _welcomeFade,
                child: SlideTransition(
                  position: _welcomeSlide,
                  child: _buildWelcomeCard(),
                ),
              ),

              const SizedBox(height: 32),

              // 2. Hava Durumu Başlığı + Kartlar — sağdan gelir
              FadeTransition(
                opacity: _weatherFade,
                child: SlideTransition(
                  position: _weatherSlide,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle("🌤️  Deniz Durumu Raporu"),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sol: hava durumu kartları (yatay kaydırılabilir)
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: Row(
                                children: [
                                  _buildWeatherCard(
                                    "Akdeniz",
                                    "Güneşli",
                                    28,
                                    5,
                                    "Uygun",
                                    AppColors.safe,
                                  ),
                                  _buildWeatherCard(
                                    "Ege",
                                    "Rüzgarlı",
                                    24,
                                    15,
                                    "Dikkat",
                                    AppColors.warning,
                                  ),
                                  _buildWeatherCard(
                                    "Karadeniz",
                                    "Fırtınalı",
                                    18,
                                    28,
                                    "Tehlikeli!",
                                    AppColors.danger,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Sağ: reklam kartları (yan yana)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAdCard(
                                icon: Icons.store_rounded,
                                brand: "BSE Marine Market",
                                slogan: "Sezon indirimleri\n%40'a kadar!",
                                accentColor: AppColors.warning,
                              ),
                              const SizedBox(width: 8),
                              _buildAdCard(
                                icon: Icons.security_rounded,
                                brand: "Deniz Sigorta",
                                slogan: "Teknenizi\ngüvence altına alın",
                                accentColor: AppColors.accent,
                              ),
                              const SizedBox(width: 8),
                              _buildAdCard(
                                icon: Icons.phishing_rounded,
                                brand: "Balıkçı Dükkânı",
                                slogan: "Pro olta takımları\nşimdi stokta!",
                                accentColor: AppColors.safe,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // 3. Bölgesel Bilgi — soldan gelir
              FadeTransition(
                opacity: _infoFade,
                child: SlideTransition(
                  position: _infoSlide,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle("🌊  Bölgesel Bilgi Köşesi"),
                      const SizedBox(height: 14),
                      _buildInfoCard(
                        title: "Akdeniz",
                        description:
                            "Barbun ve Orfoz bol görülür. Caretta Caretta'lara dikkat!",
                        icon: Icons.waves_rounded,
                        accentColor: AppColors.warning,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        title: "Ege",
                        description:
                            "Çipura ve Levrek yaygındır. Berrak suları zıpkın avı için idealdir.",
                        icon: Icons.sailing_rounded,
                        accentColor: AppColors.accent,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        title: "Karadeniz",
                        description:
                            "Hamsi ve Palamut sezonu. Hırçın dalgalara karşı tedbirli olun.",
                        icon: Icons.water_rounded,
                        accentColor: AppColors.safe,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // 4. Buton + Reklam — aşağıdan gelir
              FadeTransition(
                opacity: _bottomFade,
                child: SlideTransition(
                  position: _bottomSlide,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.explore_rounded),
                          label: const Text("Araçları ve Ekipmanları Keşfet"),
                          onPressed: () => Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, animation, __) =>
                                  const ListPage(),
                              transitionsBuilder: (_, animation, __, child) =>
                                  FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                              transitionDuration: const Duration(
                                milliseconds: 400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
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

  // ── Yardımcı UI Parçaları ─────────────────────────────────────────────────────

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0E3A5A), Color(0xFF0B1E34)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.4),
              ),
            ),
            child: const Icon(
              Icons.sailing_rounded,
              size: 42,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Denize Açılmadan Önce",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Eksiğiniz kalmasın, güvenli yolculuklar!",
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard(
    String region,
    String status,
    int temp,
    int wind,
    String safety,
    Color safetyColor,
  ) {
    final IconData weatherIcon = status == "Fırtınalı"
        ? Icons.thunderstorm_rounded
        : status == "Rüzgarlı"
        ? Icons.air_rounded
        : Icons.wb_sunny_rounded;

    return Container(
      width: 155,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: safetyColor.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: safetyColor.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            region,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          Divider(color: AppColors.divider, height: 20),
          Icon(weatherIcon, color: safetyColor, size: 34),
          const SizedBox(height: 10),
          Text(
            "$temp°C",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "💨 $wind km/s",
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: safetyColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: safetyColor.withValues(alpha: 0.4)),
            ),
            child: Text(
              safety,
              style: TextStyle(
                color: safetyColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String description,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: accentColor.withValues(alpha: 0.35)),
            ),
            child: Icon(icon, color: accentColor, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdCard({
    required IconData icon,
    required String brand,
    required String slogan,
    required Color accentColor,
  }) {
    return Container(
      width: 148,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentColor.withValues(alpha: 0.18),
            accentColor.withValues(alpha: 0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accentColor.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: accentColor.withValues(alpha: 0.4)),
            ),
            child: Icon(icon, color: accentColor, size: 26),
          ),
          const SizedBox(height: 10),
          Text(
            brand,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            slogan,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: accentColor.withValues(alpha: 0.4)),
            ),
            child: Text(
              "İncele →",
              style: TextStyle(
                color: accentColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
