import 'package:flutter/material.dart';

class RtlHelper {
  static bool isRtlSubject(String subject) {
    return subject.toLowerCase().trim() == 'urdu';
  }

  static TextDirection getDirection(bool isRtl) {
    return isRtl ? TextDirection.rtl : TextDirection.ltr;
  }
}
