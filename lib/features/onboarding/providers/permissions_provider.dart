import 'package:flutter_riverpod/flutter_riverpod.dart';

class PermissionsState {
  const PermissionsState({
    this.notificationsGranted = false,
    this.cameraGranted = false,
  });

  final bool notificationsGranted;
  final bool cameraGranted;

  PermissionsState copyWith({bool? notificationsGranted, bool? cameraGranted}) {
    return PermissionsState(
      notificationsGranted: notificationsGranted ?? this.notificationsGranted,
      cameraGranted: cameraGranted ?? this.cameraGranted,
    );
  }
}

class PermissionsNotifier extends StateNotifier<PermissionsState> {
  PermissionsNotifier() : super(const PermissionsState());

  void setNotificationsGranted({required bool granted}) {
    state = state.copyWith(notificationsGranted: granted);
  }

  void setCameraGranted({required bool granted}) {
    state = state.copyWith(cameraGranted: granted);
  }
}

final permissionsProvider =
    StateNotifierProvider<PermissionsNotifier, PermissionsState>(
      (ref) => PermissionsNotifier(),
    );
