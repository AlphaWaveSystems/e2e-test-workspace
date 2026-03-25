import '../entities/item.dart';
import '../repositories/item_repository.dart';

class GetItemsUseCase {
  final ItemRepository repository;

  const GetItemsUseCase(this.repository);

  Future<List<Item>> call() {
    return repository.getItems();
  }
}
