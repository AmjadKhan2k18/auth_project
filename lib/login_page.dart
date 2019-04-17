import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  loginWithFB() {
    debugPrint("Login");
  }

  FirebaseUser user;
  bool isLoggedIn = false;

  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
    });
  }

  void initiateFacebookLogin() async {
    var facebookLogin = FacebookLogin();
    var facebookLoginResult =
        await facebookLogin.logInWithReadPermissions(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
       try{
          AuthCredential authCredential = FacebookAuthProvider.getCredential(
            accessToken: facebookLoginResult.accessToken.token);
        user = await FirebaseAuth.instance.signInWithCredential(authCredential);
        debugPrint(user.displayName);
       }
       catch(e){
         
       }
        onLoginStatusChanged(true);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Facebook Login"),
        ),
        body: Container(
          child: Center(
            child: isLoggedIn
                ? _buildLoggedIn()
                : RaisedButton(
                    child: Text("Login with Facebook"),
                    onPressed: () => initiateFacebookLogin(),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoggedIn() {
    return Container(
      alignment: Alignment.center,
      child: UserAccountsDrawerHeader(
        accountEmail: Text("Logged In"),
        accountName: Text(user.displayName),
        currentAccountPicture: CircleAvatar(
          child: ClipRect(
            child: Image.network(user.photoUrl),
          ),
        ),
      ),
    );
  }
}
