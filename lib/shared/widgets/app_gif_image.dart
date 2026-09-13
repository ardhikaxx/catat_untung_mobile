import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Global in-memory cache for decoded and normalized GIF frames.
///
/// Ensures high-frame-count GIFs (150+ frames) are subsampled to ~40-45 frames
/// so they animate at a natural, lively speed (no slow motion) with 60 FPS GPU rendering.
class _AppGifCache {
  static final Map<String, List<ui.Image>> _cachedFrames = {};
  static final Map<String, Future<List<ui.Image>>> _pendingLoads = {};

  static Future<List<ui.Image>> getFrames(String asset, {int targetFrames = 42}) async {
    final cached = _cachedFrames[asset];
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }

    // Reuse pending load if multiple widgets request the same asset concurrently
    if (_pendingLoads.containsKey(asset)) {
      return _pendingLoads[asset]!;
    }

    final future = _loadAndSubsample(asset, targetFrames: targetFrames);
    _pendingLoads[asset] = future;
    try {
      final frames = await future;
      _cachedFrames[asset] = frames;
      return frames;
    } finally {
      _pendingLoads.remove(asset);
    }
  }

  static Future<List<ui.Image>> _loadAndSubsample(String asset, {required int targetFrames}) async {
    final data = await rootBundle.load(asset);
    final bytes = data.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(bytes);

    // If a GIF has >50 frames, subsample to ~40-45 frames for normal speed
    final step = (codec.frameCount / targetFrames).round().clamp(1, 10);
    final kept = <ui.Image>[];

    for (int i = 0; i < codec.frameCount; i++) {
      final frameInfo = await codec.getNextFrame();
      if (i % step == 0 || i == codec.frameCount - 1) {
        kept.add(frameInfo.image);
      } else {
        frameInfo.image.dispose();
      }
    }

    return kept;
  }
}

/// A high-performance, smooth GIF player that normalizes playback speed.
///
/// Solves Flutter's default slow-motion behavior caused by decoding lag
/// and VSYNC timers on high-frame-count GIFs.
class AppGifImage extends StatefulWidget {
  final String asset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Duration duration;

  const AppGifImage({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.duration = const Duration(milliseconds: 1400),
  });

  @override
  State<AppGifImage> createState() => _AppGifImageState();
}

class _AppGifImageState extends State<AppGifImage>
    with SingleTickerProviderStateMixin {
  List<ui.Image>? _frames;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
    _load();
  }

  Future<void> _load() async {
    try {
      final frames = await _AppGifCache.getFrames(widget.asset);
      if (mounted) {
        setState(() {
          _frames = frames;
        });
      }
    } catch (_) {}
  }

  @override
  void didUpdateWidget(AppGifImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset != widget.asset) {
      _load();
    }
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      if (_controller.isAnimating) {
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final frames = _frames;
    if (frames == null || frames.isEmpty) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final total = frames.length;
        final index = (_controller.value * total).floor().clamp(0, total - 1);
        return RawImage(
          image: frames[index],
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
        );
      },
    );
  }
}
