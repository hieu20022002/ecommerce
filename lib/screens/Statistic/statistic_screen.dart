import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';

import '../Order_Management/OrderScreensMana.dart';
import 'components/RevenueTab.dart';
import 'components/TopProductsTab.dart';

class StatisticScreen extends StatefulWidget {
  static String routeName = "/statistic";
  StatisticScreen({Key? key}) : super(key: key);
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  @override
  _StatisticScreenState createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  DateTimeRange? _dateRange;
  int _currentIndex = 0;
  String _dateRangeText = 'Today';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              title: Text(
                '$_dateRangeText',
                style: const TextStyle(color: Colors.deepOrangeAccent),
              ),
              actions: _buildAppBarActions(),
            )
          : null,
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Top Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Manage Invoices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Manage Products',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return RevenueTab(dateRange: _dateRange);
      case 1:
        return const TopProductsTab();
      case 2:
        return OrderScreensMana();
      case 3:
      //return ManageProductsScreen();
      default:
        return Container();
    }
  }

  List<Widget> _buildAppBarActions() {
    return [
      PopupMenuButton<String>(
        onSelected: (String value) {
          setState(() {
            _dateRangeText = value;
            switch (value) {
              case 'Today':
                _dateRange = DateTimeRange(
                  start: DateTime.now(),
                  end: DateTime.now(),
                );
                break;
              case 'Yesterday':
                _dateRange = DateTimeRange(
                  start: DateTime.now().subtract(const Duration(days: 1)),
                  end: DateTime.now().subtract(const Duration(days: 1)),
                );
                break;
              case 'Last 7 days':
                _dateRange = DateTimeRange(
                  start: DateTime.now().subtract(const Duration(days: 7)),
                  end: DateTime.now(),
                );
                break;
              case 'Last 30 days':
                _dateRange = DateTimeRange(
                  start: DateTime.now().subtract(const Duration(days: 30)),
                  end: DateTime.now(),
                );
                break;
              case 'This year':
                _dateRange = DateTimeRange(
                  start: DateTime(DateTime.now().year),
                  end: DateTime.now(),
                );
                break;
              case 'Last year':
                _dateRange = DateTimeRange(
                  start: DateTime(DateTime.now().year - 1, 1, 1),
                  end: DateTime(DateTime.now().year - 1, 12, 31),
                );
                break;
              case 'Custom':
                _selectCustomDateRange();
                break;
            }
          });
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'Today',
            child: Text('Today'),
          ),
          const PopupMenuItem<String>(
            value: 'Yesterday',
            child: Text('Yesterday'),
          ),
          const PopupMenuItem<String>(
            value: 'Last 7 days',
            child: Text('Last 7 days'),
          ),
          const PopupMenuItem<String>(
            value: 'Last 30 days',
            child: Text('Last 30 days'),
          ),
          const PopupMenuItem<String>(
            value: 'This year',
            child: Text('This year'),
          ),
          const PopupMenuItem<String>(
            value: 'Last year',
            child: Text('Last year'),
          ),
          const PopupMenuItem<String>(
            value: 'Custom',
            child: Text('Custom'),
          ),
        ],
      ),
    ];
  }

  Future<void> _selectCustomDateRange() async {
    final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
    final DateTime? startDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 100),
      helpText: 'Select start date',
    );
    if (startDate != null) {
      final DateTime? endDate = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: startDate,
        lastDate: DateTime(DateTime.now().year + 100),
        helpText: 'Select end date',
      );
      if (endDate != null) {
        setState(() {
          _dateRangeText =
              '${_dateFormat.format(startDate)} - ${_dateFormat.format(endDate)}';
          _dateRange = DateTimeRange(start: startDate, end: endDate);
        });
      }
    }
  }
}
