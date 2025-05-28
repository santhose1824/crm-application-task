import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

class AgentDashboardScreen extends StatelessWidget {
  const AgentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildQuickStats(context),
              const SizedBox(height: 32),
              Text("Performance", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildBarChartCard(),
              const SizedBox(height: 24),
              _buildPieChartCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3F51B5), Color(0xFF7986CB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome Agent",
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text("Track your progress and activity", style: GoogleFonts.poppins(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _dashboardCard(context, title: "My Customers", value: "15", icon: Mdi.account_outline, color: Colors.indigo),
            const SizedBox(width: 12),
            _dashboardCard(context, title: "Chats", value: "35", icon: Mdi.chat_outline, color: Colors.green),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _dashboardCard(context, title: "Follow-Ups", value: "07", icon: Mdi.calendar_clock, color: Colors.orange),
            const SizedBox(width: 12),
            _dashboardCard(context, title: "Calls Made", value: "20", icon: Mdi.phone_outline, color: Colors.purple),
          ],
        ),
      ],
    );
  }

  Widget _dashboardCard(
      BuildContext context, {
        required String title,
        required String value,
        required String icon,
        required Color color,
      }) {
    return Expanded(
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Iconify(icon, color: color, size: 28),
            const Spacer(),
            Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(title, style: GoogleFonts.poppins(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChartCard() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: [
            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 15, color: Colors.indigo)]),
            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 35, color: Colors.green)]),
            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 7, color: Colors.orange)]),
            BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 20, color: Colors.purple)]),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text("Customers");
                    case 1:
                      return const Text("Chats");
                    case 2:
                      return const Text("Follow-Ups");
                    case 3:
                      return const Text("Calls");
                    default:
                      return const Text("");
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }

  Widget _buildPieChartCard() {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Activity Split", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 30,
                      sectionsSpace: 2,
                      startDegreeOffset: 270,
                      sections: [
                        PieChartSectionData(value: 15, color: Colors.indigo, title: ''),
                        PieChartSectionData(value: 35, color: Colors.green, title: ''),
                        PieChartSectionData(value: 7, color: Colors.orange, title: ''),
                        PieChartSectionData(value: 20, color: Colors.purple, title: ''),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legend(color: Colors.indigo, title: 'Customers'),
                    _legend(color: Colors.green, title: 'Chats'),
                    _legend(color: Colors.orange, title: 'Follow-Ups'),
                    _legend(color: Colors.purple, title: 'Calls'),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend({required Color color, required String title}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(title, style: GoogleFonts.poppins(fontSize: 12)),
        ],
      ),
    );
  }
}
