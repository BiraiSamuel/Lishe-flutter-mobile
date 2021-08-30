import 'package:flutter/widgets.dart';

class CountProvider extends InheritedWidget {
  final Widget child;
  final Counter counter;
  CountProvider({Key? key,required this.child, required this.counter})
      : super(key: key, child: child);

  static CountProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CountProvider>()
    as CountProvider);
  }

  @override
  bool updateShouldNotify(CountProvider oldWidget) {
    return true;
  }
}

class Counter {
  int count;
  Counter(this.count);
  increment() {
    count++;
  }
  decrement() {
    count--;
  }
}