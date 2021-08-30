import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class User {
  String firstName;
  String lastName;
  String email;
  String mobile;
  String code;
  String state;

  User(this.firstName, this.lastName, this.email, this.mobile, this.code, this.state);
}

class StateContainer extends StatefulWidget {
  final Widget child;
  final User user;

  StateContainer({
    required this.child,
    required this.user,
  });

  static StateContainerState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedStateContainer>()!
        .data;
  }

  @override
  StateContainerState createState() => new StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  User? user;

  void updateUserInfo({firstName, lastName, email, mobile, code, state}) {
    if (user == null) {
      user = new User(firstName, lastName, email, mobile, code, state);
      setState(() {
        user = user;
      });
    } else {
      setState(() {
        user!.firstName = firstName ?? user!.firstName;
        user!.lastName = lastName ?? user!.lastName;
        user!.email = email ?? user!.email;
        user!.mobile = email ?? user!.mobile;
        user!.code = email ?? user!.code;
        user!.state = email ?? user!.state;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  _InheritedStateContainer({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}