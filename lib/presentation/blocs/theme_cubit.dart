import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false); // false = светлая тема по умолчанию

  void toggleTheme() {
    emit(!state); // Переключаем между true (темная) и false (светлая)
  }
}
