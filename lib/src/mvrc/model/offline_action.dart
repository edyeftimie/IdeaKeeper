class OfflineAction {
  final String action;
  final int entityId;
  final int id;

  OfflineAction({required this.action, required this.entityId, required this.id});

  factory OfflineAction.fromJson(Map<String, dynamic> json) {
    return OfflineAction(
      id: json['id'],
      action: json['action'],
      entityId: json['entityId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'action': action,
      'entityId': entityId,
    };
  }
}


