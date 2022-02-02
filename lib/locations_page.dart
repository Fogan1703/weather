import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather/app_state_model.dart';
import 'package:weather/generated/l10n.dart';
import 'package:weather/maps_api.dart';
import 'package:weather/weather_data.dart';
import 'dart:ui' as ui;

class LocationsPage extends StatefulWidget {
  final bool isSearching;

  const LocationsPage({
    required this.isSearching,
    Key? key,
  }) : super(key: key);

  @override
  _LocationsPageState createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  bool get _isSearching => widget.isSearching || _searchIsNotEmpty;

  final GlobalKey<_SearchingFieldState> _searchFieldKey = GlobalKey();
  final List<int> _selectedIndexes = [];

  List<String>? _suggestions;

  bool _searchIsNotEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.only(
              left: 16,
              top: 16,
              right: 16,
              bottom: 0,
            ),
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
              children: [
                _AppBar(isSearching: _isSearching),
                const SizedBox(height: 32),
                Consumer<AppStateModel>(
                  builder: (context, appState, child) {
                    return _SearchingField(
                      key: _searchFieldKey,
                      autofocus: widget.isSearching,
                      selectedCount: _selectedIndexes.length,
                      onCancelSelection: () {
                        setState(() {
                          _selectedIndexes.clear();
                        });
                      },
                      onRemoveSelected: () {
                        setState(() {
                          appState.removeByIndexes(_selectedIndexes);
                          _selectedIndexes.clear();
                        });
                      },
                      onTyping: (value) {
                        setState(() {
                          _searchIsNotEmpty = value == null || value.isNotEmpty;

                          if (value != null && value.isNotEmpty) {
                            MapsAPI.getSuggestions(
                              input: value,
                              lang: Intl.getCurrentLocale(),
                              exclude: appState.locations,
                            ).then((suggestions) {
                              setState(() {
                                _suggestions = suggestions;
                              });
                            });
                          }

                          _suggestions = null;
                        });
                      },
                    );
                  },
                ),
                Consumer<AppStateModel>(
                  builder: (context, appState, child) {
                    return Expanded(
                      child: _isSearching
                          ? _SearchListView(
                              suggestions: _suggestions,
                              onTap: (fullName) {
                                setState(() {
                                  _searchIsNotEmpty = false;
                                  _suggestions = null;
                                  appState.addLocationByFullName(fullName);
                                  if (widget.isSearching) {
                                    Navigator.of(context).pop();
                                  } else {
                                    _searchFieldKey.currentState!.clear();
                                  }
                                });
                              },
                            )
                          : _LocationsListView(
                              locations: appState.locations,
                              selectedIndexes: _selectedIndexes,
                              onSelectionChanged: (index, value) {
                                setState(() {
                                  if (value) {
                                    _selectedIndexes.add(index);
                                  } else {
                                    _selectedIndexes.remove(index);
                                  }
                                });
                              },
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final bool isSearching;

  const _AppBar({
    required this.isSearching,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    return Row(
      children: [
        IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Icons.arrow_back),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              );
            },
            child: Text(
              isSearching
                  ? localization.searchLocation
                  : localization.manageLocation,
              key: ValueKey<bool>(isSearching),
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}

class _SearchingField extends StatefulWidget {
  final bool autofocus;
  final ValueChanged<String?> onTyping;
  final int selectedCount;
  final VoidCallback onCancelSelection;
  final VoidCallback onRemoveSelected;

  const _SearchingField({
    required this.autofocus,
    required this.onTyping,
    required this.selectedCount,
    required this.onCancelSelection,
    required this.onRemoveSelected,
    Key? key,
  }) : super(key: key);

  @override
  _SearchingFieldState createState() => _SearchingFieldState();
}

class _SearchingFieldState extends State<_SearchingField> {
  static const _finishingTypingDelay = Duration(milliseconds: 500);

  final TextEditingController _controller = TextEditingController();

  Future<void>? _checkingFinishingTyping;
  String _search = '';

  void clear() {
    _search = '';
    _controller.clear();
    _checkingFinishingTyping?.ignore();
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _checkingFinishingTyping?.ignore();
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    Widget child;

    if (widget.selectedCount == 0) {
      child = TextField(
        onChanged: (value) {
          setState(() {
            _checkingFinishingTyping?.ignore();
            if (value.isNotEmpty && _search.isNotEmpty) {
              widget.onTyping(null);
              _checkingFinishingTyping =
                  Future.delayed(_finishingTypingDelay, () {
                if (value == _search) {
                  widget.onTyping(value);
                }
              });
            } else {
              widget.onTyping(value);
            }
            _search = value;
          });
        },
        controller: _controller,
        cursorColor: Colors.black,
        textCapitalization: TextCapitalization.sentences,
        autofocus: widget.autofocus,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: localization.searchYourCity,
          hintStyle: GoogleFonts.poppins(
            color: const Color(0xFF828282),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF4F4F4F),
          ),
        ),
      );
    } else {
      child = Row(
        children: [
          IconButton(
            onPressed: widget.onCancelSelection,
            icon: const Icon(
              Icons.close,
              color: Color(0xFF1B2541),
            ),
          ),
          Text(
            widget.selectedCount.toString(),
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: const Color(0xFF545B70),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: widget.onRemoveSelected,
            icon: const Icon(
              Icons.delete,
              color: Color(0xFF1B2541),
            ),
          ),
        ],
      );
    }

    return Container(
      height: 49,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: child,
      ),
    );
  }
}

class _LocationsListView extends StatefulWidget {
  final List<LocationData> locations;
  final Function(int, bool) onSelectionChanged;
  final List<int> selectedIndexes;

  const _LocationsListView({
    required this.locations,
    required this.onSelectionChanged,
    required this.selectedIndexes,
    Key? key,
  }) : super(key: key);

  @override
  State<_LocationsListView> createState() => _LocationsListViewState();
}

class _LocationsListViewState extends State<_LocationsListView>
    with TickerProviderStateMixin {
  final List<_LocationsListItemAnimationState> _itemsStates = [];
  final List<AnimationController> _itemsControllers = [];
  final List<Timer> _itemControllersAppearingTimers = [];

  @override
  void initState() {
    super.initState();
    _updateControllers(playAppearingAnimation: true);
  }

  @override
  void dispose() {
    for (final controller in _itemsControllers) {
      controller.dispose();
    }
    for (final timer in _itemControllersAppearingTimers) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _LocationsListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    bool differentLocations = false;
    if (widget.locations.length != oldWidget.locations.length) {
      differentLocations = true;
    }
    for (final newLocation in widget.locations) {
      bool isDifferent = true;
      for (final oldLocation in oldWidget.locations) {
        if (newLocation.fullName == oldLocation.fullName) {
          isDifferent = false;
        }
      }
      if (isDifferent) {
        differentLocations = true;
        break;
      }
    }

    _updateControllers(playAppearingAnimation: differentLocations);
  }

  void _updateControllers({required bool playAppearingAnimation}) {
    _itemsStates.clear();
    _itemsStates.addAll(
      List.generate(
        widget.locations.length,
        (index) => _LocationsListItemAnimationState.appearing,
      ),
    );

    for (final controller in _itemsControllers) {
      controller.dispose();
    }
    _itemsControllers.clear();
    _itemsControllers.addAll(
      List.generate(
        widget.locations.length,
        (index) => AnimationController(
          duration: const Duration(milliseconds: 200),
          reverseDuration: const Duration(milliseconds: 100),
          vsync: this,
        ),
      ),
    );

    for (final timer in _itemControllersAppearingTimers) {
      timer.cancel();
    }
    _itemControllersAppearingTimers.clear();

    for (int i = 0; i < _itemsControllers.length; i++) {
      if (playAppearingAnimation) {
        _itemControllersAppearingTimers.add(
          Timer(Duration(milliseconds: 200 + 25 * i), () {
            _itemsControllers[i].forward();
          }),
        );
      } else {
        _itemsControllers[i].value = 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, appState, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: appState.isLoadingLocations
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : ListView.builder(
                  itemCount: widget.locations.length,
                  padding: const EdgeInsets.only(top: 32),
                  itemBuilder: (context, index) {
                    return _SavedLocationTile(
                      location: widget.locations[index],
                      animation: _itemsControllers[index],
                      animationState: _itemsStates[index],
                      isSelected: widget.selectedIndexes.contains(index),
                      onSelectionChanged: (value) {
                        widget.onSelectionChanged(index, value);
                      },
                      isSelecting: widget.selectedIndexes.isNotEmpty,
                    );
                  },
                ),
        );
      },
    );
  }
}

enum _LocationsListItemAnimationState {
  appearing,
  removing,
}

class _SavedLocationTile extends StatelessWidget {
  final LocationData location;
  final Animation<double> animation;
  final _LocationsListItemAnimationState animationState;
  final bool isSelected;
  final ValueChanged<bool> onSelectionChanged;
  final bool isSelecting;

  const _SavedLocationTile({
    required this.location,
    required this.animation,
    required this.animationState,
    required this.isSelected,
    required this.onSelectionChanged,
    required this.isSelecting,
    Key? key,
  }) : super(key: key);

  double _getTextHeight(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: ui.TextDirection.ltr,
    )..layout(maxWidth: 72);
    return textPainter.height;
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateModel>(context);
    final nameWidget = Text(
      location.name,
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFF1B2541),
      ),
    );
    // TODO: Localized names of locations

    final child = Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedOpacity(
          opacity: isSelecting && location.isCurrent ? 0.5 : 1,
          duration: const Duration(milliseconds: 200),
          child: InkWell(
            onTap: isSelecting && location.isCurrent
                ? null
                : () {
                    if (isSelecting) {
                      onSelectionChanged(!isSelected);
                    } else {
                      appState.selectedLocationFullName =
                          location.isCurrent ? null : location.fullName;
                      Navigator.of(context).pop();
                    }
                  },
            onLongPress: location.isCurrent
                ? null
                : () => onSelectionChanged(!isSelected),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        location.isCurrent
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  nameWidget,
                                  const Icon(
                                    Icons.location_on_outlined,
                                    color: Color(0xFF1B2541),
                                    size: 20,
                                  ),
                                ],
                              )
                            : nameWidget,
                        Text(
                          location.fullName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF545B70),
                            height: 1.6,
                          ),
                        ),
                        Text(
                          '${appState.temperatureUnit.toNumberStringFromCelsius(location.dailyWeather.first.minTemp)}°'
                          '/'
                          '${appState.temperatureUnit.toNumberStringFromCelsius(location.dailyWeather.first.maxTemp)}°',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color(0xFF545B70),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 72,
                    height: _getTextHeight(
                          location.currentWeather.weather,
                          GoogleFonts.poppins(
                            fontSize: 12,
                            letterSpacing: -0.24,
                          ),
                        ) +
                        32,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutBack,
                              reverseCurve: Curves.easeIn,
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: isSelecting
                          ? location.isCurrent
                              ? null
                              : Align(
                                  alignment: Alignment.topRight,
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    transitionBuilder: (child, animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: ScaleTransition(
                                          scale: CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.easeOutBack,
                                            reverseCurve: Curves.easeIn,
                                          ),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check_circle,
                                            key: ValueKey<bool>(true),
                                            color: Color(0xFF1B2541),
                                          )
                                        : const Icon(
                                            Icons.circle_outlined,
                                            key: ValueKey<bool>(false),
                                            color: Color(0xFF1B2541),
                                          ),
                                  ),
                                )
                          : Column(
                              children: [
                                Image.asset(
                                  'assets/weather_icons/' +
                                      (location.currentWeather.isDay
                                          ? 'day'
                                          : 'night') +
                                      '/${location.currentWeather.iconId}.png',
                                  height: 32,
                                  fit: BoxFit.fitHeight,
                                  color: const Color(0xFF1B2541),
                                  colorBlendMode: BlendMode.srcIn,
                                ),
                                Text(
                                  location.currentWeather.weather,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: const Color(0xFF545B70),
                                    letterSpacing: -0.24,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    switch (animationState) {
      case _LocationsListItemAnimationState.appearing:
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      case _LocationsListItemAnimationState.removing:
        return FadeTransition(
          opacity: animation,
          child: child,
        );
    }
  }
}

class _SearchListView extends StatefulWidget {
  final List<String>? suggestions;
  final Function(String) onTap;

  const _SearchListView({
    required this.suggestions,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _SearchListViewState createState() => _SearchListViewState();
}

class _SearchListViewState extends State<_SearchListView>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Timer> _controllersDelays = [];

  Timer _reverseAnimationDelay = Timer(Duration.zero, () {});

  late List<String>? _suggestions = [];

  bool _isAnimationForward = true;

  @override
  void dispose() {
    _reverseAnimationDelay.cancel();
    for (final delay in _controllersDelays) {
      delay.cancel();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _SearchListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isAnimationForward = false;
    for (final controller in _controllers) {
      controller.reverse();
    }
    _reverseAnimationDelay = Timer(const Duration(milliseconds: 100), () {
      setState(() {
        if (widget.suggestions != null) {
          _isAnimationForward = true;
          _controllers.clear();
          for (final delay in _controllersDelays) {
            delay.cancel();
          }
          _suggestions = widget.suggestions;
          _controllers.addAll(
            List.generate(
              widget.suggestions!.length,
              (index) => AnimationController(
                vsync: this,
                duration: const Duration(milliseconds: 200),
                reverseDuration: const Duration(milliseconds: 100),
              ),
            ),
          );
          for (int i = 0; i < _controllers.length; i++) {
            _controllersDelays.add(
              Timer(Duration(milliseconds: 200 + 25 * i), () {
                _controllers[i].forward();
              }),
            );
          }
        } else {
          _controllers.clear();
          for (final delay in _controllersDelays) {
            delay.cancel();
          }
          _suggestions = null;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_suggestions != null) {
      return ListView.builder(
        itemCount: _suggestions!.length,
        padding: const EdgeInsets.only(top: 32),
        itemBuilder: (context, index) {
          return _SearchLocationTile(
            name: _suggestions![index].split(', ').first,
            fullName: _suggestions![index],
            animation: _controllers[index],
            isAnimationForward: _isAnimationForward,
            onTap: () {
              widget.onTap(_suggestions![index]);
            },
          );
        },
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
  }
}

class _SearchLocationTile extends StatelessWidget {
  final String name;
  final String fullName;
  final Animation<double> animation;
  final bool isAnimationForward;
  final VoidCallback onTap;

  const _SearchLocationTile({
    required this.name,
    required this.fullName,
    required this.animation,
    required this.isAnimationForward,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1B2541),
                  ),
                ),
                Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF545B70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return FadeTransition(
      opacity: animation,
      child: isAnimationForward
          ? SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            )
          : child,
    );
  }
}
