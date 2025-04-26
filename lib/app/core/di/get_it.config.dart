// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/home/data/data_sources/books_local_data_source.dart'
    as _i483;
import '../../features/home/data/data_sources/books_remote_data_source.dart'
    as _i220;
import '../../features/home/data/repositories/books_repository_impl.dart'
    as _i837;
import '../../features/home/domain/repositories/books_repository.dart' as _i599;
import '../../features/home/domain/use%20cases/get_books.dart' as _i902;
import '../../features/home/presentation/manager/cubit/books_cubit.dart'
    as _i688;
import '../utils/network/service_network.dart' as _i206;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i206.ServiceNetwork>(() => _i206.ServiceNetwork());
    gh.factory<_i483.BooksLocalDataSource>(() => _i483.BooksLocalDataSource());
    gh.factory<_i220.BooksRemoteDataSource>(
        () => _i220.BooksRemoteDataSource(gh<_i206.ServiceNetwork>()));
    gh.factory<_i599.BooksRepository>(() => _i837.BooksRepositoryImpl(
          gh<_i220.BooksRemoteDataSource>(),
          gh<_i483.BooksLocalDataSource>(),
          gh<_i895.Connectivity>(),
        ));
    gh.factory<_i902.GetBooksuseCase>(
        () => _i902.GetBooksuseCase(gh<_i599.BooksRepository>()));
    gh.factory<_i688.BooksCubit>(() => _i688.BooksCubit(
          gh<_i902.GetBooksuseCase>(),
          gh<_i895.Connectivity>(),
        ));
    return this;
  }
}
