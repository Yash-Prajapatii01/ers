import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import '../../data/data_source/network.dart';
import '../../data/models/udfOptionsModel.dart';
import 'BookingFormBloc/booking_form_bloc.dart';
import 'package:http/http.dart' as http;

typedef OptionSelectCallback = void Function(String name, int id);

class UdfOptionWidgetProvider {
  static Future<Widget> provide({
    required BuildContext context,
    required String fieldType,
    required List<UdfOptionsModel>? udfOptionsList,
    required OptionSelectCallback onSelect,
    int? projectId,
  }) async {
    return BlocProvider(
      create:
          (context) => BookingFormBloc(
            remoteSource: BookingFormRemoteSourceImpl(client: http.Client()),
          ),
      child: BlocBuilder<BookingFormBloc, BookingFormState>(
        builder: (context, state) {
          if (fieldType == 'TSKSS' &&
              projectId != null &&
              (udfOptionsList == null || udfOptionsList.isEmpty)) {
            if (state is BookingFormLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BookingFormOptionLoadedState) {
              return _buildStaticList(context, state.options, onSelect);
            } else if (state is BookingFormErrorState) {
              return Center(child: Text('Error: ${state.message}'));
            }
          }

          // Original logic for other cases
          if (udfOptionsList != null && udfOptionsList.isNotEmpty) {
            context.read<BookingFormBloc>().add(
              LoadStaticOptionsEvent(options: udfOptionsList),
            );
            return _buildStaticList(context, udfOptionsList, onSelect);
          } else {
            return _buildSearchableList(
              context,
              fieldType,
              onSelect,
              projectId,
            );
          }
        },
        //   if (udfOptionsList != null && udfOptionsList.isNotEmpty) {
        //     context.read<BookingChartBloc>().add(LoadStaticOptionsEvent(options: udfOptionsList!));
        //     return _buildStaticList(context, udfOptionsList, onSelect);
        //   } else {
        //     return _buildSearchableList(context, fieldType, onSelect, projectId);
        //   }
        // },
      ),
    );
  }

  static Widget _buildStaticList(
    BuildContext context,
    List<UdfOptionsModel> options,
    OptionSelectCallback onSelect,
  ) {
    return ListView.builder(
      itemCount: options.length,
      itemBuilder: (context, idx) {
        final option = options[idx];
        return ListTile(
          title: Text("Here i am - ${option.name}"),
          onTap: () {
            Navigator.pop(context);
            onSelect(option.name, option.id);
          },
        );
      },
    );
  }

  static Widget _buildSearchableList(
    BuildContext context,
    String fieldType,
    OptionSelectCallback onSelect,
    int? projectId,
  ) {
    return _DebouncedSearchList(
      fieldType: fieldType,
      onSelect: onSelect,
      projectId: projectId,
    );
  }
}

class _DebouncedSearchList extends StatefulWidget {
  final String fieldType;
  final OptionSelectCallback onSelect;
  final int? projectId;

  _DebouncedSearchList({
    required this.fieldType,
    required this.onSelect,
    this.projectId,
  });

  @override
  State<_DebouncedSearchList> createState() => _DebouncedSearchListState();
}

class _DebouncedSearchListState extends State<_DebouncedSearchList> {
  final TextEditingController _searchController = TextEditingController();
  final Duration debounceDuration = const Duration(milliseconds: 400);
  Timer? _debounce;
  List<UdfOptionsModel> _results = [];
  bool _loading = false;

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    context.read<BookingFormBloc>().add(
      SearchOptionEvent(
        fieldType: widget.fieldType,
        query: query,
        // projectId: widget.projectId,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        Expanded(
          child: BlocBuilder<BookingFormBloc, BookingFormState>(
            builder: (context, state) {
              if (state is BookingFormLoadingState) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is BookingFormOptionLoadedState) {
                return ListView.builder(
                  itemCount: state.options.length,
                  itemBuilder: (context, index) {
                    final item = state.options[index];
                    return ListTile(
                      title: Text(item.name),
                      onTap: () {
                        print('here in this tile tapped ${item.name}');
                        Navigator.pop(context);
                        widget.onSelect(item.name, item.id);
                      },
                    );
                  },
                );
              } else if (state is BookingFormErrorState) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 48),
                        SizedBox(height: 16),
                        Text(
                          state.message,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(child: Text('Start typing to search...'));
              }
            },
          ),
        ),
      ],
    );
  }
}
