import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image(
                      width: double.infinity,
                      height: 500,
                      image: AssetImage('assets/image/logo.png')
                    ),
                  ),
                  CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                    //color: Color(0xffed3d38)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
