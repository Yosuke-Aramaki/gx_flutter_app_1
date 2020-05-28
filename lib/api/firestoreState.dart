import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreState {

  static Future<List<String>> getUniversityList() async {
    final List<String> universitys = [];

    QuerySnapshot query = await Firestore.instance.collection('univ_list').getDocuments();
    for (int i = 0; i < query.documents.length; i++) {
      var a = query.documents[i].documentID;
      universitys.add(a);
    }
    return universitys;
  }

  static Future<List<String>> getDepartmentList(String _university) async {
    final List<String> departments = [];

    QuerySnapshot query = await Firestore.instance.collection('univ_list').document(_university).collection('dep_list').getDocuments();
    departments.add('指定しない');
    for (int i = 0; i < query.documents.length; i++) {
      var a = query.documents[i].documentID;
      departments.add(a);
    }
    return departments;
  }

  static Future<List<String>> getLectureList(String _university, String _department) async {
    final List<String> lectures = [];

    QuerySnapshot query = await Firestore.instance.collection('univ_list').document(_university).collection('dep_list').document(_department).collection('lec_list').getDocuments();
    lectures.add('指定しない');
    for (int i = 0; i < query.documents.length; i++) {
      var a = query.documents[i].documentID;
      lectures.add(a);
    }
    return lectures;
  }

  static Future<Map<String, dynamic>> getLectureSummaryInfo(String _university, String _department, String _lecture) async {
    Map<String, dynamic> lectureSummaryInfo;

    DocumentSnapshot docSnapshot =
      await Firestore.instance.collection('univ_list').document(_university).collection('dep_list').document(_department).collection('lec_list').document(_lecture).get();
    lectureSummaryInfo = docSnapshot.data;

    return lectureSummaryInfo;
  }

}

class University {
  String name;
  University(this.name);
}

