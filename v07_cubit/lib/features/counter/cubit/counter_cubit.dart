import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_state.dart';

/// CounterCubit med state-klass
/// Demonstrerar async operations med isLoading state
class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterState());

  /// Synkron increment - direkt utan loading state
  void increment() {
    emit(state.copyWith(count: state.count + 1));
  }

  /// Synkron decrement
  void decrement() {
    emit(state.copyWith(count: state.count - 1));
  }

  /// Async increment med 2 sekunders delay
  /// Demonstrerar isLoading state och error handling
  Future<void> incrementAsync() async {
    try {
      // Sätt isLoading till true och rensa ev. tidigare error
      emit(state.copyWith(isLoading: true, error: null));

      // Simulera async operation (t.ex. API-call)
      await Future.delayed(const Duration(seconds: 2));

      // Uppdatera count och sätt isLoading till false
      emit(state.copyWith(isLoading: false, count: state.count + 1));
    } catch (e) {
      // Om något går fel, sätt error och isLoading till false
      emit(state.copyWith(isLoading: false, error: 'Failed to increment: $e'));
    }
  }

  /// Reset counter till 0
  void reset() {
    emit(const CounterState());
  }
}
