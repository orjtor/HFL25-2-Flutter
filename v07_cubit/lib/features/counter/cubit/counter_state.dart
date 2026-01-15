/// State-klass för CounterCubit
///
/// Innehåller tre viktiga properties:
/// - [isLoading]: Indikerar om en async operation pågår
/// - [count]: Det faktiska räknarvärdet (vår data)
/// - [error]: Ev. felmeddelande om något går fel
class CounterState {
  final bool isLoading;
  final int count;
  final String? error;

  const CounterState({this.isLoading = false, this.count = 0, this.error});

  /// CopyWith-metod för att skapa en ny state med uppdaterade värden
  /// Detta följer immutability-principen i Bloc/Cubit
  CounterState copyWith({bool? isLoading, int? count, String? error}) {
    return CounterState(
      isLoading: isLoading ?? this.isLoading,
      count: count ?? this.count,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'CounterState(isLoading: $isLoading, count: $count, error: $error)';
}
