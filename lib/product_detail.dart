import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'cart_screen.dart'; // Import để sử dụng CartManager
import 'product_item.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final bool isDarkMode; // Khai báo nhận trạng thái Dark Mode

  const ProductDetailScreen({
    super.key,
    required this.product,
    this.isDarkMode = false,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  bool _isExpanded = false; // Trạng thái mở rộng/thu gọn mô tả
  bool _isFavorite = false;

  // Dữ liệu chi tiết lấy từ API GET /products/{id}
  late Product _detailProduct;
  late List<String> images;
  Map<String, dynamic>? _apiExtraData;
  bool _isLoadingDetail = true;

  @override
  void initState() {
    super.initState();
    // Khởi tạo tạm bằng dữ liệu truyền từ màn trước để giao diện hiện ngay lập tức
    _detailProduct = widget.product;
    images = [widget.product.imageUrl];

    // Gọi API lấy chi tiết sản phẩm đầy đủ theo ID
    _layChiTietSanPham();
  }

  Future<void> _layChiTietSanPham() async {
    try {
      final dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));
      final response = await dio.get('/products/${widget.product.id}');
      final data = response.data as Map<String, dynamic>;

      // Lấy danh sách ảnh thật (nhiều góc chụp) từ trường 'images'
      final List<String> apiImages = (data['images'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [];

      if (mounted) {
        setState(() {
          _detailProduct = Product.fromJson(data);
          _apiExtraData = data;
          if (apiImages.isNotEmpty) {
            images = apiImages;
          }
          _isLoadingDetail = false;
        });
      }
    } catch (e) {
      print('Lỗi khi gọi API chi tiết sản phẩm: $e');
      if (mounted) {
        setState(() {
          _isLoadingDetail = false;
        });
      }
    }
  }

  // Định dạng giá theo tiền USD ($999.99)
  String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    // QUẢN LÝ MÀU SẮC ĐỒNG BỘ THEO CHẾ ĐỘ TỐI / SÁNG
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final navBarBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.grey.shade600;
    final descTextColor = isDark ? Colors.white70 : Colors.grey.shade800;
    final circleAvatarBg = isDark
        ? Colors.black.withOpacity(0.6)
        : Colors.white.withOpacity(0.85);
    final priceColor = isDark ? Colors.indigoAccent.shade100 : Colors.indigo;
    final accentBlue = isDark ? Colors.indigoAccent : Colors.indigo;

    final List reviews = _apiExtraData?['reviews'] ?? [];

    return Scaffold(
      backgroundColor: bgColor,

      // Thanh hành động cố định ở đáy
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: navBarBg,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                blurRadius: 8,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Nút Thêm vào giỏ
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    CartManager.addToCart(_detailProduct);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Đã thêm ${_detailProduct.name} vào giỏ!',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: accentBlue, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Thêm vào giỏ',
                    style: TextStyle(
                      color: accentBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Nút Mua ngay
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    CartManager.addToCart(_detailProduct);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScreen(isDarkMode: isDark),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Mua ngay',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // CustomScrollView xử lý cuộn toàn màn hình
      body: CustomScrollView(
        slivers: [
          // SliverAppBar: Ảnh co lại thành thanh tiêu đề khi cuộn xuống
          SliverAppBar(
            expandedHeight: 340.0,
            pinned: true,
            backgroundColor: isDark ? const Color(0xFF1F1F1F) : Colors.indigo,

            // Nút quay lại nổi trên ảnh
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: circleAvatarBg,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            // Nút yêu thích nổi trên ảnh
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: circleAvatarBg,
                  child: IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite
                          ? Colors.red
                          : (isDark ? Colors.white70 : Colors.grey.shade700),
                    ),
                    onPressed: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                    },
                  ),
                ),
              ),
            ],

            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Ảnh sản phẩm vuốt ngang từ API
                  PageView.builder(
                    itemCount: images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        color: isDark
                            ? const Color(0xFF2C2C2C)
                            : Colors.grey.shade200,
                        child: Image.network(
                          images[index],
                          fit: BoxFit.contain,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                                child: Icon(
                                  Icons.image,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      );
                    },
                  ),

                  // Dấu chấm chỉ vị trí ảnh đang xem
                  if (images.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(images.length, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentImageIndex == index ? 20 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentImageIndex == index
                                  ? accentBlue
                                  : Colors.grey.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Nội dung chi tiết thông tin sản phẩm
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isLoadingDetail)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: LinearProgressIndicator(minHeight: 2),
                    ),

                  // Nhãn thương hiệu & tình trạng kho từ API
                  if (_apiExtraData != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Wrap(
                        spacing: 8,
                        children: [
                          if (_apiExtraData!['brand'] != null)
                            Chip(
                              label: Text(
                                'Thương hiệu: ${_apiExtraData!['brand']}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: cardBg,
                              visualDensity: VisualDensity.compact,
                            ),
                          if (_apiExtraData!['availabilityStatus'] != null)
                            Chip(
                              label: Text(
                                '${_apiExtraData!['availabilityStatus']} (Còn ${_apiExtraData!['stock'] ?? 0})',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              backgroundColor: Colors.green.withOpacity(0.12),
                              visualDensity: VisualDensity.compact,
                            ),
                        ],
                      ),
                    ),

                  // Tên sản phẩm
                  Text(
                    _detailProduct.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Đánh giá sao
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Icon(
                            Icons.star,
                            size: 18,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_detailProduct.rating} (${reviews.isNotEmpty ? reviews.length : _detailProduct.reviewCount} đánh giá)',
                        style: TextStyle(color: subTextColor, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Giá bán & Giảm giá
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        formatPrice(_detailProduct.price),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: priceColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (_detailProduct.oldPrice > _detailProduct.price) ...[
                        Text(
                          formatPrice(_detailProduct.oldPrice),
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? Colors.grey.shade500
                                : Colors.grey.shade400,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '-${_detailProduct.discountPercent}%',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  ),
                  const SizedBox(height: 8),

                  // Thông tin bảo hành & giao hàng từ API
                  if (_apiExtraData != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.verified_user_outlined,
                                  size: 18, color: accentBlue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Bảo hành: ${_apiExtraData!['warrantyInformation'] ?? '12 tháng chính hãng'}',
                                  style: TextStyle(
                                      fontSize: 13, color: descTextColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.local_shipping_outlined,
                                  size: 18, color: accentBlue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Vận chuyển: ${_apiExtraData!['shippingInformation'] ?? 'Giao hàng nhanh toàn quốc'}',
                                  style: TextStyle(
                                      fontSize: 13, color: descTextColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Phần mô tả chi tiết từ API
                  Text(
                    'Mô tả sản phẩm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _detailProduct.description,
                    maxLines: _isExpanded ? null : 3,
                    overflow: _isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: descTextColor,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(
                      _isExpanded ? 'Thu gọn ▲' : 'Xem thêm ▼',
                      style: TextStyle(
                        color: accentBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  // Danh sách đánh giá của khách hàng từ API DummyJSON
                  if (reviews.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Divider(
                      color:
                          isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Đánh giá từ khách hàng (${reviews.length})',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...reviews.map((rev) {
                      final int stars = (rev['rating'] as num?)?.toInt() ?? 5;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  rev['reviewerName'] ?? 'Khách hàng',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: textColor,
                                  ),
                                ),
                                Row(
                                  children: List.generate(
                                    stars,
                                    (index) => const Icon(
                                      Icons.star,
                                      size: 14,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              rev['comment'] ?? '',
                              style: TextStyle(
                                fontSize: 13,
                                color: descTextColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ], 
      ),
    );
  }
}