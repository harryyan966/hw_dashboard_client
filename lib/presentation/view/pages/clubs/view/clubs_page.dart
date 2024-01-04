import 'package:flutter/widgets.dart';
import 'package:hw_dashboard_client/presentation/view/app_syntax_sugars/build_context.dart';

class ClubsPage extends StatelessWidget {
  const ClubsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.primaryContainer,
      child: Center(
        child: Text(
          'CLUBS',
          style: context.text.titleLarge,
        ),
      ),
    );
  }
}
