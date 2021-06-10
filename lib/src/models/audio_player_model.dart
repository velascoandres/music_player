import 'package:flutter/material.dart';

class AudioPlayerModel with ChangeNotifier {
  bool _playing = false;
  late AnimationController _controller;
  Duration _songDuration = new Duration(milliseconds: 0);
  Duration _currentDuration = new Duration(milliseconds: 0);


  String get songTotalDuration => this.printDuration(this._songDuration);

  String get totalCurrentDuration => this.printDuration(this._currentDuration);

  AnimationController get controller => this._controller;

  bool get playing => this._playing;

  Duration get songDuration => this._songDuration;

  Duration get currentDuration => this._currentDuration;

  double get songPercent => (this._songDuration.inSeconds == 0)
      ? 0
      : this.currentDuration.inSeconds / this.songDuration.inSeconds;

  set playing(bool playing) {
    this._playing = playing;
    notifyListeners();
  }

  set controller(AnimationController value) {
    this._controller = value;
  }

  set songDuration(Duration duration) {
    this._songDuration = duration;
    notifyListeners();
  }

  set currentDuration(Duration duration) {
    this._currentDuration = duration;
    notifyListeners();
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}
