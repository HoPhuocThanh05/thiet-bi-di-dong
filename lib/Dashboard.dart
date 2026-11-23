import 'package:flutter/material.dart';
import 'package:shop_easy/product_item.dart';

// Thay 'product_item.dart' bằng tên file sản phẩm thực tế của bạn
// import 'product_item.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Hàm tạo từng ô số liệu có sự kiện click (onTap)
  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(icon, color: color, size: 22),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm tạo từng dòng đơn hàng có sự kiện click (onTap)
  Widget _buildOrderItem({
    required BuildContext context,
    required String id,
    required String customer,
    required String total,
    required String status,
    required Color statusColor,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.shade50,
          child: const Icon(Icons.receipt_long, color: Colors.indigo),
        ),
        title: Row(
          children: [
            Text(id, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Row(
            children: [
              Text(customer, style: TextStyle(color: Colors.grey[600])),
              const Spacer(),
              Text(
                total,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            title: Text('Tổng quan'),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),

          // 1 & 2. Bốn ô số liệu (Grid 2 hoặc 4 cột)
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;

                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: constraints.maxWidth > 600 ? 1.5 : 1.3,
                    children: [
                      _buildStatCard(
                        context: context,
                        title: 'Đơn hàng',
                        value: '1,250',
                        icon: Icons.shopping_bag,
                        color: Colors.blue,
                        onTap: () {},
                      ),
                      _buildStatCard(
                        context: context,
                        title: 'Doanh thu',
                        value: '85.4M',
                        icon: Icons.attach_money,
                        color: Colors.green,
                        onTap: () {},
                      ),
                      _buildStatCard(
                        context: context,
                        title: 'Khách hàng',
                        value: '3,420',
                        icon: Icons.people,
                        color: Colors.orange,
                        onTap: () {},
                      ),
                      // Khi bấm vào ô "Sản phẩm" -> Chuyển sang ProductItemScreen
                      _buildStatCard(
                        context: context,
                        title: 'Sản phẩm',
                        value: '450',
                        icon: Icons.inventory_2,
                        color: Colors.purple,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Myproduct_item(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // 3. Tiêu đề mục có nút "Xem tất cả"
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  const Text(
                    'Đơn hàng gần đây',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductItemScreen(),
                        ),
                      );
                    },
                    child: const Text('Xem tất cả'),
                  ),
                ],
              ),
            ),
          ),

          // 4. Danh sách đơn hàng gần đây
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildOrderItem(
                    context: context,
                    id: '#ORD-9521',
                    customer: 'Nguyễn Văn A',
                    total: '1.250.000 đ',
                    status: 'Đã giao',
                    statusColor: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductItemScreen(),
                        ),
                      );
                    },
                  ),
                  _buildOrderItem(
                    context: context,
                    id: '#ORD-9522',
                    customer: 'Trần Thị B',
                    total: '450.000 đ',
                    status: 'Đang giao',
                    statusColor: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductItemScreen(),
                        ),
                      );
                    },
                  ),
                  _buildOrderItem(
                    context: context,
                    id: '#ORD-9523',
                    customer: 'Lê Văn C',
                    total: '2.100.000 đ',
                    status: 'Chờ xử lý',
                    statusColor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductItemScreen(),
                        ),
                      );
                    },
                  ),
                  _buildOrderItem(
                    context: context,
                    id: '#ORD-9524',
                    customer: 'Phạm Thị D',
                    total: '890.000 đ',
                    status: 'Đã hủy',
                    statusColor: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductItemScreen(),
                        ),
                      );
                    },
                  ),
                  _buildOrderItem(
                    context: context,
                    id: '#ORD-9525',
                    customer: 'Hoàng Văn E',
                    total: '3.400.000 đ',
                    status: 'Đã giao',
                    statusColor: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductItemScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

// Màn hình mẫu ProductItemScreen (Bạn có thể bỏ Class này nếu đã import file product_item.dart riêng)
class ProductItemScreen extends StatelessWidget {
  const ProductItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết Sản phẩm'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Màn hình sản phẩm (Product Item)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
