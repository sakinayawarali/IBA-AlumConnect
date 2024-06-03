import 'package:cloud_firestore/cloud_firestore.dart';

class Alumni {
  String id;
  String? erp;
  String email;
  String? employmentStatus;
  String? gender;
  String? firstName;
  String? gradBatch;
  String? interests;
  String? lastName;
  String? linkedinLink;
  String? phone;
  String? program;
  JobHistory? jobHistory;
  Location? location;
  String? skills;

  Alumni({
    required this.id,
    this.erp = '',
    required this.email,
    this.gender,
    this.employmentStatus,
    this.firstName,
    this.gradBatch,
    this.interests,
    this.lastName,
    this.linkedinLink,
    this.phone,
    this.program,
    this.jobHistory,
    this.location,
    this.skills,
  });

  factory Alumni.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Alumni(
      id: data['id'],
      erp: data['erp'],
      email: data['email'],
      gender: data['gender'],
      employmentStatus: data['employmentStatus'],
      firstName: data['firstName'],
      gradBatch: data['gradYear'],
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
      skills: data['skills'],
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
      'gradYear': gradBatch,
      'interests': interests,
      'lastName': lastName,
      'linkedinLink': linkedinLink,
      'phone': phone,
      'program': program,
      'jobHistory': jobHistory != null ? jobHistory!.toJson() : null,
      'location': location != null ? location!.toJson() : null,
      'skills': skills,
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
