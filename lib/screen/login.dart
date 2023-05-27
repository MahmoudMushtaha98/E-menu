import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:newemenu/model/meal_model.dart';
import 'package:newemenu/screen/signup.dart';

import '../widget/textbutton.dart';
import 'choice_screen.dart';
import 'menu_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey=GlobalKey<FormState>();
  final _formKey2=GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late final String emailID;
  bool _saving = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  List<String> catigoris = [];
  List<int> catigoryCounter = [];
  List<MealModel> meals = [];
  late String id;

  bool emailValidator(String email){
    final bool emailValid =
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    return emailValid;
  }
  bool passwordValidator(String password){
    final bool passwordValid =
    RegExp(r"^.{6,}$").hasMatch(password);

    return passwordValid;
  }

  List sortList(List<int> myList, List<String> mainList) {
    for (int i = 0; i < myList.length - 1; i++) {
      for (int j = 0; j < myList.length - i - 1; j++) {
        if (myList[j] > myList[j + 1]) {
          int temp = myList[j];
          String mainTemp = mainList[j];
          myList[j] = myList[j + 1];
          mainList[j] = mainList[j + 1];
          myList[j + 1] = temp;
          mainList[j + 1] = mainTemp;
        }
      }
    }
    return mainList;
  }

  Future<void> _submitForm() async{
    if (_formKey.currentState!.validate()&&_formKey2.currentState!.validate()) {
      await loginGenerate();
    }
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SingleChildScrollView(
          child: Column(
              children: [
            SizedBox(
              width: double.infinity,
              height: sizeHeight * 0.5,
              child: Image.asset('images/E.png', fit: BoxFit.cover),
            ),
            Form(
              key: _formKey,
              child: SizedBox(
                width: sizeWidth * 0.8,
                height: sizeHeight * 0.07,
                child: TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    label: Text(
                      'Email',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(212, 175, 55, 1),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter yor email';
                    }else if(emailValidator(value)==true) {
                      return null;
                    }else{
                      return 'Email not valid';
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: sizeHeight * 0.05,
            ),
            Form(
              key: _formKey2,
              child: SizedBox(
                width: sizeWidth * 0.8,
                height: sizeHeight * 0.07,
                child: TextFormField(
                  controller: _password,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    label: Text(
                      'Password',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(212, 175, 55, 1),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  validator: (value) {
                    if(value!.isEmpty){
                      return 'Please enter yor password';
                    }else if(passwordValidator(value)==false){
                      return 'Password not correct';
                    }else{
                      return null;
                    }
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    width: double.infinity,
                  ),
                  const SizedBox(height: 50.0),
                  TextButtonWidget(
                    text: 'Login',
                    callback: () async{
                      await _submitForm();
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextButtonWidget(
                    text: 'Sign Up',
                    callback: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ));
                    },
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> loginGenerate() async {
    setState(() {
      _saving = true;
    });

    try {
      catigoris.clear();
      catigoryCounter.clear();
      final user = await _auth.signInWithEmailAndPassword(
          email: _email.text, password: _password.text);
      id=user.user!.uid;
      final cat = await _firestore.collection('Categories').get();
      for (var category in cat.docs) {
        if (category.get('EmailID') == user.user!.uid) {
          catigoris.add(category.get('CategoryName'));
          catigoryCounter.add(category.get('counter'));
        }
      }
      sortList(catigoryCounter, catigoris);
      meals.clear();
      final meal = await _firestore.collection('All').get();
      for (var meall in meal.docs) {
        if (meall.get('emailID') == user.user!.uid) {
          meals.add(MealModel(
              counter: meall.get('counter'),
              mealName: meall.get('mealName'),
              mealComponents: meall.get('mealComponents'),
              price: meall.get('price'),
              type: meall.get('type')));
        }
      }

      if (user != null && user.user != null) {
        setState(() {
          _saving = false;
        });
        _navigate(user.user!);
      }
    } catch (e) {
      possibleError(e);
      setState(() {
        _saving=false;
      });
    }
  }

  void possibleError(Object e) {
    if (kDebugMode) {
      if(e is FirebaseAuthException && e.toString().contains('firebase_auth/network-request-failed')){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('The internet is disconnected'))
        );
      }else if(e is FirebaseAuthException && e.toString().contains('The password is invalid or the user does not have a password')){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('The password is not correct'))
        );
      }if(e is FirebaseAuthException && e.toString().contains('There is no user record corresponding to this identifier')){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('The email is not correct'))
        );
      }
      else {
        print("suiiiii -${e.toString()}- suiiiii");
      }
    }
  }

  void _navigate(User user) async {
    try {
      var where =
          _firestore.collection('Users').where("email", isEqualTo: user.email);
      var result = (await where.get()).docs.toList();
      if (result.isNotEmpty) {
        var data = result.first;
        bool isMerchant = data.data()["isMerchant"] ?? false;
        if (isMerchant) {
          if(mounted) {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ChoiceScreen(
                    meals: meals, catigories: catigoris, emailId: id),));
          }
        } else {
          if(mounted) {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ChoiceScreen(
                    meals: meals, catigories: catigoris, emailId: id),));
          }
                }
      }else{
        if(mounted) {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              ChoiceScreen(
                  meals: meals, catigories: catigoris, emailId: id),));
        }

      }
    } catch (_) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MeanuScreen(catigories: catigoris, meals: meals,emailId: id),
          ));
    }
  }
}
