import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../repositories/profile_repo.dart';

class ProfileViewModel extends StateNotifier<AsyncValue<UserModel?>> {
  final ProfileRepo _profileRepo;

  ProfileViewModel(this._profileRepo) : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    _profileRepo.authStateChanges().listen((user) {
      if (user == null) {
        state = const AsyncValue.data(null); // Clear user data on logout
      } else {
        fetchUserData();
      }
    });
  }

  Future<void> fetchUserData() async {
    try {
      state = const AsyncValue.loading();
      final user = await _profileRepo.fetchUserData();
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final userViewModelProvider =
    StateNotifierProvider<ProfileViewModel, AsyncValue<UserModel?>>((ref) {
  return ProfileViewModel(ProfileRepo());
});
