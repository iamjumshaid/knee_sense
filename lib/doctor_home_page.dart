import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'partials/doctor_header.dart';
import 'partials/doctor_footer.dart';
import 'partials/invite_patient.dart';
import 'patient_detail_page.dart';

class DoctorHomePage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _showInviteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InvitePatient();
      },
    );
  }

  void _navigateToPatientDetail(BuildContext context, DocumentSnapshot doc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailPage(
          patientId: doc.id,
          name: doc['name'],
          contact: doc['contact'],
          problem: doc['problem'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: 'Knee Sense'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'List of Patients',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showInviteDialog(context),
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('Invite', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: _firestore.collection('patients').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No patients found.'));
                  }
                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      return GestureDetector(
                        onTap: () => _navigateToPatientDetail(context, doc),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).primaryColor.withOpacity(0.15),
                                Theme.of(context).primaryColor.withOpacity(0.2),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Theme.of(context).primaryColor,
                                      child: Icon(Icons.person, color: Colors.white),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      doc['name'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(Icons.phone, color: Colors.black54),
                                    SizedBox(width: 5),
                                    Text(doc['contact']),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.healing, color: Colors.black54),
                                    SizedBox(width: 5),
                                    Expanded(child: Text(doc['problem'])),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppFooter(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            // Already on home page, do nothing
          } else if (index == 1) {
            Navigator.pushNamed(context, '/exercises');
          } else if (index == 2) {
            // Implement navigation to profile page
          }
        },
      ),
    );
  }
}
