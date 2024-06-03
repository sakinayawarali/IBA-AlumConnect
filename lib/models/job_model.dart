class Job {
  String company;
  String description;
  String formLink;
  String location;
  String postedBy;
  String title;
  String type;

  Job({
    required this.company,
    required this.description,
    required this.formLink,
    required this.location,
    required this.postedBy,
    required this.title,
    required this.type,
  });

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      company: map['company'],
      description: map['description'],
      formLink: map['formLink'],
      location: map['location'],
      postedBy: map['postedBy'],
      title: map['title'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'description': description,
      'formLink': formLink,
      'location': location,
      'postedBy': postedBy,
      'title': title,
      'type': type,
    };
  }
}
