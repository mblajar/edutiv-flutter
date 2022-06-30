import 'package:flutter/material.dart';

import '../model/course/course_model.dart';
import '../screens/course/learning_course_screen.dart';

class EnrollBottomBar extends StatelessWidget {
  const EnrollBottomBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final courseDetail =
        ModalRoute.of(context)!.settings.arguments as CourseModel;
    return Container(
      width: double.infinity,
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(62, 158, 158, 158),
            blurRadius: 15,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LearningCourseScreen(
                courseId: courseDetail,
                initURL: courseDetail.sections?[0].materials?[0].url,
              ),
            ),
          ),
          //     Navigator.pushNamed(
          //   context,
          //   '/learningCourse',
          //   arguments: courseDetail,
          // ),
          child: const Text('ENROLL COURSE'),
        ),
      ),
    );
  }
}
