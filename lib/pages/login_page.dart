import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/Signup.dart';
import 'package:flutter_app/pages/Student.dart';
import 'package:flutter_app/pages/TeacherHome.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginPage extends StatefulWidget {
@override
_LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage>
with SingleTickerProviderStateMixin {
AnimationController _cardAnimationController;
Animation<double> _loginCard;
Animation<double> _signUpCard;
final scaffoldKey = new GlobalKey<ScaffoldState>();
final formKey = new GlobalKey<FormState>();
final FirebaseAuth auth = FirebaseAuth.instance;
FocusNode focusNode1 = new FocusNode();
FocusNode focusNode2 = new FocusNode();
String _email;
String _password;
Map data;
final successSnackBar = new SnackBar(
duration: Duration(milliseconds: 1000),
shape:
RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.00)),
backgroundColor: Colors.lightGreen,
elevation: 2.0,
content: new Text("Logged in ",
textAlign: TextAlign.center,
style: TextStyle(
fontFamily: 'BalooChettan2',
color: Colors.white,
fontSize: 20.00)));
final errSnackBar = new SnackBar(
backgroundColor: Colors.red,
content: new Text("Login Failed",
style: TextStyle(
fontFamily: 'BalooChettan2',
color: Colors.white,
fontSize: 20.00)));
final incorrectPSnackBar = new SnackBar(
duration: Duration(milliseconds: 1000),
shape:
RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.00)),
backgroundColor: Colors.red,
elevation: 2.0,
content: new Text("Incorrect Password",
style: TextStyle(
fontFamily: 'BalooChettan2',
color: Colors.white,
fontSize: 20.00)));
final noUserSnackBar = new SnackBar(
duration: Duration(milliseconds: 1000),
shape:
RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.00)),
elevation: 2.0,
backgroundColor: Colors.red,
content: new Text("User not Found",
style: TextStyle(
fontFamily: 'BalooChettan2',
color: Colors.white,
fontSize: 20.00)));
@override
void initState() {
super.initState();
final checkemail=FirebaseDatabase.instance.reference();
checkemail.child("Teacher_account").once().then((snap){
  data = snap.value;
});
}
@override
Widget build(BuildContext context) {
return new Scaffold(
resizeToAvoidBottomInset: true,
    resizeToAvoidBottomPadding : true,
key: scaffoldKey,
backgroundColor: Colors.white,
body: SingleChildScrollView(
child: new Container(
decoration: new BoxDecoration(
borderRadius: new BorderRadius.circular(10.00),
gradient: LinearGradient(
begin: Alignment.topCenter,
end: Alignment.bottomCenter,
tileMode: TileMode.clamp,
stops: [
0,
0.5,
0.8
],
colors: [
Colors.blueAccent,
Colors.lightBlue,
const Color.fromARGB(255, 255, 255, 255)
])),
child: new Stack(
children: <Widget>[
new Column(
crossAxisAlignment: CrossAxisAlignment.center,
mainAxisSize: MainAxisSize.max,
mainAxisAlignment: MainAxisAlignment.center,
//mainAxisAlignment: MainAxisAlignment.center,
children: <Widget>[
Padding(
padding: const EdgeInsets.only(top: 50.00, bottom: 20.00),
child: new Image(
image: new AssetImage("assets/college_logo.png"),
alignment: Alignment.topCenter,
height: 200,
width: 150,
),
),
new Card(
margin: new EdgeInsets.only(
left: 25.00, right: 25.00, bottom: 20.00, top: 20.00),
elevation: 10.0,
color: Colors.white,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(10.0),
),
child: Container(
child: new Form(
key: formKey,
autovalidate: true,
child: new Theme(
data: new ThemeData(
brightness: Brightness.light,
primarySwatch: Colors.blue,
inputDecorationTheme:
new InputDecorationTheme(
labelStyle: new TextStyle(
color: Colors.blue,
fontSize: 15.00))),
child: new Column(
crossAxisAlignment: CrossAxisAlignment.center,
mainAxisAlignment: MainAxisAlignment.center,
mainAxisSize: MainAxisSize.max,
children: <Widget>[
new Text(
"LOGIN",
style: TextStyle(
fontFamily: 'BalooChettan2',
color: Colors.black54,
fontSize: 40.00,
fontWeight: FontWeight.bold,
letterSpacing: 2.0),
),
new Padding(padding: EdgeInsets.all(20.00)),
Padding(
padding: const EdgeInsets.only(
left: 20.0, right: 20.0),
child: new Column(
children: <Widget>[
new TextFormField(
focusNode: focusNode1,
enableSuggestions: true,
style: TextStyle(
fontFamily: 'BalooChettan2',
color: Colors.black54,
fontSize: 20.00),
decoration: new InputDecoration(
contentPadding: EdgeInsets.only(
left: 20.00, right: 20.00),
border: OutlineInputBorder(
borderRadius:
BorderRadius.circular(
10.00)),
labelText: "Enter Email",
labelStyle: new TextStyle(
fontWeight: FontWeight.bold,
color: Colors.blue,
fontSize: 15.00)),
keyboardType:
TextInputType.emailAddress,
validator: validateEmail,
onSaved: (val) {
setState(() => _email = val);
}),
new Padding(
padding: EdgeInsets.all(15.00)),
new TextFormField(
focusNode: focusNode2,
style: TextStyle(
fontFamily: 'BalooChettan2',
color: Colors.black54,
fontSize: 20.00),
decoration: new InputDecoration(
contentPadding: EdgeInsets.only(
left: 20.00, right: 20.00),
border: OutlineInputBorder(
borderRadius:
BorderRadius.circular(
10.00)),
labelText: "Enter Password",
labelStyle: TextStyle(
fontWeight: FontWeight.bold,
color: Colors.blue,
fontSize: 15.00)),
keyboardType: TextInputType.text,
obscureText: true,
validator: validatePassword,
onSaved: (val) {
setState(() => _password = val);
}),
],
),
),
new Padding(
padding:
const EdgeInsets.only(top: 30.00)),
new RaisedButton(
shape: new RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(100.00)),
splashColor: Colors.blue,
onPressed: () async {
if (formKey.currentState.validate()) {
formKey.currentState.save();
signIn(_email, _password)
    .then((user) async {
SharedPreferences prefs = await SharedPreferences.getInstance();
prefs.setBool('login', true);
var e;
if (user != null) {
String uname = user.email;
prefs.setString('email', uname);
setState(() {
scaffoldKey.currentState
    .showSnackBar(
successSnackBar);
});
e=uname.split('@');
bool v=false;
for (final key in data.keys) {
if(e[0].toString()==key.toString()){
v=true;
break;
}
}

//sleep(const Duration(seconds:3));
if(v==true) {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) =>
stud(),
));
}else{
Navigator.push(
context,
MaterialPageRoute(
builder: (context) =>
Student(),
));
}
} else {
scaffoldKey.currentState
    .showSnackBar(errSnackBar);
}

});
}
},
elevation: 2.0,
padding: EdgeInsets.only(
left: 50.00,
right: 50.00,
top: 15.00,
bottom: 15.00),
color: Color.fromARGB(255, 52, 127, 228),
textColor: Colors.white,
child: new Text("Sign In",
textAlign: TextAlign.center)),
new Padding(
padding: EdgeInsets.only(bottom: 15.00))
],
)),
),
),
),
new Padding(padding: EdgeInsets.only(top: 20.00)),
new MaterialButton(
onPressed: () => {},
shape: new RoundedRectangleBorder(
borderRadius: BorderRadius.circular(50.00)),
child: new Text("Forgot Password?",
style: TextStyle(
fontFamily: 'BalooChettan2',
color: Colors.black54,
fontSize: 20.00)),
), //Forgot password button
new MaterialButton(
onPressed: () => {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => Signup(),
))
},
shape: new RoundedRectangleBorder(
borderRadius: BorderRadius.circular(50.00)),
child: new Text("Sign Up",
style: TextStyle(
fontFamily: 'BalooChettan2',
color: Colors.black54,
fontSize: 20.00)),
) //Forgot password button
],
)
],
),
),
));
}

Future<FirebaseUser> signIn(String email, String password) async {
try {
AuthResult result = await auth.signInWithEmailAndPassword(
email: email, password: password);
FirebaseUser user = result.user;
assert(user != null);
assert(await user.getIdToken() != null);

final FirebaseUser currentUser = await auth.currentUser();
assert(user.uid == currentUser.uid);
return user;
} catch (e) {
handleError(e);
return null;
}
} //Firebase Sign in

String validateEmail(String value) {
Pattern pattern =
r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
RegExp regex = new RegExp(pattern);
if (value.isEmpty || !regex.hasMatch(value))
return 'Invalid Email';
else
return null;
}

String validatePassword(String value) {
if (value.trim().isEmpty) {
return 'Password cannot be empty';
} else if (value.length < 6) {
return 'Password too short';
}
return null;
}

handleError(PlatformException error) {
switch (error.code) {
case 'ERROR_USER_NOT_FOUND':
setState(() {
scaffoldKey.currentState.showSnackBar(noUserSnackBar);
});
break;
case 'ERROR_WRONG_PASSWORD':
setState(() {
scaffoldKey.currentState.showSnackBar(incorrectPSnackBar);
});
break;
}
} //Sign in Error handling
}