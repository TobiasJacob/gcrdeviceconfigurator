import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/channel.dart';

import '../../../data/app_settings.dart';
import '../../../i18n/languages.dart';

class ChannelPage extends StatelessWidget {
  const ChannelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Languages.of(context);
    final channel = Channel.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.editChannel),
      ),
      body: Column(
        children: [
          DropdownButton<Usage>(
            onChanged: (value) => channel.setUsage(value!),
            value: channel.usage,
            items: Usage.values
                .map((e) =>
                    DropdownMenuItem(value: e, child: Text(lang.usage(e))))
                .toList(),
          )
        ],
      ),
    );
  }
}
