class CustomerEntity {
  final String id;
  final String name;
  final String phone;
  final DateTime createdAt;

  const CustomerEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.createdAt,
  });
}
