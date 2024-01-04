import 'package:flutter/widgets.dart';
import 'package:hw_dashboard_client/presentation/view/app_syntax_sugars/build_context.dart';

class LeavesPage extends StatelessWidget {
  const LeavesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.secondaryContainer,
      child: Center(
        child: Text(
          'LEAVES',
          style: context.text.titleLarge,
        ),
      ),
    );
  }
}
