import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/extensions/app_localizations_x.dart';
import 'assistant_providers.dart';
import 'assistant_reply_formatter.dart';

/// Ask Nutrivoya — culturally respectful nutrition guidance over app data.
class AssistantScreen extends ConsumerStatefulWidget {
  const AssistantScreen({super.key});

  @override
  ConsumerState<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends ConsumerState<AssistantScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _busy = false;

  static const _promptKeys = <String>[
    'assistantPromptRice',
    'assistantPromptBalance',
    'assistantPromptProtein',
    'assistantPromptHunger',
    'assistantPromptRoti',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _submit([String? preset]) async {
    final text = (preset ?? _controller.text).trim();
    if (text.isEmpty || _busy) return;
    setState(() => _busy = true);
    _controller.clear();
    try {
      await ref.read(assistantControllerProvider.notifier).ask(text);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      if (_scrollController.hasClients) {
        await _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _promptText(AppLocalizations l10n, String key) {
    switch (key) {
      case 'assistantPromptRice':
        return l10n.assistantPromptRice;
      case 'assistantPromptBalance':
        return l10n.assistantPromptBalance;
      case 'assistantPromptProtein':
        return l10n.assistantPromptProtein;
      case 'assistantPromptHunger':
        return l10n.assistantPromptHunger;
      case 'assistantPromptRoti':
        return l10n.assistantPromptRoti;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final turns = ref.watch(assistantControllerProvider);
    final formatter = AssistantReplyFormatter(l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.assistantTitle),
        actions: [
          if (turns.isNotEmpty)
            IconButton(
              tooltip: l10n.assistantClear,
              icon: const Icon(Icons.delete_outline),
              onPressed: () =>
                  ref.read(assistantControllerProvider.notifier).clear(),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    l10n.assistantIntro,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.assistantWellnessDisclaimer,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 16),
                  if (turns.isEmpty) ...[
                    Text(
                      l10n.assistantTryAsking,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _promptKeys
                          .map(
                            (k) => ActionChip(
                              label: Text(_promptText(l10n, k)),
                              onPressed: _busy
                                  ? null
                                  : () => _submit(_promptText(l10n, k)),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  ...turns.map((turn) {
                    final answer = turn.answer;
                    final tips = formatter.tips(answer);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.sizeOf(context).width * 0.85,
                              ),
                              child: Card(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(turn.question),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formatter.headline(answer),
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(formatter.body(answer)),
                                  if (tips.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      l10n.assistantSuggestions,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    ...tips.map(
                                      (t) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('• '),
                                            Expanded(child: Text(t)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (answer.citations.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      l10n.assistantSources,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    ...answer.citations.map(
                                      (c) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4),
                                        child: Text(
                                          c.detail == null
                                              ? c.label
                                              : '${c.label}: ${c.detail}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (answer.showMedicalDisclaimer) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      l10n.assistantMedicalDisclaimer,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                          ),
                                    ),
                                  ],
                                  if (answer.showWellnessDisclaimer) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      l10n.assistantWellnessDisclaimer,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  if (_busy)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !_busy,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        hintText: l10n.assistantInputHint,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _busy ? null : _submit,
                    icon: const Icon(Icons.send),
                    tooltip: l10n.assistantSend,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
