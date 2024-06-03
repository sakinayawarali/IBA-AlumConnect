class Connection {
  String status;
  String user1ERP;
  String user2ERP;

  Connection({
    required this.status,
    required this.user1ERP,
    required this.user2ERP,
  });

  factory Connection.fromMap(Map<String, dynamic> map) {
    return Connection(
      status: map['status'],
      user1ERP: map['user1ERP'],
      user2ERP: map['user2ERP'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'user1ERP': user1ERP,
      'user2ERP': user2ERP,
    };
  }
}
