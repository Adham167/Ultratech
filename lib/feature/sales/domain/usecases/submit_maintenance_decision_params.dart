class SubmitMaintenanceDecisionParams {
  final int maintenanceId;
  final int decision; // 2: Approved, 3: Postponed, 4: Rejected
  final DateTime? postponedToDate;
  final String? notes;

  SubmitMaintenanceDecisionParams({
    required this.maintenanceId,
    required this.decision,
    this.postponedToDate,
    this.notes,
  });
}
