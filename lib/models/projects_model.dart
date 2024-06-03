class Project {
  String createdBy;
  String description;
  String funds;
  String title;
  String type;

  Project({
    required this.createdBy,
    this.description = '',
    this.funds = '',
    required this.title,
    this.type = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'createdBy': createdBy,
      'description': description,
      'funds': funds,
      'title': title,
      'type': type,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      createdBy: json['createdBy'],
      description: json['description'] ?? '',
      funds: json['funds'] ?? '',
      title: json['title'],
      type: json['type'] ?? '',
    );
  }
}
