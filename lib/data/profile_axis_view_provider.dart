import 'package:gcrdeviceconfigurator/data/profile.dart';
import 'package:gcrdeviceconfigurator/data/profile_axis.dart';
import 'package:gcrdeviceconfigurator/data/profile_view_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final axisIdProvider = StateProvider((ref) => ProfileAxisType.gas);

final axisProvider = Provider<ProfileAxis>((ref) {
  final axisId = ref.watch(axisIdProvider);
  final profile = ref.watch(profileProvider);
  return profile.axes[axisId]!;
});
