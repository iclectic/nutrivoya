import '../models/weight_entry.dart';

/// Derives calm multi-day weight trends — never a single-day verdict.
///
/// Prefer averages and weekly slope. Day-to-day fluctuations are noise.
class WeightTrendService {
  const WeightTrendService();

  /// Minimum entries before a direction is reported.
  static const minEntriesForTrend = 3;

  /// Steady band: weekly change within ±this kg is "steady".
  static const steadyBandKgPerWeek = 0.15;

  WeightTrend analyze(
    List<WeightEntry> entries, {
    int windowDays = 28,
  }) {
    if (entries.isEmpty) {
      return const WeightTrend(
        direction: WeightTrendDirection.insufficientData,
        entryCount: 0,
      );
    }

    final sorted = [...entries]
      ..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    final latest = sorted.last;
    final cutoff = latest.loggedAt.subtract(Duration(days: windowDays));
    final window = sorted.where((e) => !e.loggedAt.isBefore(cutoff)).toList();
    final sample = window.isNotEmpty ? window : sorted;

    final avg =
        sample.map((e) => e.weightKg).reduce((a, b) => a + b) / sample.length;

    if (sample.length < minEntriesForTrend) {
      return WeightTrend(
        direction: WeightTrendDirection.insufficientData,
        entryCount: sample.length,
        averageKg: _round1(avg),
        latestKg: _round1(latest.weightKg),
      );
    }

    final slopePerDay = _leastSquaresSlopeKgPerDay(sample);
    final weekly = slopePerDay * 7;

    final WeightTrendDirection direction;
    if (weekly.abs() < steadyBandKgPerWeek) {
      direction = WeightTrendDirection.steady;
    } else if (weekly > 0) {
      direction = WeightTrendDirection.rising;
    } else {
      direction = WeightTrendDirection.falling;
    }

    return WeightTrend(
      direction: direction,
      entryCount: sample.length,
      averageKg: _round1(avg),
      weeklyChangeKg: _round2(weekly),
      latestKg: _round1(latest.weightKg),
    );
  }

  /// Ordinary least-squares slope of weight vs days from first sample.
  double _leastSquaresSlopeKgPerDay(List<WeightEntry> sample) {
    final t0 = sample.first.loggedAt;
    final xs = <double>[];
    final ys = <double>[];
    for (final e in sample) {
      xs.add(e.loggedAt.difference(t0).inMinutes / (60 * 24));
      ys.add(e.weightKg);
    }
    final n = xs.length;
    final meanX = xs.reduce((a, b) => a + b) / n;
    final meanY = ys.reduce((a, b) => a + b) / n;
    var num = 0.0;
    var den = 0.0;
    for (var i = 0; i < n; i++) {
      final dx = xs[i] - meanX;
      num += dx * (ys[i] - meanY);
      den += dx * dx;
    }
    if (den == 0) return 0;
    return num / den;
  }

  double _round1(double v) => (v * 10).roundToDouble() / 10;
  double _round2(double v) => (v * 100).roundToDouble() / 100;
}
