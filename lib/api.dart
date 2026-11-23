import 'package:dio/dio.dart';

// Khai báo dio dùng chung với địa chỉ gốc (baseUrl)
final dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));

void main() async {
  print('--- 1. Lấy một sản phẩm ---');
  await layMotSanPham();

  print('\n--- 2. Tìm kiếm sản phẩm (queryParameters) ---');
  await timKiemSanPham();

  print('\n--- 3. Gọi nhiều API với baseUrl ---');
  await goiCacApiKhac();
}

// Bài 1: Lấy 1 sản phẩm
Future<void> layMotSanPham() async {
  final response = await dio.get('/products/1');

  print(response.statusCode); // 200
  print(response.data['title']); // Essence Mascara Lash Princess
  print(response.data['price']); // 9.99
}

// Bài 2 (trái): Dùng queryParameters
Future<void> timKiemSanPham() async {
  final response = await dio.get(
    '/products/search',
    queryParameters: {'q': 'phone', 'limit': 10},
  );

  print('Số sản phẩm tìm thấy: ${response.data['total']}');
  print('Sản phẩm đầu tiên: ${response.data['products'][0]['title']}');
}

// Bài 2 (phải): Gọi rút gọn nhờ baseUrl
Future<void> goiCacApiKhac() async {
  final res1 = await dio.get('/products');
  print('Status /products: ${res1.statusCode}');

  final res2 = await dio.get('/products/1');
  print('Tên SP 1: ${res2.data['title']}');

  // Bọc try-catch cho /auth/me vì API này cần đăng nhập mới có quyền truy cập
  try {
    await dio.get('/auth/me');
  } catch (e) {
    print('Gọi /auth/me báo lỗi 401 (Do chưa có token đăng nhập)');
  }
}
