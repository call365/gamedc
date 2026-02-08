import 'package:flutter/material.dart';
import 'package:flutter_web_shop/partner_admin.dart';
import 'package:flutter_web_shop/super_admin.dart';
import 'package:flutter_web_shop/user_shop.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameDTC Platform',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        fontFamily: 'NotoSansKR',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/shop': (context) => const UserShopPage(),
        '/partner': (context) => const PartnerAdminPage(),
        '/super': (context) => const SuperAdminPage(),
      },
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.videogame_asset, color: Colors.indigo, size: 32),
            SizedBox(width: 8),
            Text('GameDTC', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/shop'),
            child: const Text('샘플 상점', style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(width: 16),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/partner'),
            child: const Text('파트너 로그인', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              color: const Color(0xFFF5F7FA),
              child: Column(
                children: [
                  const Text(
                    "누구나 쉽게 만드는\n나만의 게임 아이템 샵",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, height: 1.2, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "복잡한 결제 연동, 정산 시스템을 10분 만에 구축하세요.\n전 세계 게이머를 위한 상점을 지금 바로 시작할 수 있습니다.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey, height: 1.6),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/partner'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text("무료로 시작하기", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  const Text("신용카드 없이 시작 가능 • 14일 무료 체험", style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ),

            // 2. Features Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFeatureItem(
                      icon: Icons.payment,
                      title: "글로벌 결제 지원",
                      desc: "PG사 계약 없이도\n즉시 카드/간편결제 연동 가능",
                    ),
                    _buildFeatureItem(
                      icon: Icons.analytics_outlined,
                      title: "강력한 어드민",
                      desc: "매출 현황부터 아이템 관리까지\n한눈에 파악하는 대시보드",
                    ),
                    _buildFeatureItem(
                      icon: Icons.bolt,
                      title: "실시간 연동",
                      desc: "웹훅(Webhook)을 통해\n게임 서버와 실시간 데이터 동기화",
                    ),
                  ],
                ),
              ),
            ),

            // 3. CTA Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 60),
              color: Colors.indigo,
              child: Column(
                children: [
                  const Text("지금 바로 입점하세요", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, '/partner'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                    ),
                    child: const Text("파트너 등록 신청", style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
            
            // 4. Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              color: Colors.grey.shade900,
              child: const Column(
                children: [
                  Text("GameDTC Platform", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("© 2026 GameDTC Inc. All rights reserved.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String title, required String desc}) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.indigo.shade50, shape: BoxShape.circle),
            child: Icon(icon, size: 40, color: Colors.indigo),
          ),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(desc, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, height: 1.5)),
        ],
      ),
    );
  }
}

