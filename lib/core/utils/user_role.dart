enum UserRole {
  ceo(1),
  accountant(2),
  sales(3),
  technician(4);

  final int id;
  const UserRole(this.id);

  static UserRole fromId(int id) {
    return UserRole.values.firstWhere((role) => role.id == id, orElse: () => UserRole.sales);
  }

  String get nameAr {
    switch (this) {
      case UserRole.ceo:
        return 'المدير التنفيذي';
      case UserRole.accountant:
        return 'محاسب';
      case UserRole.sales:
        return 'مبيعات (Sales)';
      case UserRole.technician:
        return 'فني (Technician)';
    }
  }
}
