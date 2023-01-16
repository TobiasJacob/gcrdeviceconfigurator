import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';
import 'package:gcrdeviceconfigurator/usb/usb_status.dart';

import '../../data/database.dart';
import '../../usb/config_serialize.dart';

class UpdateDeviceWidget extends StatelessWidget {
  const UpdateDeviceWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    USBStatus usbStatus = USBStatus.of(context);
    AppSettings appSettings = AppSettings.of(context);
    Database database = Database.of(context);

    return Row(
      children: [
        usbStatus.isConnected ? ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          onPressed: () async {
            debugPrint("${serializeConfig(appSettings, database)}");
            await usbStatus.device.sendSerializedConfig(serializeConfig(appSettings, database));
        }, child: const Text("Upload profile")) : const SizedBox(width: 20.0),
        const SizedBox(width: 8.0),
        Container(
          width: 12.0,
          height: 12.0,
          decoration: BoxDecoration(
            color: usbStatus.isConnected ? Colors.green : Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8.0),
        Text(usbStatus.isConnected ? "Connected" : "No device found"),
      ],
    );
  }
}