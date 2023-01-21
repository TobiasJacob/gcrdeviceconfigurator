
import 'package:gcrdeviceconfigurator/data/channel.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final visibleChannelProvider =
    StateNotifierProvider<ChannelAxisProvider, int>((ref) {
  return ChannelAxisProvider(ref);
});

class ChannelAxisProvider extends StateNotifier<int> {
  final Ref ref;

  ChannelAxisProvider(this.ref) : super(0);

  void setVisibleChannel(int channel) {
    assert(channel >= 0 && channel < ref.read(settingsProvider).channelSettings.length);
    state = channel;
  }

  Channel get channel {
    return ref.watch(settingsProvider.select((settings) => settings.channelSettings[state]));
  }

  void update(Channel channel) {
    final notif = ref.read(settingsProvider.notifier);
    notif.update(notif.state.updateChannel(state, channel));
  }
}