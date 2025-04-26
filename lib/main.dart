import 'package:booksy/app/app.dart';
import 'package:booksy/app/core/di/get_it.dart';
import 'package:booksy/app/features/home/data/models/local%20data%20models/cached_book_model.dart';
import 'package:booksy/app/features/home/data/models/local%20data%20models/cached_books_result_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(CachedBookAdapter());
  Hive.registerAdapter(CachedBooksResultAdapter());
  
  // Open Hive boxes
  await Hive.openBox<CachedBooksResult>('books_results');
  
  setupLocator();

  runApp(const MyApp());
}