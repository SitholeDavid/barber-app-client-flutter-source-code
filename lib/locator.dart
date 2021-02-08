import 'package:barber_app_client/core/services/auth_service/auth_service.dart';
import 'package:barber_app_client/core/services/auth_service/auth_service_interface.dart';
import 'package:barber_app_client/core/services/database_service/database_service.dart';
import 'package:barber_app_client/core/services/database_service/database_service_interface.dart';
import 'package:barber_app_client/core/services/firestore_service/firestore_service.dart';
import 'package:barber_app_client/core/services/firestore_service/firestore_service_interface.dart';
import 'package:barber_app_client/core/services/local_notifications_service/local_notification_service.dart';
import 'package:barber_app_client/core/services/local_notifications_service/local_notification_service_interface.dart';
import 'package:barber_app_client/core/services/payment_service/payment_service_interface.dart';
import 'package:barber_app_client/core/services/payment_service/payment_service.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite_migration_service/sqflite_migration_service.dart';
import 'package:stacked_services/stacked_services.dart';

import 'core/services/cloud_messaging_service/cloud_messaging_service.dart';
import 'core/services/cloud_messaging_service/cloud_messaging_service_interface.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => DatabaseMigrationService());

  locator
      .registerLazySingleton<PaymentServiceInterface>(() => PaymentService());
  locator
      .registerLazySingleton<DatabaseServiceInterface>(() => DatabaseService());
  locator.registerLazySingleton<LocalNotificationServiceInterface>(
      () => LocalNotificationService());
  locator.registerLazySingleton<AuthServiceInterface>(() => AuthService());
  locator.registerLazySingleton<FirestoreServiceInterface>(
      () => FirestoreService());
  locator.registerLazySingleton<CloudMessagingServiceInterface>(
      () => CloudMessagingService());
}
