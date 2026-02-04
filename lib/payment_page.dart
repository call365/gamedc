import 'package:flutter/material.dart';
import 'package:iamport_flutter/iamport_payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return IamportPayment(
      appBar: AppBar(
        title: const Text('포인트 충전'),
      ),
      // 1. 내 가맹점 식별코드 (포트원 관리자 콘솔에서 확인)
      // 테스트용 가맹점 식별코드: imp19424728 (포트원 문서의 테스트 코드 예시)
      // 실제 사용 시에는 본인의 코드로 교체해야 함
      userCode: 'imp19424728',
      
      // 2. 결제 데이터 설정
      data: PaymentData(
        pg: 'html5_inicis',       // PG사 (KG이니시스 웹표준)
        payMethod: 'card',        // 결제 수단 (카드)
        name: '10,000 포인트 충전', // 주문명
        merchantUid: 'mid_${DateTime.now().millisecondsSinceEpoch}', // 주문번호 (유니크해야 함)
        amount: 10000,            // 결제 금액
        buyerName: '홍길동',
        buyerTel: '01012345678',
        buyerEmail: 'user@example.com',
        appScheme: 'game_web_shop', // 앱 내 결제 후 복귀용 스키마
      ),
      
      // 3. 결제 완료 후 콜백 (성공/실패 처리)
      callback: (Map<String, String> result) {
        if (result['imp_success'] == 'true') {
          // 결제 성공! -> 서버 검증 로직 호출
          print('결제 성공: ${result['imp_uid']}');
          _verifyPayment(context, result['imp_uid'], result['merchant_uid']);
        } else {
          // 결제 실패
          print('결제 실패: ${result['error_msg']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('결제 실패: ${result['error_msg']}')),
          );
          Navigator.pop(context); // 결제창 닫기
        }
      },
    );
  }

  // 서버 검증 함수 (가짜 결제 방지)
  Future<void> _verifyPayment(BuildContext context, String? impUid, String? merchantUid) async {
    // 로컬 에뮬레이터 (game-dtc-webshop 프로젝트) 주소
    // 실제 배포 시에는 Firebase Project ID에 맞는 URL로 변경해야 합니다.
    const String cloudFunctionUrl = 'http://localhost:5001/game-dtc-webshop/us-central1/verifyPayment';
    
    try {
      final response = await http.post(
        Uri.parse(cloudFunctionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'data': { // Cloud Functions onCall format wraps body in 'data'
            'imp_uid': impUid,
            'merchant_uid': merchantUid,
            'amount': 10000,
          }
        }),
      );

      if (response.statusCode == 200) {
         final body = jsonDecode(response.body);
         // onCall returns { result: ... }
         if (body['result'] != null && body['result']['success'] == true) {
             print('검증 성공 & 포인트 지급 완료');
             ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('충전이 완료되었습니다!')),
             );
         } else {
             throw Exception('Verification failed logic');
         }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('검증 에러: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('검증 실패: $e')),
      );
    } finally {
      Navigator.pop(context); // 결제창 닫기
    }
  }
}
