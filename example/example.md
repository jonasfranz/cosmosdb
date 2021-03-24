```dart
import 'package:cosmosdb/cosmosdb.dart';

void main() {
    final cosmosDB = CosmosDB(
      masterKey: '<YOUR_MASTER_KEY>',
      baseUrl: '<YOUR_BASE_URL>',
    );
    // get all documents from a collection
    final documents = cosmosDB.documents.list('<YOUR_DATABASE>', '<YOUR_COLLECTION>');
    print(documents);
}
```