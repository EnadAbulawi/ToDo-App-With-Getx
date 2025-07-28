import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_app_getx/routes/app_routes.dart';
import 'package:todo_app_getx/services/notification_service.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // تحميل بيانات المناطق الزمنية
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Hebron')); // منطقتنا
  // تهيئة الإشعارات
  await NotificationService().init();
  // تسجيل الخدمة في GetX (للاستخدام في الـ Controller)
  Get.put(NotificationService(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.HOME,
      getPages: AppPages.pages,
    );
  }
}
