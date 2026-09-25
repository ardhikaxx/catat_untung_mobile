import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../shared/widgets/app_back_button.dart';
import '../../shared/widgets/app_floating_nav_bar.dart';

class QuickGuideScreen extends StatelessWidget {
  const QuickGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      bottomNavigationBar: const AppFloatingNavBar(activeIndex: 4),
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: const AppBackButton(),

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n?.guideAppBarTitle ?? 'Panduan Singkat',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              l10n?.guideAppBarSubtitle ?? 'Tips praktis & alur pembukuan UMKM',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          // Hero Banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryGreen,
                  AppColors.primaryGreenDark,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withAlpha(50),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(30),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(LucideIcons.bookOpen, size: 14, color: Colors.white),
                                const SizedBox(width: 6),
                                Text(
                                  l10n?.guideHeroBadge ?? 'PANDUAN LENGKAP UMKM',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n?.guideHeroHeadline ?? 'Kuasai Pembukuan Toko\nDalam 4 Langkah Mudah',
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.25,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          LucideIcons.lightbulb,
                          size: 28,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  l10n?.guideHeroDescription ??
                      'Catat Untung dirancang agar Anda bisa merekap penjualan hanya dalam 1 menit setiap hari tanpa perlu ribet pakai buku kertas.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: Colors.white.withAlpha(220),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Section 1: 4 Langkah Utama
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.checkSquare,
                  size: 16,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n?.guideWorkflowTitle ?? 'ALUR KERJA HARIAN',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Step Cards
          _buildStepCard(
            context: context,
            stepNumber: '1',
            title: l10n?.guideStep1Title ?? 'Daftarkan Katalog & Modal HPP',
            description: l10n?.guideStep1Description ??
                'Tambahkan produk yang Anda jual beserta harga jual dan modal HPP per unitnya. Jika belum tahu HPP, gunakan fitur Kalkulator HPP.',
            icon: LucideIcons.packagePlus,
            actionLabel: l10n?.guideStep1Action ?? 'Buka Katalog Produk',
            onAction: () => context.push('/products'),
          ),

          _buildStepCard(
            context: context,
            stepNumber: '2',
            title: l10n?.guideStep2Title ?? 'Catat Rekap Penjualan Harian',
            description: l10n?.guideStep2Description ??
                'Setiap sore atau saat toko tutup, buka menu Rekap Penjualan. Masukkan jumlah unit produk yang laku terjual hari ini.',
            icon: LucideIcons.edit,
            actionLabel: l10n?.guideStep2Action ?? 'Buka Rekap Penjualan',
            onAction: () => context.push('/daily-rekap'),
          ),

          _buildStepCard(
            context: context,
            stepNumber: '3',
            title: l10n?.guideStep3Title ?? 'Pantau Omzet & Laba Bersih',
            description: l10n?.guideStep3Description ??
                'Lihat langsung di halaman Beranda berapa total uang masuk (omzet), total modal yang terpakai, dan keuntungan bersih yang Anda bawa pulang.',
            icon: LucideIcons.barChart3,
            actionLabel: l10n?.guideStep3Action ?? 'Lihat Beranda',
            onAction: () => context.go('/'),
          ),

          _buildStepCard(
            context: context,
            stepNumber: '4',
            title: l10n?.guideStep4Title ?? 'Analisis Tren & Unduh Laporan',
            description: l10n?.guideStep4Description ??
                'Pelajari produk apa yang paling laris (Best Seller) dan tren omzet mingguan. Anda juga bisa mengekspor laporan bulanan ke format PDF / CSV.',
            icon: LucideIcons.fileUp,
            actionLabel: l10n?.guideStep4Action ?? 'Ekspor Laporan PDF',
            onAction: () => context.push('/export'),
          ),

          const SizedBox(height: 16),

          // Section 2: Tips Sukses UMKM
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.lightbulb,
                  size: 16,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n?.guideTipsTitle ?? 'TIPS KEUANGAN UMKM',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          _buildTipCard(
            icon: LucideIcons.wallet,
            iconColor: AppColors.primaryGreen,
            bgColor: AppColors.greenTint,
            title: l10n?.guideTip1Title ?? 'Pisahkan Dompet Pribadi & Kas Usaha',
            description: l10n?.guideTip1Description ??
                'Hindari memakai uang kas jualan untuk jajan pribadi sebelum menghitung laba bersih bulanan agar modal usaha Anda tidak tergerus.',
          ),

          _buildTipCard(
            icon: LucideIcons.calculator,
            iconColor: const Color(0xFFD97706),
            bgColor: const Color(0xFFFEF3C7),
            title: l10n?.guideTip2Title ?? 'Perhitungkan Kemasan & Gas LPG',
            description: l10n?.guideTip2Description ??
                'Banyak pedagang lupa menghitung biaya kantong plastik, cup, dan gas LPG dalam HPP sehingga margin keuntungan menjadi lebih kecil dari perkiraan.',
          ),

          _buildTipCard(
            icon: LucideIcons.shieldCheck,
            iconColor: const Color(0xFF2563EB),
            bgColor: const Color(0xFFDBEAFE),
            title: l10n?.guideTip3Title ?? 'Cadangkan Data Secara Berkala',
            description: l10n?.guideTip3Description ??
                'Karena aplikasi ini 100% offline, lakukan backup data di menu Pengaturan > Backup setiap akhir minggu untuk menjaga riwayat transaksi Anda aman.',
          ),

          const SizedBox(height: 16),

          // Section 3: FAQ Interaktif
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.helpCircle,
                  size: 16,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n?.guideFaqTitle ?? 'PERTANYAAN UMUM (FAQ)',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          _buildFaqTile(
            question: l10n?.guideFaq1Question ?? 'Apakah aplikasi membutuhkan internet?',
            answer: l10n?.guideFaq1Answer ??
                'Tidak sama sekali. Catat Untung beroperasi 100% secara offline. Data tersimpan di penyimpanan internal smartphone Anda sehingga Anda dapat mencatat di mana saja tanpa kuota internet.',
          ),

          _buildFaqTile(
            question: l10n?.guideFaq2Question ??
                'Bagaimana memindahkan data saat ganti smartphone?',
            answer: l10n?.guideFaq2Answer ??
                'Buka menu Pengaturan > Backup & Pemulihan. Pilih "Buat Cadangan Baru", simpan file hasil cadangan ke Google Drive atau kirim ke WhatsApp Anda. Pada smartphone baru, pasang aplikasi dan pilih "Pulihkan Data".',
          ),

          _buildFaqTile(
            question: l10n?.guideFaq3Question ??
                'Bagaimana jika ada produk yang saya berikan gratis / tester?',
            answer: l10n?.guideFaq3Answer ??
                'Anda tetap dapat mencatat jumlah modalnya di rekap harian atau menambahkan produk dengan harga jual Rp 0 agar modal tetap terhitung dalam pembukuan laba bersih Anda.',
          ),

          _buildFaqTile(
            question: l10n?.guideFaq4Question ?? 'Bagaimana cara mencetak laporan untuk pemilik usaha?',
            answer: l10n?.guideFaq4Answer ??
                'Gunakan menu Pengaturan > Ekspor Laporan. Anda dapat memilih rentang tanggal tertentu dan mengunduh laporan berformat PDF rapi siap cetak atau format CSV untuk diolah di Microsoft Excel.',
          ),

          const SizedBox(height: 24),

          // Bottom Action Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => context.go('/daily-rekap'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(LucideIcons.edit, size: 20),
                label: Text(
                  l10n?.guideStartButton ?? 'Mulai Catat Rekap Penjualan',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Center(
            child: Text(
              AppConstants.copyright,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary.withAlpha(190),
              ),
            ),
          ),

          const SizedBox(height: AppFloatingNavBar.bottomSpacing),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required BuildContext context,
    required String stepNumber,
    required String title,
    required String description,
    required IconData icon,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    stepNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.greenTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      actionLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      LucideIcons.chevronRight,
                      size: 14,
                      color: AppColors.primaryGreen,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
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

  Widget _buildFaqTile({
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          iconColor: AppColors.primaryGreen,
          collapsedIconColor: AppColors.textSecondary,
          children: [
            Text(
              answer,
              style: const TextStyle(
                fontSize: 12,
                height: 1.45,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
