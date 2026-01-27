import 'package:rxdart/rxdart.dart';

abstract class BaseBloc {

  final _showProgressSubject = BehaviorSubject<bool>();
  Stream<bool> get progressStatusObservable => _showProgressSubject.stream;
  Function(bool) get toggleProgress => _showProgressSubject.sink.add;

}