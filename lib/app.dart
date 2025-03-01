import 'package:calorie_diff/providers/macros_providers.dart';
import 'package:calorie_diff/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/core_providers.dart';
import 'landing_screen.dart';
import 'providers/calories_providers.dart';

part 'info_popup.dart';

class CalorieDiffApp extends StatefulHookConsumerWidget {
  const CalorieDiffApp({Key? key}) : super(key: key);

  @override
  ConsumerState<CalorieDiffApp> createState() => _CalorieDiffAppState();
}

class _CalorieDiffAppState extends ConsumerState<CalorieDiffApp>
    with WidgetsBindingObserver {
  _CalorieDiffAppState();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refresh();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(context) {
    final currentPage = useState(0);
    final pageViewController = ref.watch(pageViewControllerProvider);

    useEffect(() {
      pageViewController.addListener(() {
        currentPage.value = pageViewController.page!.round();
      });
      return () => pageViewController.dispose();
    }, [pageViewController]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calorie Diff'),
        leading: IconButton(
          onPressed: () => _showAboutDialog(context),
          icon: const Icon(Icons.info_outline),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refresh(),
          ),
        ],
        backgroundColor: AppTheme.barColor,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: const LandingScreen(),
      ),
      bottomNavigationBar: SizedBox(
        height: 120,
        child: BottomNavigationBar(
          enableFeedback: true,
          backgroundColor: AppTheme.barColor,
          currentIndex: currentPage.value,
          selectedItemColor: Colors.white,
          unselectedItemColor: AppTheme.blueGrey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.today),
              label: 'Current',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Historic',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          onTap: ref.read(pageViewControllerProvider).jumpToPage,
        ),
      ),
    );
  }

  void _refresh() {
    ref.invalidate(healthCaloriesProvider);
    ref.invalidate(healthMacrosProvider);

    final shouldRefresh = ref.refresh(didLaunchTodayProvider);
    if (!shouldRefresh) {
      ref.invalidate(historicHealthDataProvider);
      ref.read(setLastLaunchProvider);
    }
  }
}
