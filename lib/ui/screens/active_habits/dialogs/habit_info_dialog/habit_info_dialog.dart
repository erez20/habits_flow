import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:habits_flow/ui/screens/active_habits/ui_models/selected_habit_ui.dart';

/// Screen dialog showing a habit's info and link. Stateless: a snapshot in,
/// a callback out — no cubit needed.
class HabitInfoDialog extends StatelessWidget {
  final SelectedHabitUI uiModel;
  final Future<void> Function(String url) onLinkTapped;

  const HabitInfoDialog({
    super.key,
    required this.uiModel,
    required this.onLinkTapped,
  });

  static Future<void> show(
    BuildContext context, {
    required SelectedHabitUI uiModel,
    required Future<void> Function(String url) onLinkTapped,
  }) {
    return showDialog(
      context: context,
      builder: (_) => HabitInfoDialog(
        uiModel: uiModel,
        onLinkTapped: onLinkTapped,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  uiModel.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.blueGrey[800],
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),
                if (uiModel.info.isNotEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline,
                          color: uiModel.color[700], size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          uiModel.info,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                if (uiModel.info.isNotEmpty && uiModel.link.isNotEmpty)
                  const SizedBox(height: 16),
                if (uiModel.link.isNotEmpty)
                  InkWell(
                    onTap: () async {
                      Fimber.d("link tapped--${uiModel.link}");
                      await onLinkTapped(uiModel.link);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.link, color: uiModel.color[700], size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Link",
                            style: TextStyle(
                              color: Colors.blueGrey[800],
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
