class TracingPoint {
  final double x;
  final double y;

  const TracingPoint({required this.x, required this.y});

  factory TracingPoint.fromJson(Map<String, dynamic> json) {
    return TracingPoint(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'x': x, 'y': y};
}

class MiniGameConfig {
  final String type;
  final String? targetSymbol;
  final List<TracingPoint>? guidePoints;
  final String? targetSound;
  final String? correctSymbol;
  final List<String>? distractorSymbols;
  final List<Map<String, String>>? pairs;

  const MiniGameConfig({
    required this.type,
    this.targetSymbol,
    this.guidePoints,
    this.targetSound,
    this.correctSymbol,
    this.distractorSymbols,
    this.pairs,
  });

  factory MiniGameConfig.fromJson(Map<String, dynamic> json) {
    List<TracingPoint>? points;
    if (json['guidePoints'] != null) {
      points = (json['guidePoints'] as List)
          .map((p) => TracingPoint.fromJson(p as Map<String, dynamic>))
          .toList();
    }

    List<String>? distractors;
    if (json['distractorSymbols'] != null) {
      distractors = (json['distractorSymbols'] as List)
          .map((d) => d.toString())
          .toList();
    }

    List<Map<String, String>>? pairList;
    if (json['pairs'] != null) {
      pairList = (json['pairs'] as List)
          .map((item) => Map<String, String>.from(item as Map))
          .toList();
    }

    return MiniGameConfig(
      type: json['type'] as String? ?? 'tracing',
      targetSymbol: json['targetSymbol'] as String?,
      guidePoints: points,
      targetSound: json['targetSound'] as String?,
      correctSymbol: json['correctSymbol'] as String?,
      distractorSymbols: distractors,
      pairs: pairList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'targetSymbol': targetSymbol,
      'guidePoints': guidePoints?.map((p) => p.toJson()).toList(),
      'targetSound': targetSound,
      'correctSymbol': correctSymbol,
      'distractorSymbols': distractorSymbols,
      'pairs': pairs,
    };
  }
}
