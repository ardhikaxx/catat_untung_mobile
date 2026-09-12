import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';

class OmzetHeroCard extends StatelessWidget {
  final int totalRevenue;
  final int totalProfit;
  final int totalQuantity;
  final DateTime? date;
  final VoidCallback onRekapTap;

  const OmzetHeroCard({
    super.key,
    required this.totalRevenue,
    required this.totalProfit,
    this.totalQuantity = 0,
    this.date,
    required this.onRekapTap,
  });

  // Dimensi kartu & tombol agar lekukan konsentris sempurna
  static const double cardHeight = 222.0;
  static const double btnW = 150.0;
  static const double btnH = 46.0;
  static const double btnRight = 4.0;
  static const double btnBottom = 4.0;
  static const double gap = 9.0;
  static const double cornerR = 24.0;
  static const double rTopRight = 20.0;
  static const double rBottom = 22.0;

  @override
  Widget build(BuildContext context) {
    const btnR = btnH / 2; // 23.0

    final clipper = _ConcentricNotchedCardClipper(
      btnW: btnW,
      btnH: btnH,
      btnRight: btnRight,
      btnBottom: btnBottom,
      btnR: btnR,
      gap: gap,
      cornerR: cornerR,
      rTopRight: rTopRight,
      rBottom: rBottom,
    );

    final displayDate = date ?? DateTime.now();

    return SizedBox(
      height: cardHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. Bayangan Kartu Ungu Mengikuti Lekukan
          Positioned.fill(
            child: CustomPaint(
              painter: _NotchedCardShadowPainter(
                clipper: clipper,
                shadowColor: const Color(0xFF8B36FF).withAlpha(80),
                elevation: 12,
              ),
            ),
          ),

          // 2. Kartu Ungu (Dipotong dengan Clipper Konsentris)
          Positioned.fill(
            child: ClipPath(
              clipper: clipper,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF8F3BFF),
                      Color(0xFF721FE3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Baris Atas: Brand & Badge Tanggal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(45),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Iconsax.wallet_3,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Catat Untung',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(35),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            DateFormatter.formatShort(displayDate),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Baris Tengah: Total Omzet & Laba Bersih
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kiri: Total Omzet
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Omzet',
                              style: TextStyle(
                                color: Colors.white.withAlpha(200),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              CurrencyFormatter.formatRupiah(totalRevenue),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),

                        // Kanan: Laba Bersih (di atas lekukan)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Laba Bersih',
                              style: TextStyle(
                                color: Colors.white.withAlpha(200),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              totalProfit >= 0
                                  ? '+${CurrencyFormatter.formatRupiahCompact(totalProfit)}'
                                  : CurrencyFormatter.formatRupiahCompact(totalProfit),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Baris Bawah: Total Terjual (sisi kiri lekukan)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Total Terjual',
                          style: TextStyle(
                            color: Colors.white.withAlpha(200),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$totalQuantity Produk',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Tombol Pill Hitam "+ Rekap Baru" Konsentris di Sudut Lekukan
          Positioned(
            bottom: btnBottom,
            right: btnRight,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onRekapTap,
                borderRadius: BorderRadius.circular(btnR),
                child: Container(
                  width: btnW,
                  height: btnH,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    borderRadius: BorderRadius.circular(btnR),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(70),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 15,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Flexible(
                        child: Text(
                          'Rekap Baru',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
}

class _ConcentricNotchedCardClipper extends CustomClipper<Path> {
  final double btnW;
  final double btnH;
  final double btnRight;
  final double btnBottom;
  final double btnR;
  final double gap;
  final double cornerR;
  final double rTopRight;
  final double rBottom;

  _ConcentricNotchedCardClipper({
    required this.btnW,
    required this.btnH,
    required this.btnRight,
    required this.btnBottom,
    required this.btnR,
    required this.gap,
    required this.cornerR,
    required this.rTopRight,
    required this.rBottom,
  });

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    // Posisi tombol
    final btnX = w - btnRight - btnW;
    final btnY = h - btnBottom - btnH;
    final btnCenterX = btnX + btnR;
    final btnCenterY = btnY + btnR;

    // Garis batas cutout
    final cutoutTop = btnY - gap;
    final cutoutLeft = btnX - gap;

    // Radius lengkungan konsentris = radius tombol + celah (gap)
    final filletR = btnR + gap;

    // Titik awal lekukan di atas tombol (12 o'clock relatif terhadap pusat lingkaran tombol)
    final arcStartX = btnCenterX;
    final arcStartY = cutoutTop;

    // Titik akhir lekukan di samping tombol (9 o'clock relatif terhadap pusat lingkaran tombol)
    final arcEndX = cutoutLeft;
    final arcEndY = btnCenterY;

    final path = Path();

    // 1. Sudut kiri atas kartu
    path.moveTo(cornerR, 0);

    // 2. Sisi atas ke sudut kanan atas
    path.lineTo(w - cornerR, 0);
    path.arcToPoint(Offset(w, cornerR), radius: Radius.circular(cornerR));

    // 3. Sisi kanan turun menuju awal lekukan atas
    path.lineTo(w, cutoutTop - rTopRight);

    // 4. Belokan halus ke dalam (ke kiri) menuju atas tombol
    path.arcToPoint(
      Offset(w - rTopRight, cutoutTop),
      radius: Radius.circular(rTopRight),
      clockwise: true,
    );

    // 5. Garis horizontal tepat di atas tombol hingga titik 12 o'clock tombol
    path.lineTo(arcStartX, arcStartY);

    // 6. Lengkungan KONSENTRIS mengikuti setengah lingkaran tombol (12 o'clock ke 9 o'clock)
    path.arcToPoint(
      Offset(arcEndX, arcEndY),
      radius: Radius.circular(filletR),
      clockwise: false,
    );

    // 7. Garis vertikal pendek sebelum belokan ke sisi bawah
    if (arcEndY < h - rBottom) {
      path.lineTo(cutoutLeft, h - rBottom);
    }

    // 8. Belokan cembung keluar menuju sisi bawah kartu
    path.arcToPoint(
      Offset(cutoutLeft - rBottom, h),
      radius: Radius.circular(rBottom),
      clockwise: true,
    );

    // 9. Sisi bawah ke sudut kiri bawah
    path.lineTo(cornerR, h);
    path.arcToPoint(Offset(0, h - cornerR), radius: Radius.circular(cornerR));

    // 10. Sisi kiri naik ke sudut kiri atas
    path.lineTo(0, cornerR);
    path.arcToPoint(Offset(cornerR, 0), radius: Radius.circular(cornerR));

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _ConcentricNotchedCardClipper oldClipper) {
    return oldClipper.btnW != btnW ||
        oldClipper.btnH != btnH ||
        oldClipper.btnRight != btnRight ||
        oldClipper.btnBottom != btnBottom ||
        oldClipper.btnR != btnR ||
        oldClipper.gap != gap ||
        oldClipper.cornerR != cornerR ||
        oldClipper.rTopRight != rTopRight ||
        oldClipper.rBottom != rBottom;
  }
}

class _NotchedCardShadowPainter extends CustomPainter {
  final _ConcentricNotchedCardClipper clipper;
  final Color shadowColor;
  final double elevation;

  _NotchedCardShadowPainter({
    required this.clipper,
    required this.shadowColor,
    this.elevation = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = clipper.getClip(size);
    canvas.drawShadow(path, shadowColor, elevation, false);
  }

  @override
  bool shouldRepaint(covariant _NotchedCardShadowPainter oldDelegate) => false;
}
