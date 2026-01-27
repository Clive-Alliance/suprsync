import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:suprsync/services/clock_in_services.dart';
import '../../bloc/base/base_bloc.dart';
import '../../models/event_schedule.dart';
import '../../models/off_day_schedule.dart';
import '../../presentation/dashboard_screen/auth/controller/auth_controller.dart';

class ClockInBloc extends BaseBloc {

  static ClockInBloc sharedInstance = ClockInBloc();
  final _repo = ClockinServices();
  final AuthController _authController = Get.find();

  final _shiftScheduleSubject = PublishSubject<List<EventSchedule>>();
  Stream<List<EventSchedule>> get shiftScheduleResponse => _shiftScheduleSubject.stream;
  void shiftSchedule({required DateTime? from}) async {
    if(from == null){
      _shiftScheduleSubject.sink.addError('Invalid date');
      return;
    }
    try {
      toggleProgress(true);
      await _repo.shiftSchedule(
        from.toIso8601String(),
        _authController.token.value,
      ).then((response) {
        print(response);
        _shiftScheduleSubject.sink.add(response);
        toggleProgress(false);
      }, onError: (e) {
        _shiftScheduleSubject.sink.addError(e);
        toggleProgress(false);
      });
    } catch (e) {
      _shiftScheduleSubject.sink.addError(e);
    }
  }

  final _offDaysSubject = PublishSubject<OffDaySchedule>();
  Stream<OffDaySchedule> get offDaysResponse => _offDaysSubject.stream;
  void offDays({required DateTime? from}) async {
    if(from == null){
      _offDaysSubject.sink.addError('Invalid date');
      return;
    }
    try {
      toggleProgress(true);
      await _repo.offDays(
        from.toIso8601String(),
        _authController.token.value,
      ).then((response) {
        _offDaysSubject.sink.add(response);
        toggleProgress(false);
      }, onError: (e) {
        _offDaysSubject.sink.addError(e);
        toggleProgress(false);
      });
    } catch (e) {
      _offDaysSubject.sink.addError(e);
    }
  }

}