import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_app_getx/routes/app_routes.dart';
import 'package:todo_app_getx/services/notification_service.dart';
import 'package:todo_app_getx/services/storage_service.dart';
import 'package:todo_app_getx/translations/app_translations.dart';
import 'routes/app_pages.dart';
import 'services/preferences_service.dart';
import 'theme/app_theme.dart';

late final PreferencesService prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // تهيئة الوضع المظلم حسب التفضيلات
  prefs = PreferencesService();

  // StorageService().clearTodos();
  // تحميل بيانات المناطق الزمنية
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Hebron')); // منطقتنا
  // تهيئة الإشعارات
  await NotificationService().init();
  // تسجيل الخدمة في GetX (للاستخدام في الـ Controller)
  Get.put(NotificationService(), permanent: true);
  Get.put(StorageService(), permanent: true);
  Get.put(prefs, permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final initialLocale = prefs.getLocale();
    final initialTheme = prefs.getThemeMode();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: initialLocale,
      fallbackLocale: const Locale('en'),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: initialTheme, // استخدم الوضع الافتراضي للنظام
      initialRoute: AppRoutes.HOME,
      getPages: AppPages.pages,
    );
  }
}
