import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_web_shop/partner_admin.dart';
import 'package:flutter_web_shop/super_admin.dart';
import 'payment_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 실제로는 URL 파싱이나 로그인 상태에 따라 초기 화면을 결정해야 함
    return MaterialApp(
      title: 'Game DTC Web Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/partner': (context) => const PartnerAdminPage(),
        '/super': (context) => const SuperAdminPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 실제로는 Firestore StreamBuilder로 포인트 잔액을 실시간으로 가져와야 합니다.
  int _currentPoints = 0; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게임 아이템 상점'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '내 포인트: $_currentPoints P',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // 데모용 어드민 이동 버튼
          IconButton(
            icon: const Icon(Icons.business),
            tooltip: '파트너 어드민',
            onPressed: () => Navigator.pushNamed(context, '/partner'),
          ),
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            tooltip: '슈퍼 어드민',
            onPressed: () => Navigator.pushNamed(context, '/super'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '원하는 아이템을 구매하세요!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaymentPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('포인트 충전하기 (10,000 P)'),
            ),
            const SizedBox(height: 20),
            // 아이템 리스트 예시 (Grid)
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(20),
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  _buildItemCard('다이아 100개', '1,000 P', 1000),
                  _buildItemCard('다이아 500개', '4,500 P (10% 할인)', 4500),
                  _buildItemCard('전설의 검', '50,000 P', 50000),
                  _buildItemCard('용사의 방패', '30,000 P', 30000),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(String name, String priceStr, int price) {
    return Card(
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_bag, size: 48, color: Colors.amber),
          const SizedBox(height: 10),
          Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(priceStr, style: const TextStyle(color: Colors.blueGrey)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _buyItem(name, price),
            child: const Text('구매'),
          )
        ],
      ),
    );
  }

  Future<void> _buyItem(String itemId, int price) async {
    const String cloudFunctionUrl = 'http://localhost:5001/demo-test/us-central1/buyItem';
    try {
      final response = await http.post(
        Uri.parse(cloudFunctionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'data': {
            'item_id': itemId,
            'price': price,
          }
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['result'] != null && body['result']['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('구매 완료! 포인트가 차감되었습니다.')),
          );
          // 포인트 갱신 (데모용: 로컬 상태만 갱신)
          setState(() {
            _currentPoints -= price;
          });
        } else {
           // 에러 메시지 파싱
           final errorMsg = body['error']?['message'] ?? 'Unknown error';
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('구매 실패: $errorMsg')),
          );
        }
      } else {
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('서버 오류: ${response.statusCode}')),
          );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('통신 오류: $e')),
      );
    }
  }
}
