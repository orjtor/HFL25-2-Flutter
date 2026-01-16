import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v08_bloc_counter/feature/counter/Bloc/counter_state.dart';
import 'package:v08_bloc_counter/feature/counter/Event/counter_event.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState(0)) {
    on<CounterIncrementPressed>(_onIncrementPressed);
  }

  void _onIncrementPressed(
    CounterIncrementPressed event,
    Emitter<CounterState> emit,
  ) {
    emit(CounterState(state.value + 1));
  }
}
