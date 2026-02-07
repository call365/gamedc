import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PartnerAdminPage extends StatefulWidget {
  const PartnerAdminPage({super.key});

  @override
  State<PartnerAdminPage> createState() => _PartnerAdminPageState();
}

class _PartnerAdminPageState extends State<PartnerAdminPage> {
  int _selectedIndex = 0;
  final currencyFormat = NumberFormat.currency(locale: 'ko_KR', symbol: '₩');

  // 상품 등록용 컨트롤러
  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _itemCodeController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 2. 좌측 메뉴바 구성 (Navigation Rail)
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: const Column(
                children: [
                  Icon(Icons.videogame_asset, size: 40, color: Colors.indigo),
                  SizedBox(height: 8),
                  Text("GamePay\nShop", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('현황'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.storefront_outlined),
                selectedIcon: Icon(Icons.storefront),
                label: Text('상점 설정'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long),
                label: Text('거래 내역'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.account_balance_wallet_outlined),
                selectedIcon: Icon(Icons.account_balance_wallet),
                label: Text('정산 센터'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.integration_instructions_outlined),
                selectedIcon: Icon(Icons.integration_instructions),
                label: Text('개발자'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // 중앙 (Body)
          Expanded(
            child: Container(
              color: const Color(0xFFF5F7FA), // 연한 회색 배경
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: _buildContent(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      color: Colors.white,
      child: Row(
        children: [
          const Text("Dragon RPG", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          const CircleAvatar(
            backgroundColor: Colors.indigo,
            child: Text("A", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildShopManagement();
      case 2:
        return const Center(child: Text("거래 내역 페이지 (준비중)"));
      case 3:
        return const Center(child: Text("정산 센터 페이지 (준비중)"));
      case 4:
        return _buildDeveloperSettings();
      default:
        return _buildDashboard();
    }
  }

  // C. 개발자 설정 (Developer Settings)
  Widget _buildDeveloperSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("🛠️ 개발자 설정", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Webhook URL 설정", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              const Text("결제 완료 시 알림을 받을 게임 서버의 URL을 입력하세요.", style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: "Webhook URL",
                  hintText: "https://api.yourgame.com/webhook/payment",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.webhook),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Webhook URL이 저장되었습니다.")));
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("저장하기"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // A. 대시보드 (Dashboard)
  Widget _buildDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 4. "10분 완성"을 위한 UI 장치 (Onboarding)
        _buildOnboarding(),
        const SizedBox(height: 24),
        
        // 1단: 핵심 지표 (Key Metrics Cards)
        Row(
          children: [
            _buildMetricCard("오늘 매출", "1,500,000", "+10%", Colors.green),
            const SizedBox(width: 16),
            _buildMetricCard("결제 건수", "150 건", "", Colors.black),
            const SizedBox(width: 16),
            _buildMetricCard("정산 가능 금액", "8,900,000", "출금 가능", Colors.blue, showButton: true),
            const SizedBox(width: 16),
            _buildServerStatusCard(),
          ],
        ),
        const SizedBox(height: 24),

        // 2단: 시각화 차트 (Charts)
        SizedBox(
          height: 300,
          child: Row(
            children: [
              Expanded(flex: 7, child: _buildSalesChart()),
              const SizedBox(width: 24),
              Expanded(flex: 3, child: _buildTopItemsChart()),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 3단: 실시간 라이브 (Real-time Feeds)
        _buildRealTimeFeeds(),
      ],
    );
  }

  Widget _buildOnboarding() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.indigo.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("🚀 내 웹샵 오픈까지 2단계 남았습니다! (50%)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo)),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStepChip("계정 생성", true),
              _buildLine(),
              _buildStepChip("상품 1개 등록하기", true), // 진행 중 -> 완료로 가정
              _buildLine(),
              _buildStepChip("웹훅 URL 입력하기", false),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: null, // 비활성화
            child: const Text("👉 내 상점 구경가기 (설정 완료 시 활성화)"),
          )
        ],
      ),
    );
  }

  Widget _buildStepChip(String label, bool isCompleted) {
    return Chip(
      avatar: Icon(isCompleted ? Icons.check_circle : Icons.circle_outlined, color: isCompleted ? Colors.green : Colors.grey),
      label: Text(label),
      backgroundColor: Colors.white,
      side: BorderSide(color: isCompleted ? Colors.green : Colors.grey.shade300),
    );
  }

  Widget _buildLine() {
    return Container(width: 30, height: 2, color: Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 8));
  }

  Widget _buildRealTimeMetrics() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('companyId', isEqualTo: 'dragon_ent')
          .where('status', isEqualTo: 'paid')
          .snapshots(),
      builder: (context, snapshot) {
        // 기본값 (로딩 중이거나 데이터 없을 때)
        int todaySales = 0;
        int totalCount = 0;
        int settlementAmount = 0; // 예: 전체 매출의 90%

        if (snapshot.hasData) {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          
          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final amount = data['amount'] as int? ?? 0;
            final createdAt = (data['createdAt'] as Timestamp?)?.toDate();

            // 오늘 매출 집계
            if (createdAt != null && createdAt.isAfter(today)) {
              todaySales += amount;
              totalCount += 1;
            }
            
            // 정산 가능 금액 (단순 예시: 전체 누적 매출의 90%)
            settlementAmount += (amount * 0.9).round();
          }
        }

        return Row(
          children: [
            _buildMetricCard("오늘 매출", currencyFormat.format(todaySales), "실시간 집계 중", Colors.green),
            const SizedBox(width: 16),
            _buildMetricCard("오늘 결제 건수", "$totalCount 건", "", Colors.black),
            const SizedBox(width: 16),
            _buildMetricCard("정산 가능 금액", currencyFormat.format(settlementAmount), "출금 가능", Colors.blue, showButton: true),
            const SizedBox(width: 16),
            _buildServerStatusCard(),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard(String title, String value, String subText, Color color, {bool showButton = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(subText, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                if (showButton) ...[
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0), minimumSize: const Size(0, 32)),
                    child: const Text("출금", style: TextStyle(fontSize: 12)),
                  )
                ]
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildServerStatusCard() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("서버 연동 상태", style: TextStyle(color: Colors.grey, fontSize: 14)),
            SizedBox(height: 8),
            Text("정상 🟢", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("모든 시스템 가동 중", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("주간 매출 추이", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                    const days = ['월', '화', '수', '목', '금', '토', '일'];
                    if (value.toInt() >= 0 && value.toInt() < days.length) {
                      return Text(days[value.toInt()], style: const TextStyle(color: Colors.grey, fontSize: 12));
                    }
                    return const Text('');
                  })),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [FlSpot(0, 3), FlSpot(1, 4), FlSpot(2, 3.5), FlSpot(3, 5), FlSpot(4, 4.5), FlSpot(5, 6), FlSpot(6, 6.5)],
                    isCurved: true,
                    color: Colors.indigo,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: Colors.indigo.withOpacity(0.1)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopItemsChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("인기 상품 TOP 3", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(color: Colors.blue, value: 40, title: '40%', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  PieChartSectionData(color: Colors.red, value: 30, title: '30%', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  PieChartSectionData(color: Colors.amber, value: 30, title: '30%', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.circle, color: Colors.blue, size: 10), SizedBox(width: 4), Text("다이아 패키지"),
            SizedBox(width: 10),
            Icon(Icons.circle, color: Colors.red, size: 10), SizedBox(width: 4), Text("골드 상자"),
          ]),
        ],
      ),
    );
  }

  Widget _buildRealTimeFeeds() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text("실시간 결제 내역 (Live)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(width: 8),
              Icon(Icons.circle, color: Colors.red, size: 12), // Live indicator
            ],
          ),
          const SizedBox(height: 16),
          _buildLogItem("14:32", "user_kim", "초보자 패키지", "3,300원", true),
          const Divider(),
          _buildLogItem("14:30", "user_lee", "다이아 100개", "1,100원", true),
          const Divider(),
          _buildLogItem("14:28", "user_park", "전설의 검", "55,000원", false),
        ],
      ),
    );
  }

