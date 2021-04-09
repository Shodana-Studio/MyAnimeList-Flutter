import 'package:hooks_riverpod/hooks_riverpod.dart';

final textProvider = Provider<String>((ref) => "Hello");

final futureProvider = FutureProvider<int>((ref) async {
  await Future.delayed(Duration(seconds: 2));
  return 5;
});
