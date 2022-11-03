import 'package:app_footp/mainMap.dart';
import 'package:app_footp/signUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dio/dio.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool obscurePassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
                child: ListView(
              children: <Widget>[
                // 앱 이름
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'FootP',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),

                //로그인 글자
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 20),
                    )),

                //이메일 입력 창
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'User Email',
                      )),
                ),

                SizedBox(height: 20),
                //비밀번호 입력창
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    obscureText: obscurePassword,
                    controller: passwordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        suffixIcon: obscurePassword == true
                            ? IconButton(
                                icon: Icon(Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                              )
                            : IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                              )),
                  ),
                ),
                SizedBox(height: 20),
                // 로그인 버튼
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Sign In'),
                      onPressed: () {
                        signIn();
                      },
                    )),

                SizedBox(height: 20),
                Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('아직 계정이 없으신가요?'),
                        TextButton(
                          child: Text('회원가입 하기'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                        ),
                      ],
                    )),
              ],
            ))));
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(message),
          actions: <Widget>[
            new ElevatedButton(
              child: new Text("확인"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future signIn() async {
    var dio = Dio();
    var data = {
      'userEmail': emailController.text,
      'userPassword': passwordController.text,
    };
    final response =
        await dio.post('http://k7a108.p.ssafy.io:8080/auth/signin', data: data);

    print('####################################');
    print(response.data['message']);
    print('####################################');

    if (response.data['message'] == 'fail') {
      _showDialog('로그인 실패');
    } else {
      final snackBar = SnackBar(
        content: Text('로그인 성공!', style: TextStyle(color: Colors.green)),
        action: SnackBarAction(
          label: '확인',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => mainMap()));
    }
  }
}
