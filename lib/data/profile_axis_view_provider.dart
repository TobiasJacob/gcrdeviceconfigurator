
import 'package:gcrdeviceconfigurator/data/app_settings.dart';
import 'package:gcrdeviceconfigurator/data/profile_axis.dart';
import 'package:gcrdeviceconfigurator/data/profile_view_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final visibleProfileAxisProvider =
    StateNotifierProvider<ProfileAxisProvider, Usage>((ref) {
  return ProfileAxisProvider(ref);
});

class ProfileAxisProvider extends StateNotifier<Usage> {
  final Ref ref;

  ProfileAxisProvider(this.ref) : super(Usage.gas);

  void setVisibleAxis(Usage usage) {
    assert(usage != Usage.none);
    state = usage;
  }

  ProfileAxis get axis {
    return ref.watch(visibleProfileProvider.notifier).profile.axes[state]!;
  }

  void update(ProfileAxis axis) {
    final notif = ref.read(visibleProfileProvider.notifier);
    notif.update(notif.profile.copyWith(axes: {
      ...notif.profile.axes,
      state: axis,
    }));
  }
}