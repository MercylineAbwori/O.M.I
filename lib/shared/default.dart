import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:one_million_app/shared/constants.dart';

class DefaultList extends ConsumerStatefulWidget {
  const DefaultList({
    super.key
  });

  @override
  ConsumerState<DefaultList> createState() {
    return _DefaultListState();
  }
}

class _DefaultListState extends ConsumerState<DefaultList> {
  // List<productsItem> _shops = [];
  List _data = [];
  var _isLoading = true;
  String? error;

  num _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // // Reload shops
    // ref.read(productsListProvider.notifier).fetchProducts();

    // _selectedIndex = widget.selectedIndex!;
  }


  // late productsListModel availableData;

  @override
  Widget build(BuildContext context) {
    // availableData = ref.watch(productsListProvider);

    // setState(() {
    //   _data = availableData.products;
    //   _isLoading = availableData.isLoading;
    // });

    Widget content = const Center(
      child: Text('No data yet',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      content = Center(
        child: Text(error!),
      );
    }

    if (_data.isNotEmpty) {
      content = SingleChildScrollView();
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          centerTitle: true,
        ),
        body: content);
  }
}

// Helper class
class Utils {
  static String getFormattedDateSimple(int time) {
    DateFormat newFormat = DateFormat("MMMM dd yyyy");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  static String getFormattedDateSimpleMonthAddDate(int time) {
    DateFormat newFormat = DateFormat("MMMM dd");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  static String getFormattedDateSimpleMonthAddDateLess(int time) {
    DateFormat newFormat = DateFormat("MMM dd");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  static String getFormattedDateSimpleFilter(int time) {
    DateFormat newFormat = DateFormat("yyyy-MM-dd");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  static String getFormattedDateSimpleToday(int time) {
    DateFormat newFormat = DateFormat("dd MMMM");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }
}
