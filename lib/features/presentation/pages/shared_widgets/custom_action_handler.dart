class ActionCooldownHandler {
  bool _isActionInProgress = false;
  final Duration cooldownDuration;

  ActionCooldownHandler({this.cooldownDuration = const Duration(seconds: 2)});

  bool get isActionInProgress => _isActionInProgress;

  Future<void> handleAction(Function actionFunction,
      {Duration cooldownDuration = const Duration(seconds: 2)}) async {
    if (!_isActionInProgress) {
      _isActionInProgress = true;

      await actionFunction();

      await Future.delayed(cooldownDuration);
      _isActionInProgress = false;
    }
  }
}
