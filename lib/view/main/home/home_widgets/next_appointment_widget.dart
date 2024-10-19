import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';

class NextAppointmentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('modules')
            .doc('current')
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Text('No data found');
          }

          // Access data safely
          var moduleData = snapshot.data!.data() as Map<String, dynamic>?;

          if (moduleData == null) {
            return Text('No data available');
          }

          // Access fields safely
          String moduleName = moduleData['moduleName'] ?? 'Not Available';
          String moduleInfo = moduleData['moduleInfo'] ?? 'Not Available';
          String buttonText = moduleData['buttonText'] ?? 'Not Available';
          String moduleImage =
              moduleData['moduleImage'] ?? 'assets/images/basic_white.png';
          int uploadedLecturesCount = moduleData['uploadedLecturesCount'] ?? 3;
          int moduleLecturesCount = moduleData['moduleLecturesCount'] ?? 11;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progress Tracker',
                style: const TextStyle(
                  fontFamily: "Garet",
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Material(
                elevation: 5.0,
                shadowColor: Colors.grey,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.secondaryColor.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [
                        ColorManager.mainColor,
                        ColorManager.secondaryColor,
                      ],
                      begin: const FractionalOffset(0.8, 0.9),
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 135,
                            padding: const EdgeInsets.only(left: 12, top: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  moduleName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontFamily: "Garet",
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      height: 1.2),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  moduleInfo,
                                  maxLines: 2,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Garet',
                                    fontStyle: FontStyle.italic,
                                    color: ColorManager.LighterWhite,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                // ModuleNavigator(
                                //   moduleDocumentId: moduleName,
                                //   buttonWidget: Container(
                                //     width: 110,
                                //     margin: const EdgeInsets.only(
                                //       top: 8,
                                //     ),
                                //     padding: const EdgeInsets.symmetric(
                                //         horizontal: 12, vertical: 4),
                                //     decoration: const BoxDecoration(
                                //       color: Colors.white,
                                //       borderRadius: BorderRadius.all(
                                //         Radius.circular(50),
                                //       ),
                                //     ),
                                //     child: Center(
                                //       child: Text(
                                //         buttonText,
                                //         style: const TextStyle(
                                //           color: ColorManager.mainColor,
                                //           fontWeight: FontWeight.w700,
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                //   quizDocumentName: 'sampleQuiz',
                                //   examDocumentName: 'sampleQuiz',
                                // )
                              ],
                            ),
                          ),
                          Container(
                            height: 120,
                            width: 90,
                            padding:
                                EdgeInsets.only(top: 24, bottom: 16, right: 12),
                            child: Image(
                              image: AssetImage(
                                moduleImage,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                    "${uploadedLecturesCount}/${moduleLecturesCount}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Garet',
                                      color: ColorManager.LighterWhite,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                    '${(uploadedLecturesCount / moduleLecturesCount * 100).toInt()}%',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: ColorManager.LightWhite,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsetsDirectional.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),
                                border:
                                    Border.all(color: Colors.white, width: 1.5),
                              ),
                              child: LinearProgressIndicator(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),
                                minHeight: 10,
                                color: ColorManager.mainColor,
                                value:
                                    uploadedLecturesCount / moduleLecturesCount,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
