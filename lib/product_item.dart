import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shop_easy/setting.dart';
import 'package:shop_easy/auth_storage.dart';
import 'package:shop_easy/profile.dart';

import 'product_detail.dart';
import 'cart_screen.dart';

// ==========================================
// 1. MODEL DỮ LIỆU SẢN PHẨM (Có thêm fromJson)
// ==========================================
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double oldPrice;
  final double rating;
  final int reviewCount;
  final int discountPercent;
  final String imageUrl;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.reviewCount,
    required this.discountPercent,
    required this.imageUrl,
    this.description =
        'Sản phẩm chính hãng, đầy đủ bảo hành và ưu đãi kèm theo.',
  });

  // Việt hóa tên danh mục từ DummyJSON cho đẹp giao diện
  static String _mapCategoryName(String rawCategory) {
    switch (rawCategory) {
      case 'smartphones':
        return 'Điện thoại';
      case 'laptops':
        return 'Laptop';
      case 'mobile-accessories':
        return 'Phụ kiện';
      case 'tablets':
        return 'Máy tính bảng';
      default:
        return rawCategory;
    }
  }

  // Chuyển đổi từ JSON của DummyJSON sang đối tượng Product (Giữ nguyên giá USD)
  factory Product.fromJson(Map<String, dynamic> json) {
    final double usdPrice = (json['price'] as num).toDouble();
    final double discountPct =
        (json['discountPercentage'] as num?)?.toDouble() ?? 0.0;

    // Tính lại giá gốc USD trước khi giảm
    final double usdOldPrice = discountPct > 0
        ? usdPrice / (1 - discountPct / 100)
        : usdPrice;

    final List reviews = json['reviews'] ?? [];

    return Product(
      id: json['id'].toString(),
      name: json['title'] ?? 'Sản phẩm',
      category: _mapCategoryName(json['category'] ?? 'Khác'),
      price: usdPrice,
      oldPrice: usdOldPrice,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      reviewCount: reviews.isNotEmpty ? reviews.length * 120 : 150,
      discountPercent: discountPct.round(),
      imageUrl: json['thumbnail'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

// ==========================================
// 2. MÀN HÌNH CHÍNH (Chứa Trang chủ & Cài đặt)
// ==========================================
class Myproduct_item extends StatefulWidget {
  const Myproduct_item({super.key});

  @override
  State<Myproduct_item> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<Myproduct_item> {
  List<String> categories = [
    'Tất cả',
    'Điện thoại',
    'Laptop',
    'Phụ kiện',
    'Máy tính bảng',
  ];
  String selectedCategory = 'Tất cả';
  String searchQuery = '';
  int currentNavIndex = 0;

  // BIẾN TRẠNG THÁI CHẾ ĐỘ TỐI LƯU TẠI MÀN CHÍNH
  bool isDarkMode = false;

  // BIẾN LƯU THÔNG TIN USER TỪ API /auth/me
  // ignore: unused_field
  Map<String, dynamic>? _userInfo;

  // DANH SÁCH SẢN PHẨM LẤY TỪ API DUMMYJSON
  List<Product> products = [];
  bool _isLoadingProducts = true;

  @override
  void initState() {
    super.initState();
    _layThongTinUser(); // Gọi /auth/me lấy Avatar
    _layDanhSachSanPham(); // Gọi API lấy danh sách đồ công nghệ
  }

  // Gọi GET /auth/me kèm Authorization: Bearer <accessToken>
  Future<void> _layThongTinUser() async {
    final token = AuthStorage.accessToken;
    if (token == null) return;

    try {
      final dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));
      final response = await dio.get(
        '/auth/me',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (mounted) {
        setState(() {
          _userInfo = response.data;
        });
      }
    } catch (e) {
      print('Lỗi khi gọi /auth/me: $e');
    }
  }

  // Gọi API DummyJSON lấy đúng các sản phẩm công nghệ (iPhone, MacBook, Samsung, Phụ kiện...)
  Future<void> _layDanhSachSanPham() async {
    try {
      final dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));

      final responses = await Future.wait([
        dio.get('/products/category/smartphones'), // lấy sản phẩm điện thoại
        dio.get('/products/category/laptops'), // lấy sản phẩm laptop
        dio.get('/products/category/mobile-accessories'),
        dio.get('/products/category/tablets'),
      ]);

      final List<Product> loadedProducts = [];
      for (var res in responses) {
        final List danhSachJson = res.data['products'];
        loadedProducts.addAll(
          danhSachJson.map((json) => Product.fromJson(json)).toList(),
        );
      }

      if (mounted) {
        setState(() {
          products = loadedProducts;
          _isLoadingProducts = false;
        });
      }
    } catch (e) {
      print('Lỗi khi tải danh sách sản phẩm: $e');
      if (mounted) {
        setState(() {
          _isLoadingProducts = false;
        });
      }
    }
  }

  List<Product> get filteredProducts {
    return products.where((product) {
      final matchesCategory =
          selectedCategory == 'Tất cả' || product.category == selectedCategory;
      final matchesSearch = product.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _goToCart() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(isDarkMode: isDarkMode),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final appBarColor = isDarkMode ? const Color(0xFF1F1F1F) : Colors.indigo;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: currentNavIndex == 2
          ? null
          : AppBar(
              backgroundColor: appBarColor,
              foregroundColor: Colors.white,
              title: const Text(
                'ShopEasy',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                Badge(
                  label: Text('${CartManager.totalCount}'),
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: _goToCart,
                  ),
                ),
                const SizedBox(width: 8),
                // AVATAR TRÒN NHỎ Ở GÓC PHẢI APPBAR -> MỞ PROFILE HỒ PHƯỚC THÀNH
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Myprofile(
                            isDarkMode: isDarkMode,
                            isDummyJson: true,
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      // backgroundImage: _userInfo != null && _userInfo!['image'] != null
                      //     ? NetworkImage(_userInfo!['image'])
                      //     : null,
                      // child: _userInfo == null
                      //     ? const Icon(Icons.person, size: 18, color: Colors.indigo)
                      //     : null,
                      backgroundImage: const NetworkImage(
                        r'https://scontent.fhan14-1.fna.fbcdn.net/v/t39.30808-6/349529209_206022635602234_4292033358076510964_n.jpg?stp=dst-jpg_tt6&cstp=mx720x960&ctp=s720x960&_nc_cat=101&_nc_map=urlgen_bucketless&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeFCW8ZJ2T_isPDvauhiR3EQyZDtBKonGFLJkO0EqicYUgNX3Ec8Dp8EzDxDLrjkC5qX3Eg5zEqbUSiTJE5fCw5W&_nc_ohc=JP5lCOhICNoQ7kNvwFmcMYR&_nc_oc=AdpvV2oXgwFHrkWkdG9rr68z6OxL6xAyjr_KM_pedN7qtAsguUeFB85QqKXeM5PycWBTmZ3LsKA2zDn4EDwP1uk8&_nc_zt=23&_nc_ht=scontent.fhan14-1.fna&_nc_gid=33MCjS0zK1A9UpBOQG7xgw&_nc_ss=7b2a8&oh=00_AQSezxMVBY_mMSWnZTUBwabLBviT8cv7kx4xe8yrrE71_w&oe=6B086396',
                      ),
                    ),
                  ),
                ),
              ],
            ),

      body: currentNavIndex == 2
          ? SettingScreen(
              isDarkMode: isDarkMode,
              onDarkModeChanged: (val) {
                setState(() {
                  isDarkMode = val;
                });
              },
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    style: TextStyle(color: textColor),
                    onChanged: (value) => setState(() => searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Tìm sản phẩm...',
                      hintStyle: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.grey,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: isDarkMode ? Colors.white : Colors.grey,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      filled: true,
                      fillColor: isDarkMode
                          ? const Color(0xFF2C2C2C)
                          : Colors.grey.shade100,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((category) {
                        final isSelected = selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            selectedColor: Colors.indigo,
                            backgroundColor: isDarkMode
                                ? const Color(0xFF2C2C2C)
                                : Colors.grey.shade200,
                            checkmarkColor: Colors.white,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : (isDarkMode
                                        ? Colors.white
                                        : Colors.black87),
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onSelected: (bool selected) =>
                                setState(() => selectedCategory = category),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _isLoadingProducts
                        ? const Center(child: CircularProgressIndicator())
                        : filteredProducts.isEmpty
                            ? Center(
                                child: Text(
                                  'Không tìm thấy sản phẩm!',
                                  style: TextStyle(color: textColor),
                                ),
                              )
                            : GridView.builder(
                                itemCount: filteredProducts.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.58,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                    ),
                                itemBuilder: (context, index) {
                                  return ProductItem(
                                    product: filteredProducts[index],
                                    isDarkMode: isDarkMode,
                                    onCartUpdated: () => setState(() {}),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),

      bottomNavigationBar: NavigationBar(
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : null,
        indicatorColor: isDarkMode ? Colors.indigo.shade700 : null,
        selectedIndex: currentNavIndex,
        onDestinationSelected: (int index) {
          if (index == 1) {
            _goToCart();
          } else {
            setState(() {
              currentNavIndex = index;
            });
          }
        },
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: isDarkMode ? Colors.white70 : null,
            ),
            selectedIcon: const Icon(Icons.home, color: Colors.white),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.shopping_cart,
              color: isDarkMode ? Colors.white70 : null,
            ),
            selectedIcon: const Icon(Icons.shopping_cart, color: Colors.white),
            label: 'Giỏ hàng',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.settings,
              color: isDarkMode ? Colors.white70 : null,
            ),
            selectedIcon: const Icon(Icons.settings, color: Colors.white),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }
}


// ==========================================
// 3. WIDGET THẺ SẢN PHẨM ĐƠN LẺ
// ==========================================
class ProductItem extends StatelessWidget {
  final Product product;
  final bool isDarkMode;
  final VoidCallback? onCartUpdated;

  const ProductItem({
    super.key,
    required this.product,
    this.isDarkMode = false,
    this.onCartUpdated,
  });

  // Định dạng giá theo tiền USD ($999.99)
  String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final txtColor = isDarkMode ? Colors.white : Colors.black87;

    return Card(
      color: cardBg,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductDetailScreen(product: product, isDarkMode: isDarkMode),
            ),
          );
          if (onCartUpdated != null) onCartUpdated!();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: isDarkMode
                        ? const Color(0xFF2C2C2C)
                        : Colors.grey.shade200,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image, size: 40, color: Colors.grey),
                    ),
                  ),
                  if (product.discountPercent > 0)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${product.discountPercent}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      radius: 13,
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.grey,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      color: txtColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Icon(
                            Icons.star,
                            size: 12,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${product.rating} (${product.reviewCount > 999 ? "${(product.reviewCount / 1000).toStringAsFixed(1)}k" : product.reviewCount})',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDarkMode
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    children: [
                      Text(
                        formatPrice(product.price),
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.indigoAccent.shade100
                              : Colors.indigo,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      if (product.oldPrice > product.price)
                        Text(
                          formatPrice(product.oldPrice),
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 9,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 28,
                    child: ElevatedButton(
                      onPressed: () {
                        CartManager.addToCart(product);
                        if (onCartUpdated != null) onCartUpdated!();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Đã thêm ${product.name} vào giỏ!'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Thêm vào giỏ',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}