import 'package:balancika_demo/data/menu_data.dart';
import 'package:balancika_demo/screens/main_shell.dart';
import 'package:balancika_demo/state/app_scope.dart';
import 'package:balancika_demo/state/app_store.dart';
import 'package:balancika_demo/theme/app_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(BalancikaApp(store: AppStore(seedOrders: seedOrders())));
}

class BalancikaApp extends StatelessWidget {
  const BalancikaApp({super.key, required this.store});

  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      store: store,
      child: MaterialApp(
        title: 'Balancika Demo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const MainShell(),
      ),
    );
  }
}
