import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../../../models/Order.dart';

class RevenueData {
  final DateTime date;
  final double revenue;
  final charts.Color color;

  RevenueData(this.date, this.revenue, this.color);
}

class RevenueTab extends StatefulWidget {
  final DateTimeRange? dateRange;

  const RevenueTab({Key? key, this.dateRange}) : super(key: key);

  @override
  _RevenueTabState createState() => _RevenueTabState();
}

class _RevenueTabState extends State<RevenueTab> {
  int _numOrders = 0;
  double _totalRevenue = 0.0;
  List<charts.Series<RevenueData, String>>? seriesList;

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  @override
  void didUpdateWidget(RevenueTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dateRange != widget.dateRange) {
      _updateData();
    }
  }

  Future<void> _updateData() async {
    final List<Order> orders = await Order.getOrders();
    final List<Order> filteredOrders = orders.where((Order order) {
      if (widget.dateRange == null) {
        return true;
      } else {
        return order.createdAt.isAfter(widget.dateRange!.start) &&
            order.createdAt
                .isBefore(widget.dateRange!.end.add(Duration(days: 1)));
      }
    }).toList();
    setState(() {
      _numOrders = filteredOrders.length;
      _totalRevenue = filteredOrders.fold(0, (sum, order) => sum + order.total);
    });
    final List<RevenueData> revenueDataList =
        _calculateRevenueData(filteredOrders);
    seriesList = [
      charts.Series<RevenueData, String>(
        id: 'Revenue',
        data: revenueDataList,
        domainFn: (RevenueData data, _) => _dateFormat.format(data.date),
        measureFn: (RevenueData data, _) => data.revenue,
        colorFn: (RevenueData data, _) => data.color,
        labelAccessorFn: (RevenueData data, _) =>
            '${NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(data.revenue)}',
      ),
    ];
  }

  List<RevenueData> _calculateRevenueData(List<Order> orders) {
    final Map<String, double> revenueMap = {};
    orders.forEach((order) {
      final DateTime date = order.createdAt;
      final double revenue = order.total;
      final String formattedDate = _dateFormat.format(date);
      if (revenueMap.containsKey(formattedDate)) {
        revenueMap[formattedDate] = revenueMap[formattedDate]! + revenue;
      } else {
        revenueMap[formattedDate] = revenue;
      }
    });
    final List<RevenueData> revenueDataList = [];
    revenueMap.forEach((date, revenue) {
      final DateTime parsedDate = _dateFormat.parse(date);
      final charts.Color color = charts.ColorUtil.fromDartColor(Colors.blue);
      revenueDataList.add(RevenueData(parsedDate, revenue, color));
    });
    return revenueDataList;
  }

  @override
  Widget build(BuildContext context) {
    final String startDateText = widget.dateRange != null
        ? _dateFormat.format(widget.dateRange!.start)
        : '';
    final String endDateText = widget.dateRange != null
        ? _dateFormat.format(widget.dateRange!.end)
        : '';

    final chart = charts.BarChart(
      seriesList??[],
      animate: true,
      vertical: true,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: charts.AxisSpec<String>(
        renderSpec: charts.SmallTickRendererSpec(
            labelStyle: charts.TextStyleSpec(fontSize: 10)),
      ),
    );

    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          'Date Range: $startDateText - $endDateText',
          style: Theme.of(context).textTheme.headline6,
        ),
        Row(
          children: [
            Card(
              color: Color.fromARGB(255, 149, 207, 255),
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Orders:\n$_numOrders',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Card(
              color: Color(0xff74B1E9),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Total Revenue:\n${NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(_totalRevenue)}',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: chart,
          ),
        ),
      ],
    );
  }
}
