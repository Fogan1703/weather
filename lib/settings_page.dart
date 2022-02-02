import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather/app_state_model.dart';
import 'package:weather/generated/l10n.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF62B8F6),
                  Color(0xFF2C79C1),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: Navigator.of(context).pop,
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Expanded(
                      child: Text(
                        localization.settings,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
                _Title(localization.unit),
                _SettingsTile(
                  text: localization.temperatureUnit,
                  trailing: Consumer<AppStateModel>(
                    builder: (context, appState, child) {
                      return PopupMenuButton<TemperatureUnit>(
                        child: Text(
                          appState.temperatureUnit.toLocalizedString(),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        onSelected: (result) {
                          appState.temperatureUnit = result;
                        },
                        itemBuilder: (context) =>
                            <PopupMenuEntry<TemperatureUnit>>[
                          PopupMenuItem(
                            value: TemperatureUnit.celsius,
                            child: Text(
                                TemperatureUnit.celsius.toLocalizedString()),
                          ),
                          PopupMenuItem(
                            value: TemperatureUnit.fahrenheit,
                            child: Text(
                                TemperatureUnit.fahrenheit.toLocalizedString()),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                _SettingsTile(
                  text: localization.windSpeedUnit,
                  trailing: Consumer<AppStateModel>(
                    builder: (context, appState, child) {
                      return PopupMenuButton<WindSpeedUnit>(
                        child: Text(
                          appState.windSpeedUnit
                              .toLocalizedString(localization),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        onSelected: (result) {
                          appState.windSpeedUnit = result;
                        },
                        itemBuilder: (context) =>
                            <PopupMenuEntry<WindSpeedUnit>>[
                          PopupMenuItem(
                            value: WindSpeedUnit.kmh,
                            child: Text(WindSpeedUnit.kmh
                                .toLocalizedString(localization)),
                          ),
                          PopupMenuItem(
                            value: WindSpeedUnit.milh,
                            child: Text(WindSpeedUnit.milh
                                .toLocalizedString(localization)),
                          ),
                          PopupMenuItem(
                            value: WindSpeedUnit.ms,
                            child: Text(WindSpeedUnit.ms
                                .toLocalizedString(localization)),
                          ),
                          PopupMenuItem(
                            value: WindSpeedUnit.kn,
                            child: Text(WindSpeedUnit.kn
                                .toLocalizedString(localization)),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                _SettingsTile(
                  text: localization.atmosphericPressureUnit,
                  trailing: Consumer<AppStateModel>(
                    builder: (context, appState, child) {
                      return PopupMenuButton<AtmosphericPressureUnit>(
                        child: Text(
                          appState.atmosphericPressureUnit
                              .toLocalizedString(localization),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        onSelected: (result) {
                          appState.atmosphericPressureUnit = result;
                        },
                        itemBuilder: (context) =>
                            <PopupMenuEntry<AtmosphericPressureUnit>>[
                          PopupMenuItem(
                            value: AtmosphericPressureUnit.mbar,
                            child: Text(AtmosphericPressureUnit.mbar
                                .toLocalizedString(localization)),
                          ),
                          PopupMenuItem(
                            value: AtmosphericPressureUnit.atm,
                            child: Text(AtmosphericPressureUnit.atm
                                .toLocalizedString(localization)),
                          ),
                          PopupMenuItem(
                            value: AtmosphericPressureUnit.mmHg,
                            child: Text(AtmosphericPressureUnit.mmHg
                                .toLocalizedString(localization)),
                          ),
                          PopupMenuItem(
                            value: AtmosphericPressureUnit.inHg,
                            child: Text(AtmosphericPressureUnit.inHg
                                .toLocalizedString(localization)),
                          ),
                          PopupMenuItem(
                            value: AtmosphericPressureUnit.hPa,
                            child: Text(AtmosphericPressureUnit.hPa
                                .toLocalizedString(localization)),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 35),
                const Divider(
                  thickness: 1,
                  color: Colors.white,
                ),
                _Title(localization.extra),
                _SettingsTile(text: localization.about),
                _SettingsTile(text: localization.privacyPolicy),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String text;

  const _Title(
    this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 24,
        bottom: 12,
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String text;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.text,
    this.trailing,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      Expanded(
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 16,
          ),
        ),
      ),
    ];

    if (trailing != null) children.add(trailing!);

    Widget result = SizedBox(
      height: 40,
      child: Row(
        children: children,
      ),
    );

    if (onTap != null) {
      result = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: result,
        ),
      );
    }

    return result;
  }
}
