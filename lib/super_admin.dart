import 'package:flutter/material.dart';

class SuperAdminPage extends StatefulWidget {
  const SuperAdminPage({super.key});

  @override
  State<SuperAdminPage> createState() => _SuperAdminPageState();
}

class _SuperAdminPageState extends State<SuperAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('슈퍼 어드민 (Platform Manager)'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🏦 정산 요청 관리', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildSettlementRequestCard(
              companyName: 'Dragon RPG',
              amount: 9000000,
              date: '2026-02-01',
            ),
            _buildSettlementRequestCard(
              companyName: 'Space Shooter',
              amount: 350000,
              date: '2026-02-02',
            ),
             const SizedBox(height: 30),
            const Text('🎮 입점 게임사 관리', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
             const SizedBox(height: 10),
             Card(
               child: ListTile(
                 leading: const CircleAvatar(child: Text('D')),
                 title: const Text('Dragon RPG'),
                 subtitle: const Text('매출: 10,000,000원 | 수수료: 10%'),
                 trailing: const Icon(Icons.more_vert),
               ),
             )
          ],
        ),
      ),
    );
  }

  Widget _buildSettlementRequestCard({
    required String companyName,
    required double amount,
    required String date,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(companyName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Chip(label: const Text('승인 대기'), backgroundColor: Colors.orange[100], labelStyle: TextStyle(color: Colors.orange[800])),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('요청 금액'),
                Text('₩ ${moneyFormat(amount)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
             const SizedBox(height: 5),
             Align(alignment: Alignment.centerRight, child: Text('요청일: $date', style: const TextStyle(color: Colors.grey))),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('거절'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$companyName 정산 승인 및 이체 처리 완료')),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text('승인 및 이체', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String moneyFormat(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
      (Match m) => '${m[1]},'
    );
  }
}
