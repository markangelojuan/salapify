import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'guest_controller.g.dart';

@Riverpod(keepAlive: true)
class GuestMode extends _$GuestMode {
  @override
  bool build() => false;

  void enable() => state = true;
  void disable() => state = false;
}