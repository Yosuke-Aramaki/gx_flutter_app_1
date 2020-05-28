import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreState {

  static Future<List<String>> getUniversityList() async {
    final List<String> universityList = [];

    QuerySnapshot query = await Firestore.instance.collection('univ_list').getDocuments();
    for (int i = 0; i < query.documents.length; i++) {
      var a = query.documents[i].documentID;
      universityList.add(a);
    }
    return universityList;
  }

  static Future<List<String>> getDepartmentList(String _university) async {
    final List<String> departmentList = [];

    QuerySnapshot query = await Firestore.instance.collection('univ_list').document(_university).collection('dep_list').getDocuments();
    departmentList.add('指定しない');
    for (int i = 0; i < query.documents.length; i++) {
      var a = query.documents[i].documentID;
      departmentList.add(a);
    }
    return departmentList;
  }

  static Future<List<String>> getLectureList(String _university, String _department) async {
    final List<String> lectureList = [];

    QuerySnapshot query = await Firestore.instance.collection('univ_list').document(_university).collection('dep_list').document(_department).collection('lec_list').getDocuments();
    lectureList.add('指定しない');
    for (int i = 0; i < query.documents.length; i++) {
      var a = query.documents[i].documentID;
      lectureList.add(a);
    }
    return lectureList;
  }

  static Future<Map<String, dynamic>> getLectureSummaryInfo(String _university, String _department, String _lecture) async {
    Map<String, dynamic> lecSummaryInfo;

    DocumentSnapshot docSnapshot =
      await Firestore.instance.collection('univ_list').document(_university).collection('dep_list').document(_department).collection('lec_list').document(_lecture).get();
    lecSummaryInfo = docSnapshot.data;

    return lecSummaryInfo;
  }

}

class UniversityModel {
  String name;
  UniversityModel(this.name);
}

