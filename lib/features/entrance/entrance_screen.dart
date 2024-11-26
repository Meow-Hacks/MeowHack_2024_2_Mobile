import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/settings/app_settings.dart';
import '../../di/global_data_provider.dart';
import 'entrance_api.dart';

class EntranceHistoryPage extends StatefulWidget {
  const EntranceHistoryPage({Key? key}) : super(key: key);

  @override
  State<EntranceHistoryPage> createState() => _EntranceHistoryPageState();
}

class _EntranceHistoryPageState extends State<EntranceHistoryPage> {
  bool isLoading = true;
  List<dynamic> history = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final globalData = Provider.of<GlobalDataProvider>(context);
    history = globalData.entranceHistory;
    isLoading = globalData.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('История посещений'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
        child: Text(
          errorMessage!,
          style: TextStyle(color: theme.colorScheme.error),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];
          return _HistoryCard(
            branchName: item['branch_name'],
            branchAddress: item['branch_address'],
            time: item['time'],
            status: item['status'],
          );
        },
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final String branchName;
  final String branchAddress;
  final String time;
  final String status;

  const _HistoryCard({
    Key? key,
    required this.branchName,
    required this.branchAddress,
    required this.time,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedTime =
    DateTime.parse(time).toLocal().toString().substring(0, 19);

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (theme.brightness == Brightness.dark) BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            branchName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            branchAddress,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Статус: $status',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.blue),
              ),
              Text(
                formattedTime,
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
