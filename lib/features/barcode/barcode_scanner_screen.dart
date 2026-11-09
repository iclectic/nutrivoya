import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../shared/extensions/app_localizations_x.dart';
import 'barcode_providers.dart';

/// Scan or manually enter a packaged-food barcode.
///
/// Flow: scan/enter → Open Food Facts lookup → food details (serving verify)
/// → add to meal. Crowdsourced values are shown with packaged-source
/// confidence; never treated as authoritative.
class BarcodeScannerScreen extends ConsumerStatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  ConsumerState<BarcodeScannerScreen> createState() =>
      _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends ConsumerState<BarcodeScannerScreen> {
  final _manualCtrl = TextEditingController();
  final _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    formats: const [
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
      BarcodeFormat.code128,
    ],
  );
  bool _handlingScan = false;
  bool _cameraError = false;

  @override
  void dispose() {
    _manualCtrl.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handlingScan) return;
    String? raw;
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;
      if (value != null && value.isNotEmpty) {
        raw = value;
        break;
      }
    }
    if (raw == null) return;

    _handlingScan = true;
    await _scannerController.stop();
    await ref.read(barcodeLookupControllerProvider.notifier).lookup(raw);
  }

  Future<void> _submitManual() async {
    final raw = _manualCtrl.text.trim();
    if (raw.isEmpty) return;
    FocusScope.of(context).unfocus();
    await ref.read(barcodeLookupControllerProvider.notifier).lookup(raw);
  }

  void _resumeScanner() {
    ref.read(barcodeLookupControllerProvider.notifier).reset();
    _handlingScan = false;
    _scannerController.start();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lookup = ref.watch(barcodeLookupControllerProvider);

    ref.listen<BarcodeLookupState>(barcodeLookupControllerProvider, (prev, next) {
      if (next is BarcodeLookupFound) {
        context.push('/food/${Uri.encodeComponent(next.food.id)}').then((_) {
          if (mounted) _resumeScanner();
        });
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.barcodeTitle)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: _cameraError
                  ? _CameraUnavailable(message: l10n.barcodeCameraUnavailable)
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        MobileScanner(
                          controller: _scannerController,
                          onDetect: _onDetect,
                          errorBuilder: (context, error) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted && !_cameraError) {
                                setState(() => _cameraError = true);
                              }
                            });
                            return _CameraUnavailable(
                              message: l10n.barcodeCameraUnavailable,
                            );
                          },
                        ),
                        IgnorePointer(
                          child: Center(
                            child: Container(
                              width: 240,
                              height: 140,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white70,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        if (lookup is BarcodeLookupLoading)
                          const ColoredBox(
                            color: Color(0x66000000),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      ],
                    ),
            ),
            Expanded(
              flex: 2,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    l10n.barcodeHint,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _manualCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.barcodeManualLabel,
                      hintText: l10n.barcodeManualHint,
                      prefixIcon: const Icon(Icons.dialpad),
                    ),
                    onSubmitted: (_) => _submitManual(),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: lookup is BarcodeLookupLoading
                        ? null
                        : _submitManual,
                    icon: const Icon(Icons.search),
                    label: Text(l10n.barcodeLookupButton),
                  ),
                  const SizedBox(height: 16),
                  if (lookup is BarcodeLookupNotFound) ...[
                    _StatusCard(
                      icon: Icons.search_off,
                      title: l10n.barcodeNotFoundTitle,
                      body: l10n.barcodeNotFoundBody(lookup.barcode),
                      actionLabel: l10n.barcodeTryAgain,
                      onAction: _resumeScanner,
                      secondaryLabel: l10n.addProductTitle,
                      onSecondary: () => context.push(
                        '/add-product',
                        extra: {'barcode': lookup.barcode},
                      ),
                    ),
                  ],
                  if (lookup is BarcodeLookupError)
                    _StatusCard(
                      icon: Icons.error_outline,
                      title: l10n.commonError,
                      body: lookup.messageKey == 'barcodeInvalid'
                          ? l10n.barcodeInvalid
                          : l10n.barcodeNetworkError,
                      actionLabel: l10n.barcodeTryAgain,
                      onAction: _resumeScanner,
                    ),
                  Text(
                    l10n.barcodeCrowdsourcedNote,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
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

class _CameraUnavailable extends StatelessWidget {
  const _CameraUnavailable({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.photo_camera_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
    this.secondaryLabel,
    this.onSecondary,
  });

  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(body),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                TextButton(onPressed: onAction, child: Text(actionLabel)),
                if (secondaryLabel != null && onSecondary != null)
                  FilledButton.tonal(
                    onPressed: onSecondary,
                    child: Text(secondaryLabel!),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
