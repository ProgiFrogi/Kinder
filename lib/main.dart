import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder/di/dependency_injection.dart';
import 'package:kinder/presentation/blocs/theme_cubit.dart';
import 'package:kinder/presentation/screens/home_screen.dart';

void main() {
  setupDependencies();
  runApp(const KinderApp());
}

class KinderApp extends StatelessWidget {
  const KinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDarkMode) {
          return MaterialApp(
            title: 'Kinder',
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.indigo,
              scaffoldBackgroundColor: Colors.grey[100],
              appBarTheme: const AppBarTheme(
                elevation: 4,
                color: Colors.indigo,
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.indigo,
              scaffoldBackgroundColor: Colors.grey[900],
              appBarTheme: const AppBarTheme(
                elevation: 4,
                color: Colors.indigo,
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: HomeScreen(
              toggleTheme: () => context.read<ThemeCubit>().toggleTheme(),
              isDarkMode: isDarkMode,
            ),
          );
        },
      ),
    );
  }
}
