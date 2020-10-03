import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import '../utils/colors.dart';
import '../ui/infoDialog.dart';
import '../ui/backTopBar.dart';
import '../ui/myButton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _codeFormKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _login = false;
  String _locale = "PT";
  String _countryCode = "+351";
  bool _codeSent = false;
  bool _askedCode = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String _phoneNumber;
  bool _signingin = false;
  String _verificationId;
  bool _codeReady = false;
  int _timeOut = TIMEOUT_IN_SECONDS;
  final FocusNode _codeFocusNode = new FocusNode();
  static const TIMEOUT_IN_SECONDS = 90;
  static const HELP_DIALOG = InfoDialog(
    "How to sign in?",
    'To sign in, enter your phone number with the correct country code. You can select your country code by clicking on the left indicator.\nAfter pressing "Sign In", a verification code will be sent to the provided phone number. Enter the verification code and press "Confirm".',
  );

  @override
  void initState() {
    super.initState();
    setLocale();
  }

  void _startTimer() {
    setState(() {
      _codeReady = false;
      _timeOut = TIMEOUT_IN_SECONDS;
    });
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        if (_timeOut > 0) {
          setState(() {
            _timeOut--;
          });
        } else {
          timer.cancel();
          setState(() {
            _codeReady = true;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  void setLocale() {
    final List<Locale> systemLocales = WidgetsBinding.instance.window.locales;
    String isoCountryCode = systemLocales.first.countryCode;
    _locale = isoCountryCode;
  }

  void signInWithCredential(AuthCredential credential) async {
    setState(() {
      _signingin = true;
    });
    await auth
        .signInWithCredential(credential)
        .then((UserCredential userCredential) {
      Navigator.of(context).pushReplacementNamed("/home");
    }).catchError((onError) {
      print(onError);
    });
    setState(() {
      _signingin = false;
    });
  }

  void loginWithPhone(String phoneNumber) {
    setState(() {
      _askedCode = true;
    });
    auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: TIMEOUT_IN_SECONDS),
      verificationCompleted: (PhoneAuthCredential credential) async {
        setState(() {
          _codeController.text = credential.smsCode;
        });
        signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e);
        setState(() {
          _askedCode = false;
        });
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            duration: Duration(seconds: 3),
            content: Text("Failed to send verification code..."),
          ),
        );
      },
      codeSent: (String verificationId, int resendToken) {
        _verificationId = verificationId;
        _startTimer();
        setState(() {
          _codeSent = true;
          _phoneNumber = _phoneController.text;
        });
        _codeFocusNode.requestFocus();
      },
      codeAutoRetrievalTimeout: (value) {
        print(value);
      },
    );
  }

  Widget _loginCredentials() => AnimatedContainer(
        alignment: Alignment.center,
        curve: Curves.fastOutSlowIn,
        duration: Duration(
          milliseconds: 250,
        ),
        height: _login ? 190 : 0,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Phone number",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey.withAlpha(100),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 48,
                            width: 100,
                            child: CountryCodePicker(
                              onChanged: (CountryCode countryCode) {
                                _countryCode = countryCode.dialCode;
                              },
                              initialSelection: _locale,
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                              textStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: Form(
                              key: _phoneFormKey,
                              child: TextFormField(
                                validator: (text) {
                                  if (text.trim().isEmpty)
                                    return "Insert a phone number";
                                  return null;
                                },
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(color: Colors.white),
                                maxLines: 1,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (text) {
                                  if (text.length == 9) {
                                    setState(() {
                                      _codeSent = (text == _phoneNumber);
                                      _askedCode = _codeSent;
                                    });
                                  } else {
                                    if (_codeSent) {
                                      setState(() {
                                        _codeSent = false;
                                        _askedCode = false;
                                      });
                                    }
                                  }
                                },
                                decoration: InputDecoration(
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      bottom: 11, top: 11, right: 15),
                                  hintText: 'Type here...',
                                  errorStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  hintStyle: TextStyle(color: Colors.white30),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                curve: Curves.fastOutSlowIn,
                duration: Duration(milliseconds: 250),
                height: _codeSent ? 150 : 0,
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24),
                        Text(
                          "Verification code",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Stack(
                          children: [
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.grey.withAlpha(100),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            Form(
                              key: _codeFormKey,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: TextFormField(
                                  focusNode: _codeFocusNode,
                                  keyboardType: TextInputType.phone,
                                  controller: _codeController,
                                  maxLines: 1,
                                  onFieldSubmitted: (text) {
                                    _loginWithCode();
                                  },
                                  validator: (text) {
                                    if (text.trim().length == 0)
                                      return "Insert the validation code";
                                    if (text.trim().length != 6)
                                      return "Verify the inserted code";
                                    return null;
                                  },
                                  style: TextStyle(color: Colors.white),
                                  onChanged: (text) {
                                    setState(() {});
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(6),
                                  ],
                                  decoration: InputDecoration(
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 15,
                                        bottom: 11,
                                        top: 11,
                                        right: 15),
                                    hintText: 'Type here...',
                                    errorStyle:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    hintStyle: TextStyle(color: Colors.white30),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Future<bool> _willPopCallback() async {
    FocusScope.of(context).unfocus();
    if (_login) {
      setState(() {
        _login = false;
      });
      return false;
    } else {
      return true;
    }
  }

  String _timeOutText() =>
      "${(_timeOut ~/ 60).toString().padLeft(2, "0")}:${(_timeOut % 60).toString().padLeft(2, "0")}";

  void _loginWithCode() {
    if (_codeFormKey.currentState.validate()) {
      PhoneAuthCredential _credential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: _codeController.text.trim());
      signInWithCredential(_credential);
    }
  }

  void _handleSignInButton() {
    if (!_login) {
      setState(() {
        _login = true;
      });
    } else {
      if (_codeSent) {
        _loginWithCode();
      } else {
        if (_phoneFormKey.currentState.validate()) {
          loginWithPhone(_countryCode + _phoneController.text);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SafeArea(
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 250),
                      curve: Curves.fastOutSlowIn,
                      padding: EdgeInsets.symmetric(
                        vertical: 80,
                        horizontal: 32,
                      ),
                      height: _login ? 0 : 400,
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "Higeia",
                              style: TextStyle(
                                fontSize: 62,
                                fontWeight: FontWeight.bold,
                                color: mainGreen,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Your smart health assistant",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: mainGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipPath(
                      clipper: OvalTopBorderClipper(),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 250),
                        height: _login
                            ? 500 + MediaQuery.of(context).viewInsets.bottom
                            : 450,
                        width: width,
                        color: Colors.orange.withAlpha(30),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipPath(
                      clipper: OvalTopBorderClipper(),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 250),
                        height: _login
                            ? 450 + MediaQuery.of(context).viewInsets.bottom
                            : 350,
                        width: width,
                        color: Colors.orange.withAlpha(40),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 250),
                      curve: Curves.fastOutSlowIn,
                      padding: _login
                          ? EdgeInsets.only(bottom: 180)
                          : EdgeInsets.only(bottom: 248),
                      child: ClipRect(
                        child: SvgPicture.asset(
                          "assets/images/undraw_medical_research_doctor.svg",
                          width: 100,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 32, right: 32),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 250),
                        curve: Curves.fastOutSlowIn,
                        width: _login ? 36 : 0,
                        height: 36,
                        child: ClipRect(
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.all(6),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => HELP_DIALOG);
                            },
                            color: lightGrey,
                            child:
                                Icon(Icons.info_outline, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipPath(
                      clipper: OvalTopBorderClipper(),
                      child: AnimatedContainer(
                        curve: Curves.fastOutSlowIn,
                        duration: Duration(milliseconds: 250),
                        height: _login
                            ? 400 + MediaQuery.of(context).viewInsets.bottom
                            : 250,
                        width: width,
                        color: greenSwatch[800],
                        alignment: Alignment.bottomCenter,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                          ),
                          physics: NeverScrollableScrollPhysics(),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                _loginCredentials(),
                                AnimatedContainer(
                                  margin: EdgeInsets.only(
                                      top: _login && _codeSent ? 0 : 72),
                                  duration: Duration(milliseconds: 250),
                                  curve: Curves.fastOutSlowIn,
                                  height: _login && _codeSent ? 72 : 0,
                                  child: MyButton(
                                    color: _codeReady ? mainGreen : Colors.grey,
                                    onPressed: () {
                                      if (_codeReady) {
                                        loginWithPhone(_countryCode +
                                            _phoneController.text);
                                      }
                                    },
                                    text: _codeReady
                                        ? "Resend code"
                                        : _timeOutText(),
                                  ),
                                ),
                                MyButton(
                                  color: (_login &&
                                          _codeSent &&
                                          (_codeController.text.length != 6))
                                      ? Colors.grey
                                      : mainGreen,
                                  onPressed: _handleSignInButton,
                                  widget: _signingin ||
                                          (_askedCode && !_codeSent)
                                      ? SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        )
                                      : null,
                                  text: (_login && _codeSent)
                                      ? "Confirm"
                                      : "Sign in",
                                ),
                                AnimatedContainer(
                                  curve: Curves.fastOutSlowIn,
                                  duration: Duration(milliseconds: 250),
                                  height: _login ? 0 : 72,
                                  child: MyButton(
                                    color: greenSwatch[800],
                                    borderWidth: 3,
                                    onPressed: () {
                                      Navigator.of(context).pushNamed("/about");
                                    },
                                    text: "About",
                                  ),
                                ),
                                AnimatedContainer(
                                    margin: EdgeInsets.only(top: 24),
                                    curve: Curves.fastOutSlowIn,
                                    duration: Duration(milliseconds: 250),
                                    height: _login
                                        ? MediaQuery.of(context)
                                            .viewInsets
                                            .bottom
                                        : 0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BackTopBar(
                title: "Sign In", active: _login, onPressed: _willPopCallback),
          ],
        ),
      ),
    );
  }
}

