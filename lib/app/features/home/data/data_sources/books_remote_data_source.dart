import 'package:booksy/app/core/error/failure.dart';
import 'package:booksy/app/core/utils/network/service_network.dart';
import 'package:booksy/app/features/home/data/models/books/books.model.dart';
import 'package:injectable/injectable.dart';

@injectable
class BooksRemoteDataSource {
  final ServiceNetwork serviceNetwork;
  BooksRemoteDataSource(this.serviceNetwork);

  Future<Books> getBooks({int page = 1, String? query}) async {
    try {
      Map<String, dynamic> queryParams = {'page': page.toString()};
      if (query != null && query.isNotEmpty) {
        queryParams['search'] = query;
      }
      final response =
          await serviceNetwork.get(url: "/books", query: queryParams);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        return Books.fromJson(data);
      } else {
        return Books.fromJson(response.data);
      }
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
