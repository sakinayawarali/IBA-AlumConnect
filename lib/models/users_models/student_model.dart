import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  String id;
  String? erp;
  String email;
  String? employmentStatus;
  String? gender;
  String? firstName;
  String? gradYear;
  String? interests;
  String? lastName;
  String? linkedinLink;
  String? phone;
  String? program;
  JobHistory? jobHistory;
  Location? location;
  Project? project;

  Student({
    required this.id,
    this.erp = '',
    required this.email,
    this.gender,
    this.employmentStatus,
    this.firstName,
    this.gradYear,
    this.interests,
    this.lastName,
    this.linkedinLink,
    this.phone,
    this.program,
    this.jobHistory,
    this.location,
    this.project,
  });

  factory Student.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Student(
      id: data['id'],
      erp: data['erp'],
      email: data['email'],
      gender: data['gender'],
      employmentStatus: data['employmentStatus'],
      firstName: data['firstName'],
      gradYear: data['gradYear'],
      interests: data['interests'],
      lastName: data['lastName'],
      linkedinLink: data['linkedinLink'],
      phone: data['phone'],
      program: data['program'],
      jobHistory: data['jobHistory'] != null
          ? JobHistory.fromMap(data['jobHistory'])
          : null,
      location:
          data['location'] != null ? Location.fromMap(data['location']) : null,
      project:
          data['project'] != null ? Project.fromMap(data['project']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'erp': erp,
      'email': email,
      'gender': gender,
      'employmentStatus': employmentStatus,
      'firstName': firstName,
      'gradYear': gradYear,
      'interests': interests,
      'lastName': lastName,
      'linkedinLink': linkedinLink,
      'phone': phone,
      'program': program,
      'jobHistory': jobHistory != null ? jobHistory!.toJson() : null,
      'location': location != null ? location!.toJson() : null,
      'project': project != null ? project!.toJson() : null,
    };
  }
}

class JobHistory {
  String? company;
  String? endDate;
  String? position;
  String? startDate;

  JobHistory({
    this.company,
    this.endDate,
    this.position,
    this.startDate,
  });

  factory JobHistory.fromMap(Map<String, dynamic> map) {
    return JobHistory(
      company: map['company'],
      endDate: map['endDate'],
      position: map['position'],
      startDate: map['startDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'endDate': endDate,
      'position': position,
      'startDate': startDate,
    };
  }
}

class Location {
  String? city;
  String? country;

  Location({
    this.city,
    this.country,
  });

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      city: map['city'],
      country: map['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'country': country,
    };
  }
}

class Project {
  String? details;
  String? title;
  String? skills;

  Project({
    this.details,
    this.title,
    this.skills,
  });

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      details: map['details'],
      title: map['title'],
      skills: map['skills'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'details': details,
      'title': title,
      'skills': skills,
    };
  }
}
