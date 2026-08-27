import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'core/network/dio_client.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/dashboard/domain/repositories/dashboard_repository.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/services/data/datasources/service_remote_data_source.dart';
import 'features/services/data/repositories/service_repository_impl.dart';
import 'features/services/domain/repositories/service_repository.dart';
import 'features/services/presentation/bloc/service_bloc.dart';
import 'features/tracking/data/datasources/tracking_remote_data_source.dart';
import 'features/tracking/data/repositories/tracking_repository_impl.dart';
import 'features/tracking/domain/repositories/tracking_repository.dart';
import 'features/tracking/presentation/bloc/tracking_bloc.dart';
import 'features/mechanic/data/datasources/mechanic_remote_data_source.dart';
import 'features/mechanic/data/repositories/mechanic_repository_impl.dart';
import 'features/mechanic/domain/repositories/mechanic_repository.dart';
import 'features/mechanic/presentation/bloc/mechanic_bloc.dart';
import 'features/mechanic_dashboard/data/datasources/mechanic_dashboard_remote_data_source.dart';
import 'features/mechanic_dashboard/data/repositories/mechanic_dashboard_repository_impl.dart';
import 'features/mechanic_dashboard/domain/repositories/mechanic_dashboard_repository.dart';
import 'features/mechanic_dashboard/presentation/bloc/mechanic_dashboard_bloc.dart';
import 'features/mechanic_jobs/data/datasources/mechanic_job_remote_data_source.dart';
import 'features/mechanic_jobs/data/repositories/mechanic_job_repository_impl.dart';
import 'features/mechanic_jobs/domain/repositories/mechanic_job_repository.dart';
import 'features/mechanic_jobs/presentation/bloc/mechanic_job_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core Network
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<DioClient>(() => DioClient(dio: sl()));

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSource(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<ServiceRemoteDataSource>(
    () => ServiceRemoteDataSource(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<TrackingRemoteDataSource>(
    () => TrackingRemoteDataSource(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<MechanicRemoteDataSource>(
    () => MechanicRemoteDataSource(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<MechanicDashboardRemoteDataSource>(
    () => MechanicDashboardRemoteDataSource(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<MechanicJobRemoteDataSource>(
    () => MechanicJobRemoteDataSource(sl<DioClient>().dio),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ServiceRepository>(
    () => ServiceRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<TrackingRepository>(
    () => TrackingRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<MechanicRepository>(
    () => MechanicRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<MechanicDashboardRepository>(
    () => MechanicDashboardRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<MechanicJobRepository>(
    () => MechanicJobRepositoryImpl(remoteDataSource: sl()),
  );

  // Blocs
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(authRepository: sl()),
  );
  sl.registerFactory<DashboardBloc>(
    () => DashboardBloc(dashboardRepository: sl()),
  );
  sl.registerFactory<ServiceBloc>(
    () => ServiceBloc(serviceRepository: sl()),
  );
  sl.registerFactory<TrackingBloc>(
    () => TrackingBloc(trackingRepository: sl()),
  );
  sl.registerFactory<MechanicBloc>(
    () => MechanicBloc(mechanicRepository: sl()),
  );
  sl.registerFactory<MechanicDashboardBloc>(
    () => MechanicDashboardBloc(repository: sl()),
  );
  sl.registerFactory<MechanicJobBloc>(
    () => MechanicJobBloc(repository: sl()),
  );
}
