class MaintenanceDecisionRequestModel {
  final int decision;
  final String? postponedToDate;
  final String? notes;

  MaintenanceDecisionRequestModel({
    required this.decision,
    this.postponedToDate,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'decision': decision,
      if (postponedToDate != null) 'postponedToDate': postponedToDate,
      if (notes != null) 'notes': notes,
    };
  }
}
