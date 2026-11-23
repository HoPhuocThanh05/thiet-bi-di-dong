import 'package:flutter/material.dart';
import 'package:shop_easy/auth_storage.dart';
import 'package:shop_easy/login.dart';

import 'profile.dart';

class SettingScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool>? onDarkModeChanged;

  const SettingScreen({
    super.key,
    this.isDarkMode = false,
    this.onDarkModeChanged,
  });

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // ===== CÁC BIẾN TRẠNG THÁI =====
  bool isNotification = true, isDarkMode = false, isRemember = true;
  String language = 'Tiếng Việt', fontSize = 'Vừa';

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
  }

  @override
  void didUpdateWidget(covariant SettingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      setState(() {
        isDarkMode = widget.isDarkMode;
      });
    }
  }

  // BỘ TỪ ĐIỂN ĐA NGÔN NGỮ
  final Map<String, Map<String, String>> localizedTexts = {
    'Tiếng Việt': {
      'title': 'Cài đặt',
      'account': 'TÀI KHOẢN',
      'notification': 'Nhận thông báo',
      'darkMode': 'Chế độ tối',
      'rememberLogin': 'Nhớ đăng nhập',
      'app': 'ỨNG DỤNG',
      'language': 'Ngôn ngữ',
      'fontSize': 'Cỡ chữ',
      'aboutApp': 'Về ứng dụng',
      'version': 'Shop Easy\nPhiên bản: 1.0.0',
      'close': 'Đóng',
      'myProfile': 'Hồ sơ của tôi (Hồ Phước Thành)',
      'dummyProfile': 'Tài khoản DummyJSON (API)',
      'logout': 'Đăng xuất',
      'logoutTitle': 'Xác nhận đăng xuất',
      'logoutConfirm': 'Bạn có chắc chắn muốn đăng xuất không?',
      'cancel': 'Hủy',
      'Nhỏ': 'Nhỏ',
      'Vừa': 'Vừa',
      'Lớn': 'Lớn',
    },
    'English': {
      'title': 'Settings',
      'account': 'ACCOUNT',
      'notification': 'Notifications',
      'darkMode': 'Dark Mode',
      'rememberLogin': 'Remember Login',
      'app': 'APPLICATION',
      'language': 'Language',
      'fontSize': 'Font Size',
      'aboutApp': 'About App',
      'version': 'Shop Easy\nVersion: 1.0.0',
      'close': 'Close',
      'myProfile': 'My Profile (Hồ Phước Thành)',
      'dummyProfile': 'DummyJSON Account (API)',
      'logout': 'Logout',
      'logoutTitle': 'Confirm Logout',
      'logoutConfirm': 'Are you sure you want to log out?',
      'cancel': 'Cancel',
      'Nhỏ': 'Small',
      'Vừa': 'Medium',
      'Lớn': 'Large',
    },
    'Tiếng Trung': {
      'title': '设置',
      'account': '账户',
      'notification': '接收通知',
      'darkMode': '深色模式',
      'rememberLogin': '记住登录',
      'app': '应用',
      'language': '语言',
      'fontSize': '字体大小',
      'aboutApp': '关于应用',
      'version': 'Shop Easy\n版本: 1.0.0',
      'close': '关闭',
      'myProfile': '我的个人资料 (Hồ Phước Thành)',
      'dummyProfile': 'DummyJSON 账户 (API)',
      'logout': '退出登录',
      'logoutTitle': '确认退出',
      'logoutConfirm': '您确定要退出登录吗？',
      'cancel': '取消',
      'Nhỏ': '小',
      'Vừa': '中',
      'Lớn': '大',
    },
  };

  String t(String key) => localizedTexts[language]?[key] ?? key;

  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkMode ? const Color(0xFF121212) : Colors.grey.shade100;
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final appBarColor = isDarkMode ? const Color(0xFF1F1F1F) : Colors.blue;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(t('title')),
        backgroundColor: appBarColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          block1(),
          const SizedBox(height: 8),
          block2(cardColor, textColor),
          const SizedBox(height: 20),
          block3(),
          const SizedBox(height: 8),
          block4(cardColor, textColor),
          const SizedBox(height: 28),
          block5(),
        ],
      ),
    );
  }

  Widget block1() => Text(
        t('account'),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      );

  Widget block2(Color cardBg, Color txtColor) => Card(
        color: cardBg,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            _switchTile(
              Icons.notifications_active_outlined,
              Colors.orange,
              t('notification'),
              isNotification,
              txtColor,
              (v) => setState(() => isNotification = v),
            ),
            Divider(
              height: 1,
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
            _switchTile(
              Icons.dark_mode_outlined,
              Colors.indigo,
              t('darkMode'),
              isDarkMode,
              txtColor,
              (v) {
                setState(() => isDarkMode = v);
                if (widget.onDarkModeChanged != null) {
                  widget.onDarkModeChanged!(v);
                }
              },
            ),
            Divider(
              height: 1,
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
            _switchTile(
              Icons.lock_clock_outlined,
              Colors.teal,
              t('rememberLogin'),
              isRemember,
              txtColor,
              (v) => setState(() => isRemember = v),
            ),
          ],
        ),
      );

  Widget block3() => Text(
        t('app'),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      );

  Widget block4(Color cardBg, Color txtColor) => Card(
        color: cardBg,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            _selectTile(
              Icons.language,
              Colors.purple,
              t('language'),
              language,
              ['Tiếng Việt', 'English', 'Tiếng Trung'],
              txtColor,
              (v) => setState(() => language = v),
            ),
            Divider(
              height: 1,
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
            _selectTile(
              Icons.format_size,
              Colors.deepOrange,
              t('fontSize'),
              t(fontSize),
              [t('Nhỏ'), t('Vừa'), t('Lớn')],
              txtColor,
              (v) {
                setState(() {
                  if (v == t('Nhỏ')) fontSize = 'Nhỏ';
                  if (v == t('Vừa')) fontSize = 'Vừa';
                  if (v == t('Lớn')) fontSize = 'Lớn';
                });
              },
            ),
            Divider(
              height: 1,
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.blueGrey),
              title: Text(t('aboutApp'), style: TextStyle(color: txtColor)),
              trailing: Icon(Icons.chevron_right, color: txtColor),
              onTap: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: cardBg,
                  title: Text(t('aboutApp'), style: TextStyle(color: txtColor)),
                  content: Text(t('version'), style: TextStyle(color: txtColor)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(t('close')),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
            // 1. PROFILE CỦA BẠN (Hồ Phước Thành)
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: Text(t('myProfile'), style: TextStyle(color: txtColor)),
              trailing: Icon(Icons.chevron_right, color: txtColor),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Myprofile(
                    isDarkMode: isDarkMode,
                    isDummyJson: false,
                  ),
                ),
              ),
            ),
            Divider(
              height: 1,
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
            // 2. PROFILE TÀI KHOẢN DUMMYJSON (API /auth/me)
            ListTile(
              leading: const Icon(Icons.verified_user, color: Colors.green),
              title: Text(t('dummyProfile'), style: TextStyle(color: txtColor)),
              trailing: Icon(Icons.chevron_right, color: txtColor),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Myprofile(
                    isDarkMode: isDarkMode,
                    isDummyJson: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget block5() => SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: _showLogoutDialog,
          icon: const Icon(Icons.logout),
          label: Text(
            t('logout'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );

  Widget _switchTile(
    IconData icon,
    Color iconColor,
    String title,
    bool val,
    Color txtColor,
    ValueChanged<bool> onChanged,
  ) =>
      SwitchListTile(
        secondary: Icon(icon, color: iconColor),
        title: Text(title, style: TextStyle(color: txtColor)),
        value: val,
        onChanged: onChanged,
      );

  Widget _selectTile(
    IconData icon,
    Color iconColor,
    String title,
    String val,
    List<String> options,
    Color txtColor,
    ValueChanged<String> onSelect,
  ) =>
      ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: TextStyle(color: txtColor)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(val, style: const TextStyle(color: Colors.grey)),
            Icon(Icons.chevron_right, color: txtColor),
          ],
        ),
        onTap: () => showModalBottomSheet(
          context: context,
          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (_) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: txtColor,
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
              ),
              ...options.map(
                (opt) => ListTile(
                  title: Text(opt, style: TextStyle(color: txtColor)),
                  trailing: opt == val
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    onSelect(opt);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      );

  void _showLogoutDialog() => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          title: Text(
            t('logoutTitle'),
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
          ),
          content: Text(
            t('logoutConfirm'),
            style:
                TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(t('cancel')),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                AuthStorage.accessToken = null; // Xóa token khi đăng xuất
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: Text(t('logout')),
            ),
          ],
        ),
      );
}