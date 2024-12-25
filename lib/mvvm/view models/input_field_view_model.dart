import 'package:flutter_riverpod/flutter_riverpod.dart';

class InputFieldViewModel extends StateNotifier<Map<String, bool>> {
  InputFieldViewModel() : super({});
  void toggle(String fieldKey) {
    state = {...state, fieldKey: !(state[fieldKey] ?? false)};
  }

  bool getVisibility(String fieldKey) {
    return state[fieldKey] ?? false;
  }
}

final inputFieldProvider =
    StateNotifierProvider<InputFieldViewModel, Map<String, bool>>((ref) {
  return InputFieldViewModel();
});
