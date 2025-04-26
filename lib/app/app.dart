import 'package:booksy/app/core/di/get_it.dart';
import 'package:booksy/app/core/routes/routes_gen.dart';
import 'package:booksy/app/core/routes/routes_name.dart';
import 'package:booksy/app/core/theme/theme.dart';
import 'package:booksy/app/features/home/presentation/manager/cubit/books_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        builder: (_, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<BooksCubit>(
                create: (context) => getIt<BooksCubit>(),
              ),
            ],
            child: MaterialApp(
              title: 'Booksy',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.darkTheme,
              initialRoute: RoutesName.splash,
              navigatorKey: navigatorKey,
              onGenerateRoute: RouteGenerator.generateRoute,
            ),
          );
        });
  }
}
