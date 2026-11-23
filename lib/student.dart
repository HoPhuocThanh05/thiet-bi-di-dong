import 'package:flutter/material.dart';
 
class Mystudent extends StatelessWidget {
  const Mystudent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Text('Thông tin sinh viên'),
    ),
    body: Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      child: ListTile(
        leading: const CircleAvatar(child: Text('A')),
        title: const Text('ho phuoc thanh'),
        subtitle: const Text('23t1020499@husc.edu.vn'),
        trailing: IconButton(
          onPressed: (){},
           icon: const Icon(Icons.phone)),
      ),
    ),
    );
  }
}