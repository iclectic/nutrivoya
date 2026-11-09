import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/models/photo_recognition.dart';
import '../../shared/extensions/app_localizations_x.dart';
import 'photo_providers.dart';

/// Photo → uncertain suggestions → portion estimate → confirm → food lookup.
///
/// Never treats computer-vision (or description) matches as certain, and
/// never invents calories from the image.
class PhotoRecognitionScreen extends ConsumerStatefulWidget {
  const PhotoRecognitionScreen({super.key});

  @override
  ConsumerState<PhotoRecognitionScreen> createState() =>
      _PhotoRecognitionScreenState();
}

class _PhotoRecognitionScreenState
    extends ConsumerState<PhotoRecognitionScreen> {
  final _descCtrl = TextEditingController();
  final _picker = ImagePicker();

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      ref.read(photoSessionProvider.notifier).setImage(Uint8List.fromList(bytes));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.photoErrorFailed)),
      );
    }
  }

  String? _errorText(AppLocalizations l10n, String? key) {
    switch (key) {
      case 'photoErrorNoImage':
        return l10n.photoErrorNoImage;
      case 'photoErrorNeedDescription':
        return l10n.photoErrorNeedDescription;
      case 'photoErrorNoMatches':
        return l10n.photoErrorNoMatches;
      case 'photoErrorFailed':
        return l10n.photoErrorFailed;
      default:
        return null;
    }
  }

  String _confidenceLabel(AppLocalizations l10n, PhotoMatchConfidence c) {
    switch (c) {
      case PhotoMatchConfidence.uncertain:
        return l10n.photoConfidenceUncertain;
      case PhotoMatchConfidence.low:
        return l10n.photoConfidenceLow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final session = ref.watch(photoSessionProvider);
    final error = _errorText(l10n, session.errorKey);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.photoTitle),
        actions: [
          if (session.hasPhoto)
            IconButton(
              tooltip: l10n.photoClear,
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                _descCtrl.clear();
                ref.read(photoSessionProvider.notifier).reset();
              },
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.photoIntro,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.photoUncertaintyDisclaimer,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            const SizedBox(height: 16),

            if (!session.hasPhoto) ...[
              FilledButton.icon(
                onPressed: () => _pick(ImageSource.camera),
                icon: const Icon(Icons.photo_camera_outlined),
                label: Text(l10n.photoTakePhoto),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _pick(ImageSource.gallery),
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(l10n.photoChooseGallery),
              ),
            ] else ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  session.imageBytes!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => _pick(ImageSource.gallery),
                child: Text(l10n.photoRetake),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descCtrl,
                textInputAction: TextInputAction.search,
                onChanged: (v) =>
                    ref.read(photoSessionProvider.notifier).setDescription(v),
                onSubmitted: (_) =>
                    ref.read(photoSessionProvider.notifier).runSuggestions(),
                decoration: InputDecoration(
                  labelText: l10n.photoDescriptionLabel,
                  hintText: l10n.photoDescriptionHint,
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: session.busy
                    ? null
                    : () =>
                        ref.read(photoSessionProvider.notifier).runSuggestions(),
                icon: session.busy
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.search),
                label: Text(l10n.photoSuggestFoods),
              ),
            ],

            if (error != null) ...[
              const SizedBox(height: 12),
              Text(
                error,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],

            if (session.suggestions.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                l10n.photoSuggestionsTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.photoSuggestionsNote,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 8),
              ...session.suggestions.map((s) {
                final selected = session.selected?.food.id == s.food.id;
                return Card(
                  color: selected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                  child: ListTile(
                    title: Text(s.food.displayName),
                    subtitle: Text(
                      [
                        if (s.food.cuisine != null) s.food.cuisine!,
                        _confidenceLabel(l10n, s.matchConfidence),
                      ].join(' · '),
                    ),
                    trailing: selected
                        ? const Icon(Icons.check_circle)
                        : const Icon(Icons.chevron_right),
                    onTap: () => ref
                        .read(photoSessionProvider.notifier)
                        .selectSuggestion(s),
                  ),
                );
              }),
            ],

            if (session.selected != null &&
                session.portionOptions.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                l10n.photoPortionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.photoPortionNote,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: session.portionOptions.map((p) {
                  final selected = session.selectedPortion?.label == p.label &&
                      session.selectedPortion?.grams == p.grams;
                  return ChoiceChip(
                    label: Text(
                      '${p.label ?? '${p.grams.round()} g'}'
                      ' (≈ ${p.grams.round()} g)',
                    ),
                    selected: selected,
                    onSelected: (_) => ref
                        .read(photoSessionProvider.notifier)
                        .selectPortion(p),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: session.selectedPortion == null
                    ? null
                    : () {
                        final food = session.selected!.food;
                        final portion = session.selectedPortion!;
                        // Hand off to food details for final verify + log.
                        // Nutrition still comes from structured Food data.
                        context.push(
                          '/food/${Uri.encodeComponent(food.id)}',
                          extra: {
                            'photoEstimatedGrams': portion.grams,
                            'photoPortionName': portion.label,
                          },
                        );
                      },
                child: Text(l10n.photoConfirmOpenFood),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.photoConfirmNote,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
