// lib/views/widgets/category_count_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/todo_controller.dart';

class CategoryCountWidget extends StatefulWidget {
  final TodoController controller;
  const CategoryCountWidget({required this.controller, Key? key})
    : super(key: key);

  @override
  State<CategoryCountWidget> createState() => _CategoryCountWidgetState();
}

class _CategoryCountWidgetState extends State<CategoryCountWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl; // ← للتحكم في الأنيميشن او مدير توقيت الرسوم.
  late Animation<Offset> _offsetAnim; // ← لتحريك الودجت من اليمين لليسار
  late Animation<double> _fadeAnim; // ← لتطبيق تأثير التلاشي

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _offsetAnim = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));

    // تشغيل الأنيميشن عند تحميل الودجت
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: SlideTransition(
        position: _offsetAnim,
        // استخدام FadeTransition لتطبيق تأثير التلاشي
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: widget.controller.categories.length,
            itemBuilder: (_, i) {
              final cat = widget.controller.categories[i];
              final color = widget.controller.categoryColor[cat]!;
              final icon = widget.controller.categoryIcon[cat]!;

              return Card(
                color: color.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(right: 8),
                child: Container(
                  width: 110,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 28, color: color),
                      const SizedBox(height: 6),
                      Text(cat, style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 4),

                      // هنا فقط نغلف العداد داخل Obx
                      Obx(() {
                        final count = widget.controller.todos
                            .where((t) => t.category == cat)
                            .length;
                        return Text(
                          '$count',
                          style: Theme.of(context).textTheme.titleLarge,
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