  Widget _buildLogItem(String time, String user, String item, String amount, bool success) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(time, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 16),
          Text(user, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          Text(item),
          const Spacer(),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: success ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(success ? "지급 성공" : "지급 실패", style: TextStyle(color: success ? Colors.green : Colors.red, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  // B. 상점 관리 (Shop Management)
  Widget _buildShopManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("📦 상품 등록", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildTextField("상품명", "예: 전설의 검", _productNameController),
                        const SizedBox(height: 16),
                        _buildTextField("가격 (원)", "예: 33000", _priceController, isNumber: true),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      children: [
                        _buildTextField("이미지 URL", "https://...", _imageUrlController),
                        const SizedBox(height: 16),
                        _buildTextField("게임 아이템 코드", "SWORD_LEGEND_01", _itemCodeController, 
                          helperText: "※ 주의: 게임 서버에 정의된 코드와 정확히 일치해야 합니다",
                          helperColor: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: _addProduct,
                  icon: const Icon(Icons.add),
                  label: const Text("상품 등록하기"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Text("📋 등록된 상품 목록", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 16),
        Expanded(child: _buildProductList()),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {bool isNumber = false, String? helperText, Color? helperColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            helperStyle: helperColor != null ? TextStyle(color: helperColor) : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildProductList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').where('companyId', isEqualTo: 'dragon_ent').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        if (snapshot.data!.docs.isEmpty) return const Center(child: Text("등록된 상품이 없습니다."));

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            var data = doc.data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Image.network(data['imageUrl'] ?? 'https://via.placeholder.com/50', width: 50, height: 50, fit: BoxFit.cover),
                title: Text(data['name']),
                subtitle: Text("${currencyFormat.format(data['price'])} | Code: ${data['gameItemCode']}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    FirebaseFirestore.instance.collection('products').doc(doc.id).delete();
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _addProduct() {
    if (_productNameController.text.isEmpty || _priceController.text.isEmpty || _itemCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("모든 필드를 입력해주세요.")));
      return;
    }

    FirebaseFirestore.instance.collection('products').add({
      'name': _productNameController.text,
      'price': int.parse(_priceController.text),
      'gameItemCode': _itemCodeController.text,
      'imageUrl': _imageUrlController.text.isNotEmpty ? _imageUrlController.text : 'https://via.placeholder.com/150',
      'companyId': 'dragon_ent', // 데모용 고정값
      'createdAt': FieldValue.serverTimestamp(),
    });

    _productNameController.clear();
    _priceController.clear();
    _itemCodeController.clear();
    _imageUrlController.clear();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("상품이 등록되었습니다.")));
  }
}
