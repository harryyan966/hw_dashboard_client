import 'package:flutter/widgets.dart';
import 'package:hw_dashboard_client/presentation/view/app_syntax_sugars/build_context.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.secondaryContainer,
      child: Center(
        child: Text(
          'COURSES',
          style: context.text.titleLarge,
        ),
      ),
    );
  }
}
