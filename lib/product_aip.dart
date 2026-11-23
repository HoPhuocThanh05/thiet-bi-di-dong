import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: ManHinhGoiApi()),
  );
}

class ManHinhGoiApi extends StatefulWidget {
  const ManHinhGoiApi({super.key});

  @override
  State<ManHinhGoiApi> createState() => _ManHinhGoiApiState();
}

class _ManHinhGoiApiState extends State<ManHinhGoiApi> {
  List danhSach = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Khởi động: Gọi thử API')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () async {
                final dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));
                final response = await dio.get(
                  '/products',
                  queryParameters: {'limit': 5},
                );
                final List ketQua = response.data['products'];

                // 1. In dữ liệu ra Terminal
                for (final sp in ketQua) {
                  print('${sp['title']}: ${sp['price']} USD');
                }

                // 2. Cập nhật dữ liệu lên giao diện Web
                setState(() {
                  danhSach = ketQua;
                });
              },
              child: const Text('Gọi API'),
            ),
            const SizedBox(height: 20),
            for (final sp in danhSach)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '${sp['title']}: ${sp['price']} USD',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
