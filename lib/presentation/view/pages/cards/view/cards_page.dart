import 'package:flutter/widgets.dart';
import 'package:hw_dashboard_client/presentation/view/app_syntax_sugars/build_context.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.tertiaryContainer,
      child: Center(
        child: Text(
          'CARDS',
          style: context.text.titleLarge,
        ),
      ),
    );
  }
}
