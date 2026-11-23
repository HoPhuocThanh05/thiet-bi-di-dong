import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shop_easy/auth_storage.dart';


class Myprofile extends StatefulWidget {
  final bool isDarkMode;
  final bool isDummyJson; // true: lấy từ API DummyJSON | false: thông tin của bạn

  const Myprofile({
    super.key,
    this.isDarkMode = false,
    this.isDummyJson = true, // Mặc định là true (khi bấm từ Avatar góc AppBar)
  });

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  Map<String, dynamic>? _userData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Chỉ gọi API khi mở Profile của DummyJSON
    if (widget.isDummyJson) {
      _layThongTinCaNhan();
    }
  }

  Future<void> _layThongTinCaNhan() async {
    final token = AuthStorage.accessToken;
    if (token == null) return;

    setState(() => _isLoading = true);

    try {
      final dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));
      final response = await dio.get(
        '/auth/me',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (mounted) {
        setState(() {
          _userData = response.data;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Lỗi tải profile: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey[100],
      appBar: AppBar(
        title: Text(
          widget.isDummyJson ? 'Tài khoản DummyJSON' : 'Hồ sơ cá nhân',
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? const Color(0xFF1F1F1F) : Colors.white, // màu nền
        foregroundColor: isDarkMode ? Colors.white : Colors.black, // màu chữ vs nút back
        elevation: 0.5,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Card(
                  color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white, // màu bên trong profile nưa duói
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      block1(),
                      const SizedBox(height: 48),
                      block2(),
                      block3(),
                      block4(),
                      const SizedBox(height: 16),
                      block6(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget block1() {
    const double coverHeight = 100.0;
    const double avatarRadius = 36.0;
    final isDarkMode = widget.isDarkMode;

    // Ảnh bìa cho Hồ sơ cá nhân của bạn
    const String myCoverUrl =
        'https://images.unsplash.com/photo-1557683316-973673baf926?q=80&w=1740&auto=format&fit=crop';

    // Ảnh bìa riêng cho tài khoản DummyJSON (thay link ảnh khác tại đây nếu muốn)
    const String dummyCoverUrl =
        'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?q=80&w=1740&auto=format&fit=crop';

    final String coverUrl = widget.isDummyJson ? dummyCoverUrl : myCoverUrl;

    // Ảnh đại diện của bạn vs Ảnh từ DummyJSON
    const String myAvatarUrl =
        'https://scontent.fdad3-4.fna.fbcdn.net/v/t39.30808-6/349529209_206022635602234_4292033358076510964_n.jpg?stp=dst-jpg_tt6&cstp=mx720x960&ctp=s720x960&_nc_cat=101&_nc_map=urlgen_bucketless&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeFCW8ZJ2T_isPDvauhiR3EQyZDtBKonGFLJkO0EqicYUgNX3Ec8Dp8EzDxDLrjkC5qX3Eg5zEqbUSiTJE5fCw5W&_nc_ohc=vDXst1DeNAAQ7kNvwEHVE-Y&_nc_oc=AdqIRU1B8I3_1DYJ5Pj5EZjzA3sP7hCkx9hpyDJe7HBOEN7sTGCg29hDJcDKqeCuRwk&_nc_zt=23&_nc_ht=scontent.fdad3-4.fna&_nc_gid=EI1-5FIQfguesg-lK61cOQ&_nc_ss=7a2a8&oh=00_AQSBJBZBFRb8WzfgkUYGSb4X3pVen5G3HHiSlI0MSf7MxA&oe=6B0436D6';

    final String avatarUrl = widget.isDummyJson
        ? (_userData?['image'] ?? 'https://dummyjson.com/icon/emilys/128')
        : myAvatarUrl;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: coverHeight,
          width: double.infinity,
          child: Image.network(
            coverUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: Colors.indigo),
          ),
        ),
        Positioned(
          top: coverHeight - avatarRadius,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white, // màu vòng tròn ảnh đai jdieenj
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundColor: Colors.blue, // màu nền khi chua có ảnh đại diện
              backgroundImage: NetworkImage(avatarUrl),
            ),
          ),
        ),
      ],
    );
  }

  Widget block2() { 
    final isDarkMode = widget.isDarkMode;

    final fullName = widget.isDummyJson
        ? (_userData != null
            ? '${_userData!['firstName']} ${_userData!['lastName']}'
            : 'Chưa đăng nhập')
        : 'Hồ Phước Thành';

    final subText = widget.isDummyJson
        ? (_userData?['email'] ?? 'Vui lòng đăng nhập')
        : '23T1020499';

    return Column(
      children: [
        Text(
          fullName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87, // màu chữ dưới ảnh đại diện
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subText,
          style: TextStyle(
            fontSize: 13,
            color: isDarkMode ? Colors.white70 : Colors.grey[600], // màu chữ dưới tên
          ),
        ),
      ],
    );
  }

  Widget block3() {
    final isDarkMode = widget.isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Divider(
        height: 1,
        color: isDarkMode ? Colors.grey[800] : Colors.grey[300], // màu đường gạch
      ),
    );
  }

  Widget block4() {
    if (!widget.isDummyJson) {
      // Chỉ số gốc của bạn
      return Row(
        children: [
          Expanded(child: block5('128', 'Bài viết')),
          Expanded(child: block5('1.2k', 'Người theo dõi')),
          Expanded(child: block5('450', 'Đang theo dõi')),
        ],
      );
    }

    // Chỉ số thật từ DummyJSON
    final username = _userData != null ? '#${_userData!['id']}' : '--';
    final age = _userData != null ? '${_userData!['age']}' : '--';
    final gender = _userData != null ? '${_userData!['gender']}' : '--';

    return Row(
      children: [
        Expanded(child: block5(username, 'ID Tài khoản')),
        Expanded(child: block5(age, 'Tuổi')),
        Expanded(child: block5(gender, 'Giới tính')),
      ],
    );
  }

  Widget block5(String value, String label) {
    final isDarkMode = widget.isDarkMode;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87, // màu 29
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode ? Colors.white70 : Colors.grey[600], //màu tuổi
          ),
        ),
      ],
    );
  }

  Widget block6() {
    final isDarkMode = widget.isDarkMode;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Hàng 2 nút Theo dõi & Nhắn tin (hiện cho cả DummyJSON lẫn Profile cá nhân)
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Theo dõi'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDarkMode ? Colors.white : Colors.black87, // màu chữ nhắn tin
                    side: BorderSide(
                      color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!, // viền nhắn tin
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Nhắn tin'),
                ),
              ),
            ],
          ),

          // Nếu là Profile DummyJSON thì hiện thêm nút Đăng xuất bên dưới
         
        ],
      ),
    );
  }
}