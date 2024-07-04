enum ElementState {initial, loading, loaded, error}

class DataState {
  ElementState state;
  String message;

  DataState({required this.state, required this.message});

  DataState.empty() :
  state = ElementState.initial,
  message = '';
}