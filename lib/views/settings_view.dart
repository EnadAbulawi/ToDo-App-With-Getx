import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/preferences_service.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = Get.find<PreferencesService>();
    final currentTheme = prefs.getThemeMode();
    final currentLocale = prefs.getLocale();
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // تبديل الثيم
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text('theme'.tr),
                subtitle: Text(
                  currentTheme == ThemeMode.dark ? 'dark'.tr : 'light'.tr,
                ),

                trailing: PopupMenuButton<ThemeMode>(
                  onSelected: (mode) {
                    prefs.setThemeMode(mode);
                    Get.changeThemeMode(mode);
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: ThemeMode.system,
                      child: Text('system'.tr),
                    ),
                    PopupMenuItem(
                      value: ThemeMode.light,
                      child: Text('light'.tr),
                    ),
                    PopupMenuItem(
                      value: ThemeMode.dark,
                      child: Text('dark'.tr),
                    ),
                  ],
                  child: const Icon(Icons.palette),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text('language'.tr),
                subtitle: Text(
                  currentLocale.languageCode == 'ar' ? 'العربية' : 'English',
                ),
                trailing: PopupMenuButton<Locale>(
                  onSelected: (local) {
                    prefs.setLocale(local);
                    Get.updateLocale(local);
                  },

                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: const Locale('en'),
                      child: Text('English'),
                    ),
                    PopupMenuItem(
                      value: const Locale('ar'),
                      child: Text('العربية'),
                    ),
                  ],
                  child: const Icon(Icons.language),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
