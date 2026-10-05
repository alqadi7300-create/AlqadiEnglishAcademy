import 'package:flutter/material.dart';

import '../models/question_model.dart';

class QuestionWidget extends StatelessWidget {
  final QuestionModel question;
  final String? value;
  final ValueChanged<String?> onChanged;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (question.questionType == QuestionType.shortAnswer) {
      return TextField(
        onChanged: (text) {
          onChanged(text);
        },
        decoration: InputDecoration(
          labelText: question.text,
          border: const OutlineInputBorder(),
        ),
      );
    }

    final List<String> options =
        question.questionType == QuestionType.trueFalse
            ? const ['true', 'false']
            : question.options;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.text,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            RadioGroup<String>(
              groupValue: value,
              onChanged: onChanged,
              child: Column(
                children: options.map(
                  (option) {
                    return RadioListTile<String>(
                      value: option,
                      title: Text(option),
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
