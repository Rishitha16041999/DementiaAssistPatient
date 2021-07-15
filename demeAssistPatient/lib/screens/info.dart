import 'package:demeassist_patient/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: primaryViolet,
        ),
        backgroundColor: Colors.white10,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Info".toUpperCase(),
          style: TextStyle(
            color: primaryViolet,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05),
              height: MediaQuery.of(context).size.height * 0.1,
              child: Align(
                alignment: FractionalOffset(0.05, 0.6),
                child: Text(
                  "What is Dementia?",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.794,
              decoration: BoxDecoration(
                color: primaryViolet,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero,
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, left: 15.0, right: 15.0),
                      child: Text(
                        "\t\t\t\t\tDementia is a general term for loss of memory, language, problem-solving and other thinking abilities that are severe enough to interfere with daily life. Alzheimer's is the most common cause of dementia.",
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                          wordSpacing: 5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "\t\t\t\t\tIt is not a single disease; it’s an overall term — like heart disease — that covers a wide range of specific medical conditions, including Alzheimer’s disease. Disorders grouped under the general term “dementia” are caused by abnormal brain changes. These changes trigger a decline in thinking skills, also known as cognitive abilities, severe enough to impair daily life and independent function. They also affect behavior, feelings and relationships.",
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                          wordSpacing: 5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SecondPage(),
            ),
          );
        },
        tooltip: "See Symptoms",
        backgroundColor: Colors.white,
        child: FaIcon(
          FontAwesomeIcons.arrowRight,
          color: primaryViolet,
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: primaryViolet,
        ),
        backgroundColor: Colors.white10,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Info".toUpperCase(),
          style: TextStyle(
            color: primaryViolet,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05),
              height: MediaQuery.of(context).size.height * 0.1,
              child: Align(
                alignment: FractionalOffset(0.05, 0.6),
                child: Text(
                  "Symptoms of Dementia",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.794,
              decoration: BoxDecoration(
                color: primaryViolet,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero,
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, left: 15.0, right: 15.0),
                      child: Text(
                        "Signs of dementia can vary greatly. Examples include:",
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                          wordSpacing: 5,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Problems with short-term memory',
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                          wordSpacing: 5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Text(
                        'Memory loss',
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                          wordSpacing: 5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Text(
                        'Difficulty concentrating',
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                          wordSpacing: 5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Text(
                        'Finding hard to carry out familiar daily tasks',
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                          wordSpacing: 5,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Text(
                        'Struggling to follow a conversation or find the right word',
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                          wordSpacing: 5,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Text(
                        'Being confused about time and place',
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                          wordSpacing: 5,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Text(
                        'Mood changes',
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                          wordSpacing: 5,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ThirdPage(),
            ),
          );
        },
        tooltip: "See Diagnosis",
        backgroundColor: Colors.white,
        child: FaIcon(
          FontAwesomeIcons.arrowRight,
          color: primaryViolet,
        ),
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  const ThirdPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: primaryViolet,
        ),
        backgroundColor: Colors.white10,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Info".toUpperCase(),
          style: TextStyle(
            color: primaryViolet,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05),
              height: MediaQuery.of(context).size.height * 0.1,
              child: Align(
                alignment: FractionalOffset(0.05, 0.6),
                child: Text(
                  "Diagnosis of dementia",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.794,
              decoration: BoxDecoration(
                color: primaryViolet,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero,
                  topRight: Radius.circular(50),
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                  child: Text(
                    "\t\t\t\t\tThere is no one test to determine if someone has dementia. Doctors diagnose Alzheimer's and other types of dementia based on a careful medical history, a physical examination, laboratory tests, and the characteristic changes in thinking, day-to-day function and behavior associated with each type. Doctors can determine that a person has dementia with a high level of certainty. But it's harder to determine the exact type of dementia because the symptoms and brain changes of different dementias can overlap. In some cases, a doctor may diagnose 'dementia' and not specify a type. If this occurs, it may be necessary to see a specialist such as a neurologist, psychiatrist, psychologist or geriatrician.",
                    style: TextStyle(
                      fontSize: 21,
                      color: Colors.white,
                      wordSpacing: 5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
