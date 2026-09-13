import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_floating_nav_bar.dart';

class QuickGuideScreen extends StatelessWidget {
  const QuickGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      bottomNavigationBar: const AppFloatingNavBar(activeIndex: 4),
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Iconsax.arrow_left,
            size: 20,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Panduan Singkat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Tips praktis & alur pembukuan UMKM',
              style: TextStyle(
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
                              children: const [
                                Icon(Iconsax.book_1, size: 14, color: Colors.white),
                                SizedBox(width: 6),
                                Text(
                                  'PANDUAN LENGKAP UMKM',
                                  style: TextStyle(
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
                          const Text(
                            'Kuasai Pembukuan Toko\nDalam 4 Langkah Mudah',
                            style: TextStyle(
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
                      width: 64,
                      height: 64,
                      padding: const EdgeInsets.all(6),
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          AppGifs.customerService,
                          cacheWidth: 130,
                          cacheHeight: 130,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
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
                  Iconsax.task_square,
                  size: 16,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 8),
                const Text(
                  'ALUR KERJA HARIAN',
                  style: TextStyle(
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
            title: 'Daftarkan Katalog & Modal HPP',
            description:
                'Tambahkan produk yang Anda jual beserta harga jual dan modal HPP per unitnya. Jika belum tahu HPP, gunakan fitur Kalkulator HPP.',
            icon: Iconsax.box_add,
            actionLabel: 'Buka Katalog Produk',
            onAction: () => context.push('/products'),
          ),

          _buildStepCard(
            context: context,
            stepNumber: '2',
            title: 'Catat Rekap Penjualan Harian',
            description:
                'Setiap sore atau saat toko tutup, buka menu Rekap Penjualan. Masukkan jumlah unit produk yang laku terjual hari ini.',
            icon: Iconsax.edit_2,
            actionLabel: 'Buka Rekap Penjualan',
            onAction: () => context.push('/daily-rekap'),
          ),

          _buildStepCard(
            context: context,
            stepNumber: '3',
            title: 'Pantau Omzet & Laba Bersih',
            description:
                'Lihat langsung di halaman Beranda berapa total uang masuk (omzet), total modal yang terpakai, dan keuntungan bersih yang Anda bawa pulang.',
            icon: Iconsax.chart_21,
            actionLabel: 'Lihat Beranda',
            onAction: () => context.go('/'),
          ),

          _buildStepCard(
            context: context,
            stepNumber: '4',
            title: 'Analisis Tren & Unduh Laporan',
            description:
                'Pelajari produk apa yang paling laris (Best Seller) dan tren omzet mingguan. Anda juga bisa mengekspor laporan bulanan ke format PDF / CSV.',
            icon: Iconsax.document_upload,
            actionLabel: 'Ekspor Laporan PDF',
            onAction: () => context.push('/export'),
          ),

          const SizedBox(height: 16),

          // Section 2: Tips Sukses UMKM
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Row(
              children: [
                const Icon(
                  Iconsax.lamp_charge,
                  size: 16,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 8),
                const Text(
                  'TIPS KEUANGAN UMKM',
                  style: TextStyle(
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
            icon: Iconsax.money_send,
            iconColor: AppColors.primaryGreen,
            bgColor: AppColors.greenTint,
            title: 'Pisahkan Dompet Pribadi & Kas Usaha',
            description:
                'Hindari memakai uang kas jualan untuk jajan pribadi sebelum menghitung laba bersih bulanan agar modal usaha Anda tidak tergerus.',
          ),

          _buildTipCard(
            icon: Iconsax.calculator,
            iconColor: const Color(0xFFD97706),
            bgColor: const Color(0xFFFEF3C7),
            title: 'Perhitungkan Kemasan & Gas LPG',
            description:
                'Banyak pedagang lupa menghitung biaya kantong plastik, cup, dan gas LPG dalam HPP sehingga margin keuntungan menjadi lebih kecil dari perkiraan.',
          ),

          _buildTipCard(
            icon: Iconsax.shield_tick,
            iconColor: const Color(0xFF2563EB),
            bgColor: const Color(0xFFDBEAFE),
            title: 'Cadangkan Data Secara Berkala',
            description:
                'Karena aplikasi ini 100% offline, lakukan backup data di menu Pengaturan > Backup setiap akhir minggu untuk menjaga riwayat transaksi Anda aman.',
          ),

          const SizedBox(height: 16),

          // Section 3: FAQ Interaktif
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Row(
              children: [
                const Icon(
                  Iconsax.message_question,
                  size: 16,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 8),
                const Text(
                  'PERTANYAAN UMUM (FAQ)',
                  style: TextStyle(
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
            question: 'Apakah aplikasi membutuhkan internet?',
            answer:
                'Tidak sama sekali. Catat Untung beroperasi 100% secara offline. Data tersimpan di penyimpanan internal smartphone Anda sehingga Anda dapat mencatat di mana saja tanpa kuota internet.',
          ),

          _buildFaqTile(
            question: 'Bagaimana memindahkan data saat ganti smartphone?',
            answer:
                'Buka menu Pengaturan > Backup & Pemulihan. Pilih "Buat Cadangan Baru", simpan file hasil cadangan ke Google Drive atau kirim ke WhatsApp Anda. Pada smartphone baru, pasang aplikasi dan pilih "Pulihkan Data".',
          ),

          _buildFaqTile(
            question: 'Bagaimana jika ada produk yang saya berikan gratis / tester?',
            answer:
                'Anda tetap dapat mencatat jumlah modalnya di rekap harian atau menambahkan produk dengan harga jual Rp 0 agar modal tetap terhitung dalam pembukuan laba bersih Anda.',
          ),

          _buildFaqTile(
            question: 'Bagaimana cara mencetak laporan untuk pemilik usaha?',
            answer:
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
                icon: const Icon(Iconsax.edit_2, size: 20),
                label: const Text(
                  'Mulai Catat Rekap Penjualan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
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
            style: TextStyle(
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
                      Iconsax.arrow_right_3,
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
                  style: TextStyle(
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
              style: TextStyle(
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
