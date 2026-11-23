import 'package:flutter/material.dart';

class Myplace extends StatelessWidget {
  const Myplace({super.key});
  String getUrlImage() {
    return "https://images.unsplash.com/photo-1790772038254-1074cd8a8ee8?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [block5(), block1(), block2(), block3(), block4()],
      ),
    );
  }

  Widget block5() {
    return Text("xin chào");
  }

  Widget block1() {
    return Image.network(getUrlImage());
  }

  Widget block2() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("vancouver xinh dep- (Hồ Phước Thành)"),
              Text("Địa chỉ: vancouver, cannada"),
            ],
          ),
          Row(
            children: [
              Icon(Icons.star, color: Colors.red),
              Text("41"),
            ],
          ),
        ],
      ),
    );
  }

  Widget block3() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        iconText(Icons.call, "CALL"),
        iconText(Icons.near_me, "ROUTE"),
        iconText(Icons.share, "SHARE"),
      ],
    );
  }

  Widget block4() {
    return Text(
      "Hồ Oeschinen nằm ở chân núi Blüemlisalp thuộc Dãy Alps Thụy Sĩ.",
    );
  }
}

Widget iconText(IconData icon, String title) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: Colors.blue),
      const SizedBox(height: 8), // Khoảng cách giữa icon và chữ
      Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.blue,
        ),
      ),
    ],
  );
}
