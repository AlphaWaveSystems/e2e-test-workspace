import '../../domain/entities/item.dart';
import '../../domain/repositories/item_repository.dart';
import '../datasources/item_remote_datasource.dart';

class ItemRepositoryImpl implements ItemRepository {
  final ItemRemoteDatasource remoteDatasource;

  ItemRepositoryImpl({ItemRemoteDatasource? remoteDatasource})
      : remoteDatasource = remoteDatasource ?? ItemRemoteDatasource();

  @override
  Future<List<Item>> getItems() async {
    return remoteDatasource.fetchItems();
  }

  @override
  Future<Item> createItem(String title) async {
    final items = await getItems();
    final newId = items.isEmpty ? 1 : items.last.id + 1;
    return Item(id: newId, title: title);
  }
}
