class HotspotItem {
  final String assetPath;
  final String? fallbackImage;
  final String type;
  final String? interactiveSfx;
  final String? motionTrigger;

  const HotspotItem({
    required this.assetPath,
    this.fallbackImage,
    required this.type,
    this.interactiveSfx,
    this.motionTrigger,
  });

  factory HotspotItem.fromJson(Map<String, dynamic> json) {
    return HotspotItem(
      assetPath: json['assetPath'] as String? ?? '',
      fallbackImage: json['fallbackImage'] as String?,
      type: json['type'] as String? ?? 'image',
      interactiveSfx: json['interactiveSfx'] as String?,
      motionTrigger: json['motionTrigger'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assetPath': assetPath,
      'fallbackImage': fallbackImage,
      'type': type,
      'interactiveSfx': interactiveSfx,
      'motionTrigger': motionTrigger,
    };
  }
}
