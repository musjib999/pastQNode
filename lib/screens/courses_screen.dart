import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:questions_app/screens/question_screen.dart';
import 'package:questions_app/services/courses.dart';
import 'package:http/http.dart' as http;

class CoursesPage extends StatefulWidget {
  static String id = 'courses';

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  initState() {
    super.initState();
    getCourses();
  }

  Future getCourses() async {
    http.Response response =
        await http.get('http://192.168.43.219:3000/api/v1/course');
    String data = response.body;
    var payload = jsonDecode(data)['payload'];
    return payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$semester Semester Courses'),
        backgroundColor: Color(0xff445B83),
      ),
      body: FutureBuilder(
        future: getCourses(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final payload = snapshot.data;
          List<ListTile> coursesTitleWidgets = [];
          for (var document in payload) {
            var title = document['title'];
            var courseCode = document['code'];
            final courseTitleWidget = ListTile(
              title: Text('$title'),
              subtitle: Text('$courseCode'),
            );
            coursesTitleWidgets.add(courseTitleWidget);
          }
          return ListView(
            children: coursesTitleWidgets,
          );
        },
      ),
    );
  }
}

// class CoursesStreamBuilder extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: getCoursesStream(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         final titles = snapshot.data.documents;
//         List<ListTile> coursesTitleWidgets = [];
//         for (var title in titles) {
//           final courseTitle = title.data['title'];
//           final courseCode = title.data['id'];
//           final documentId = title.documentID;
//           final courseTitleWidget = ListTile(
//             title: Text('$courseTitle'),
//             subtitle: Text('$courseCode'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) {
//                     return QuestionPage(
//                       docId: documentId,
//                     );
//                   },
//                 ),
//               );
//             },
//           );
//           coursesTitleWidgets.add(courseTitleWidget);
//         }
//         return ListView(
//           children: coursesTitleWidgets,
//         );
//       },
//     );
//   }
// }
