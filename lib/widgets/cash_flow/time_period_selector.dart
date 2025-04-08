import 'package:flutter/material.dart';
import 'package:financial_manager/screens/cash_flow/cash_flow_home.dart';

class TimePeriodSelector extends StatelessWidget {
  final TimePeriod selectedPeriod;
  final Function(TimePeriod) onPeriodChanged;

  const TimePeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPeriodButton(
            context,
            TimePeriod.daily,
            'Daily',
            Icons.calendar_today,
          ),
          _buildPeriodButton(
            context,
            TimePeriod.weekly,
            'Weekly',
            Icons.calendar_view_week,
          ),
          _buildPeriodButton(
            context,
            TimePeriod.monthly,
            'Monthly',
            Icons.calendar_month,
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(
    BuildContext context,
    TimePeriod period,
    String label,
    IconData icon,
  ) {
    final isSelected = selectedPeriod == period;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: isSelected
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : null,
            side: BorderSide(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).dividerColor,
            ),
          ),
          onPressed: () => onPeriodChanged(period),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).textTheme.bodyMedium?.color,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).textTheme.bodyMedium?.color,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}