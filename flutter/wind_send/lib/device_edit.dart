import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
// import 'package:filesaverz/filesaverz.dart';
import 'dart:io' show Platform;

import 'cnf.dart';
import 'language.dart';
import 'utils.dart';
import 'device.dart';

class DeviceSettingPage extends StatefulWidget {
  final Device device;
  final List<Device> devices;
  const DeviceSettingPage({
    super.key,
    required this.device,
    required this.devices,
  });
  static const defaultSizedBox = SizedBox(
    height: 20,
  );

  @override
  State<DeviceSettingPage> createState() => _DeviceSettingPageState();
}

class _DeviceSettingPageState extends State<DeviceSettingPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.formatString(AppLocale.deviceSetting, [])),
      ),
      body: ListView(
        children: [
          SettingsSection(
            children: [
              deviceNameTile(context),
              SettingsSection.defaultDivider(context),
              ipTile(context),
              SettingsSection.defaultDivider(context),
              portTile(context),
              SettingsSection.defaultDivider(context),
              secretKeyTile(context),
              SettingsSection.defaultDivider(context),
              certificateAuthorityTile(context),
              SettingsSection.defaultDivider(context),
              ListTile(
                enabled: widget.device.iP != Device.webIP,
                title: Text(context.formatString(AppLocale.autoSelectIp, [])),
                trailing: Switch(
                  value: widget.device.autoSelect,
                  onChanged: widget.device.iP != Device.webIP
                      ? (value) {
                          setState(() {
                            widget.device.autoSelect = value;
                          });
                        }
                      : null,
                ),
              ),
              SettingsSection.defaultDivider(context),
              // filePickerPackageNameTile(context),
              if (Platform.isAndroid) filePickerPackageNameTile(context),
            ],
          ),
          SettingsSection(
            children: [
              ListTile(
                enabled: widget.device.iP != Device.webIP,
                title: Text(
                    '${context.formatString(AppLocale.downloadThread, [])}: ${widget.device.downloadThread}'),
                subtitle: Slider(
                  value: widget.device.downloadThread.toDouble(),
                  min: 1,
                  max: 30,
                  divisions: 29,
                  label: widget.device.downloadThread.toString(),
                  onChanged: widget.device.iP != Device.webIP
                      ? (value) {
                          setState(() {
                            widget.device.downloadThread = value.toInt();
                          });
                        }
                      : null,
                ),
              ),
              SettingsSection.defaultDivider(context),
              ListTile(
                enabled: widget.device.iP != Device.webIP,
                title: Text(
                    '${context.formatString(AppLocale.uploadThread, [])}: ${widget.device.uploadThread}'),
                subtitle: Slider(
                  value: widget.device.uploadThread.toDouble(),
                  min: 1,
                  max: 30,
                  divisions: 29,
                  label: widget.device.uploadThread.toString(),
                  onChanged: widget.device.iP != Device.webIP
                      ? (value) {
                          setState(() {
                            widget.device.uploadThread = value.toInt();
                          });
                        }
                      : null,
                ),
              ),
            ],
          ),
          actionSettingsSection(context),
        ],
      ),
    );
  }

  SettingsSection actionSettingsSection(BuildContext context) {
    return SettingsSection(
      children: [
        SwitchListTile(
          title: Text(context.formatString(AppLocale.copy, [])),
          value: widget.device.actionCopy,
          onChanged: widget.device.iP != Device.webIP
              ? (value) {
                  setState(() {
                    widget.device.actionCopy = value;
                  });
                }
              : null,
        ),
        SettingsSection.defaultDivider(context),
        SwitchListTile(
          title: Text(context.formatString(AppLocale.pasteText, [])),
          value: widget.device.actionPasteText,
          onChanged: widget.device.iP != Device.webIP
              ? (value) {
                  setState(() {
                    widget.device.actionPasteText = value;
                  });
                }
              : null,
        ),
        SettingsSection.defaultDivider(context),
        SwitchListTile(
          title: Text(context.formatString(AppLocale.pasteFile, [])),
          value: widget.device.actionPasteFile,
          onChanged: widget.device.iP != Device.webIP
              ? (value) {
                  setState(() {
                    widget.device.actionPasteFile = value;
                  });
                }
              : null,
        ),
      ],
    );
  }

  ListTile deviceNameTile(BuildContext context) {
    return ListTile(
      title: Text(context.formatString(AppLocale.deviceName, [])),
      subtitle: Text(widget.device.targetDeviceName),
      onTap: () {
        final deviceNameController =
            TextEditingController(text: widget.device.targetDeviceName);
        alertDialogFunc(
          context,
          Text(context.formatString(AppLocale.deviceName, [])),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: deviceNameController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: context.formatString(AppLocale.deviceName, []),
              ),
              validator: Device.deviceNameValidator(context, widget.devices),
            ),
          ),
          canConfirm: () {
            return _formKey.currentState?.validate() ?? false;
          },
          onConfirmed: () {
            setState(() {
              if (widget.device.targetDeviceName ==
                  AppConfigModel().defaultSyncDevice) {
                AppConfigModel().defaultSyncDevice =
                    deviceNameController.text.trim();
              }
              if (widget.device.targetDeviceName ==
                  AppConfigModel().defaultShareDevice) {
                AppConfigModel().defaultShareDevice =
                    deviceNameController.text.trim();
              }
              widget.device.targetDeviceName = deviceNameController.text.trim();
            });
          },
        );
      },
    );
  }

  ListTile filePickerPackageNameTile(BuildContext context) {
    return ListTile(
      title: Text(context.formatString(AppLocale.useThirdPartyFilePicker, [])),
      subtitle: Text(widget.device.filePickerPackageName),
      onTap: () {
        final filePickerPackageNameController =
            TextEditingController(text: widget.device.filePickerPackageName);
        alertDialogFunc(
          context,
          Text(context.formatString(AppLocale.useThirdPartyFilePicker, [])),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: filePickerPackageNameController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: context
                    .formatString(AppLocale.filePickerPackageNameHint, []),
              ),
              validator: Device.filePickerPackageNameValidator(context),
            ),
          ),
          canConfirm: () {
            return _formKey.currentState?.validate() ?? false;
          },
          onConfirmed: () {
            setState(() {
              widget.device.filePickerPackageName =
                  filePickerPackageNameController.text.trim();
            });
          },
        );
      },
    );
  }

  ListTile certificateAuthorityTile(BuildContext context) {
    String trustedCertificateSubtitle = widget.device.trustedCertificate;
    if (widget.device.trustedCertificate.isNotEmpty) {
      var lines = widget.device.trustedCertificate.split('\n');
      if (lines.length > 2) {
        lines = lines.sublist(0, 2);
      }
      trustedCertificateSubtitle = lines.join('\n');
    } else {
      trustedCertificateSubtitle =
          context.formatString(AppLocale.trustedCertificateHint, []);
    }
    return ListTile(
      title: Text(context.formatString(AppLocale.trustedCertificate, [])),
      subtitle: Text(trustedCertificateSubtitle),
      onTap: () {
        final certificateAuthorityController =
            TextEditingController(text: widget.device.trustedCertificate);
        alertDialogFunc(
          context,
          Text(context.formatString(AppLocale.trustedCertificate, [])),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: certificateAuthorityController,
              autofocus: true,
              maxLines: 10,
              minLines: 3,
              decoration: InputDecoration(
                hintText:
                    context.formatString(AppLocale.trustedCertificateHint, []),
                border: const OutlineInputBorder(),
              ),
              validator: Device.certificateAuthorityValidator(context),
            ),
          ),
          canConfirm: () {
            return _formKey.currentState?.validate() ?? false;
          },
          onConfirmed: () {
            setState(() {
              widget.device.trustedCertificate =
                  certificateAuthorityController.text.trim();
            });
          },
        );
      },
    );
  }

  ListTile secretKeyTile(BuildContext context) {
    return ListTile(
      title: const Text('SecretKey'),
      subtitle: Text(widget.device.secretKey),
      onTap: () {
        final secretKeyController =
            TextEditingController(text: widget.device.secretKey);
        alertDialogFunc(
          context,
          Text(context.formatString('SecretKey', [])),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: secretKeyController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: context.formatString('SecretKey', []),
              ),
              validator: Device.secretKeyValidator(context),
            ),
          ),
          canConfirm: () {
            return _formKey.currentState?.validate() ?? false;
          },
          onConfirmed: () {
            setState(() {
              widget.device.secretKey = secretKeyController.text.trim();
            });
          },
        );
      },
    );
  }

  ListTile portTile(BuildContext context) {
    return ListTile(
      title: const Text('Port'),
      subtitle: Text(widget.device.port.toString()),
      enabled: widget.device.iP != Device.webIP,
      onTap: () {
        final portController =
            TextEditingController(text: widget.device.port.toString());
        alertDialogFunc(
          context,
          Text(context.formatString('Port', [])),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: portController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: context.formatString('Port', []),
              ),
              validator: Device.portValidator(context),
            ),
          ),
          canConfirm: () {
            return _formKey.currentState?.validate() ?? false;
          },
          onConfirmed: () {
            setState(() {
              widget.device.port = int.parse(portController.text.trim());
            });
          },
        );
      },
    );
  }

  ListTile ipTile(BuildContext context) {
    return ListTile(
      title: const Text('Host'),
      subtitle: Text(widget.device.iP),
      onTap: () {
        final ipController = TextEditingController(text: widget.device.iP);
        alertDialogFunc(
          context,
          Text(context.formatString('Host', [])),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: ipController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: context.formatString('Target host or ip', []),
              ),
              validator: Device.ipValidator(context, false),
            ),
          ),
          canConfirm: () {
            return _formKey.currentState?.validate() ?? false;
          },
          onConfirmed: () {
            if (ipController.text.trim().toLowerCase() == Device.webIP) {
              ipController.text = Device.webIP;
            }
            setState(() {
              widget.device.iP = ipController.text.trim();
            });
          },
        );
      },
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const SettingsSection({super.key, this.title, required this.children});

  static Divider defaultDivider(BuildContext context) {
    return Divider(
      color: Theme.of(context).colorScheme.surface,
      height: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              top: 0,
            ),
            child: Text(
              title!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        Card(
          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 18,
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}
