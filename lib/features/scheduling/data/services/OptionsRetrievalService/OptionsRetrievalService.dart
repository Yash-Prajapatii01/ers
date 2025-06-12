abstract class OptionsRetrievalService<T> {
  Future<List<T>> search(String query);
}