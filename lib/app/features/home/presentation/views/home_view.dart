import 'package:booksy/app/core/ui/widgets/custom_snack_bar.dart';
import 'package:booksy/app/features/home/presentation/manager/cubit/books_cubit.dart';
import 'package:booksy/app/features/home/presentation/views/widgets/home_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<BooksCubit, BooksState>(
        listener: (context, state) {
          if (state is BooksOfflineState) {
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar.show(
                context: context,
                message: "You are offline now! ",
                snackBarType: SnackBarType.alert));
          }
        },
        child: const SafeArea(child: HomeViewBody()),
      ),
    );
  }
}
