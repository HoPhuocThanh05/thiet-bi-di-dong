// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:shop_easy/login.dart';

// // Các bài thực hành cũ (bỏ // để sử dụng)
// // import 'package:shop_easy/counter.dart';
// // import 'package:shop_easy/home_page.dart';
// // import 'package:shop_easy/place.dart';
// // import 'package:shop_easy/profile.dart';

// void main() {
//   runApp(const MyApp());
// }

// class AppScrollBehavior extends MaterialScrollBehavior {
//   @override
//   Set<PointerDeviceKind> get dragDevices => {
//     PointerDeviceKind.touch,
//     PointerDeviceKind.mouse, // Thêm tính năng kéo bằng chuột
//   };
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Shop Easy',
//       theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),

//       // Chọn màn hình chạy ban đầu bằng cách bỏ // ở màn hình tương ứng
//       home: const LoginScreen(),
//       // home: const HomePage(),
//       // home: const Myplace(),
//       // home: const MyCounter(),
//       // home: const Myprofile(),
//       // home: const Myproduct_item(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shop_easy/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShopEasy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
