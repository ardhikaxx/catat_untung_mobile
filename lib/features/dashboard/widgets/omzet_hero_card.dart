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

  @override
  Widget build(BuildContext context) {
    const cardHeight = 222.0;
    const cutoutW = 144.0;
    const cutoutH = 52.0;
    const filletR = 18.0;
    const cornerR = 24.0;

    final clipper = _NotchedCardClipper(
      cutoutWidth: cutoutW,
      cutoutHeight: cutoutH,
      cornerRadius: cornerR,
      filletRadius: filletR,
    );

    final displayDate = date ?? DateTime.now();

    return SizedBox(
      height: cardHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. Foreground Purple Card Shadow
          Positioned.fill(
            child: CustomPaint(
              painter: _NotchedCardShadowPainter(
                clipper: clipper,
                shadowColor: const Color(0xFF8B36FF).withAlpha(80),
                elevation: 12,
              ),
            ),
          ),

          // 2. Foreground Purple Card (Clipped)
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
                    // Top Row: App Brand & Date Badge
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

                    // Middle Row: Total Omzet & Laba Bersih
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: Total Omzet
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

                        // Right: Laba Bersih (above notch)
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

                    // Bottom Row: Total Terjual (left side of the notch)
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

          // 3. Black Pill Button "+ Rekap" nested inside the cutout
          Positioned(
            bottom: 3,
            right: 3,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onRekapTap,
                borderRadius: BorderRadius.circular(26),
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(60),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Rekap Baru',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
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

class _NotchedCardClipper extends CustomClipper<Path> {
  final double cutoutWidth;
  final double cutoutHeight;
  final double cornerRadius;
  final double filletRadius;

  _NotchedCardClipper({
    required this.cutoutWidth,
    required this.cutoutHeight,
    required this.cornerRadius,
    required this.filletRadius,
  });

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final r = cornerRadius;
    final f = filletRadius;
    final cw = cutoutWidth;
    final ch = cutoutHeight;

    final path = Path();
    // 1. Top-left corner
    path.moveTo(r, 0);

    // 2. Top edge to top-right
    path.lineTo(w - r, 0);
    path.arcToPoint(Offset(w, r), radius: Radius.circular(r));

    // 3. Right edge down to notch start
    path.lineTo(w, h - ch - f);

    // 4. Notch turn left (convex from card perspective)
    path.arcToPoint(
      Offset(w - f, h - ch),
      radius: Radius.circular(f),
      clockwise: true,
    );

    // 5. Horizontal line along top of cutout
    path.lineTo(w - cw + f, h - ch);

    // 6. Notch scoop downwards (concave from card perspective, convex for cutout)
    path.arcToPoint(
      Offset(w - cw, h - ch + f),
      radius: Radius.circular(f),
      clockwise: false,
    );

    // 7. Vertical edge of cutout going down
    path.lineTo(w - cw, h - f);

    // 8. Notch turn left to bottom edge (convex from card perspective)
    path.arcToPoint(
      Offset(w - cw - f, h),
      radius: Radius.circular(f),
      clockwise: true,
    );

    // 9. Bottom edge to bottom-left corner
    path.lineTo(r, h);
    path.arcToPoint(Offset(0, h - r), radius: Radius.circular(r));

    // 10. Left edge up to top-left corner
    path.lineTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _NotchedCardClipper oldClipper) {
    return oldClipper.cutoutWidth != cutoutWidth ||
        oldClipper.cutoutHeight != cutoutHeight ||
        oldClipper.cornerRadius != cornerRadius ||
        oldClipper.filletRadius != filletRadius;
  }
}

class _NotchedCardShadowPainter extends CustomPainter {
  final _NotchedCardClipper clipper;
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
